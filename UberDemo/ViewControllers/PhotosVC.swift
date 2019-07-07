//
//  PhotosVC.swift
//  UberDemo
//
//  Created by Sumit Jain on 07/07/19.
//  Copyright © 2019 Sumit Jain. All rights reserved.
//

import UIKit

class PhotosVC: UIViewController, AlertDisplayer  {
    //MARK: Outlets
    @IBOutlet private weak var photoCollectionView: UICollectionView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    
    var searchString: String?
    private var viewModel: UBPhotoVM?
    
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.color = #colorLiteral(red: 0.8431372549, green: 0.3058823529, blue: 0.1764705882, alpha: 1)
        indicatorView.startAnimating()
        guard let searchText = searchString else {
            return
        }
        title = NSLocalizedString(searchText, comment: "")
        let request = UBRequest.from(text: searchText)
        viewModel = UBPhotoVM(request: request, delegate: self)
        viewModel?.fetchPhotos()
    }
    
}

//MARK: CollectionView DataSource Methods
extension PhotosVC : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = viewModel?.totalCount{
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as! PhotosCell
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            cell.configure(with: viewModel?.photo(at: indexPath.row))
        }
        return cell
    }
}

//MARK: CollectionView FlowLayout Methods
extension PhotosVC : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  5
        return CGSize(width: collectionView.frame.size.width/3 - 2 * padding, height: collectionView.frame.size.height/3 - padding)
    }
}

//MARK: ViewModel Delegate Methods
extension PhotosVC: PhotoVMDelegate{
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            DispatchQueue.main.async {
                self.indicatorView.stopAnimating()
                self.photoCollectionView.reloadData()
            }
            return
        }
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        DispatchQueue.main.async {
            self.self.photoCollectionView.reloadItems(at: indexPathsToReload)
        }
    }
    
    func onFetchFailed(with reason: String) {
        indicatorView.stopAnimating()
        let title = "Warning".localizedString
        let action = UIAlertAction(title: "OK".localizedString, style: .default)
        displayAlert(with: title , message: reason, actions: [action])
    }
}


private extension PhotosVC {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        if let count = viewModel?.currentCount{
            return indexPath.row >= count
        }
        return false
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = photoCollectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
