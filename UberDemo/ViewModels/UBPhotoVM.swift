//
//  UBPhotoVM.swift
//  UberDemo
//
//  Created by Sumit Jain on 08/07/19.
//  Copyright © 2019 Sumit Jain. All rights reserved.
//

import Foundation

protocol PhotoVMDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

final class UBPhotoVM {
    private weak var delegate: PhotoVMDelegate?
    private var PhotosListModel: [PhotosList] = []
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    
    let client = APIClient()
    let request: UBRequest
    
    init(request: UBRequest, delegate: PhotoVMDelegate) {
        self.request = request
        self.delegate = delegate
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return PhotosListModel.count
    }
    
    func photo(at index: Int) -> PhotosList {
        return PhotosListModel[index]
    }
    
    func fetchPhotos() {
        guard !isFetchInProgress else {
            return
        }
        isFetchInProgress = true
        client.fetchPhotos(with: request, page: currentPage) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    self.currentPage += 1
                    self.isFetchInProgress = false
                    self.total = Int(response.total) ?? 0
                    self.PhotosListModel = response.photo
                    
                    if response.page > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: response.photo)
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.delegate?.onFetchCompleted(with: .none)
                    }
                }
            }
        }
    }
    
    private func calculateIndexPathsToReload(from newList: [PhotosList]) -> [IndexPath] {
        let startIndex = PhotosListModel.count - newList.count
        let endIndex = startIndex + newList.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
