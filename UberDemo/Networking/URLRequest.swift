//
//  URLRequest.swift
//  UberDemo
//
//  Created by Sumit Jain on 30/06/19.
//  Copyright © 2019 Sumit Jain. All rights reserved.
//

import Foundation

typealias Parameters = [String: String]

extension URLRequest {
  func encode(with parameters: Parameters?) -> URLRequest {
    guard let parameters = parameters else {
      return self
    }
    
    var encodedURLRequest = self
    
    if let url = self.url,
       let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
       !parameters.isEmpty {
      var newUrlComponents = urlComponents
      let queryItems = parameters.map { key, value in
        URLQueryItem(name: key, value: value)
      }
      newUrlComponents.queryItems = queryItems
      encodedURLRequest.url = newUrlComponents.url
      return encodedURLRequest
    } else {
      return self
    }
  }
}
