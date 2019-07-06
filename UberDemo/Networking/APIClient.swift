//
//  APIClient.swift
//  UberDemo
//
//  Created by Sumit Jain on 30/06/19.
//  Copyright © 2019 Sumit Jain. All rights reserved.
//

import Foundation
import UIKit

final class APIClient {
    private lazy var baseURL: URL = {
        return URL(string: UBConstants.baseURL)!
    }()
    
    let session: URLSession
    static let imageCache = NSCache<NSString, UIImage>()
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchPhotos(with request: UBRequest, page: Int, completion: @escaping (Result<Photos, DataResponseError>) -> Void) {
        let urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
        let parameters = ["page": "\(page)"].merging(request.parameters, uniquingKeysWith: +)
        let encodedURLRequest = urlRequest.encode(with: parameters)
        session.dataTask(with: encodedURLRequest, completionHandler: { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.hasSuccessStatusCode,
                let data = data
                else {
                    completion(Result.failure(DataResponseError.network))
                    return
            }
            
            guard let decodedResponse = try? JSONDecoder().decode(PhotosModel.self, from: data) else {
                completion(Result.failure(DataResponseError.decoding))
                return
            }
            let responseObject = decodedResponse.photos
            completion(Result.success(responseObject))
        }).resume()
    }
    
     static func downloadImage(url: URL, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage, nil)
        } else {
            APIClient.downloadData(url: url) { data, response, error in
                if let error = error {
                    completion(nil, error)
                    
                } else if let data = data, let image = UIImage(data: data) {
                    self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    completion(image, nil)
                } else {
                  //  completion(nil, NSError.generalParsingError(domain: url.absoluteString))
                }
            }
        }
    }
    
    fileprivate static func downloadData(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: url)) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
}
