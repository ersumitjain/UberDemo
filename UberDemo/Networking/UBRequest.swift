//
//  UBRequest.swift
//  UberDemo
//
//  Created by Sumit Jain on 30/06/19.
//  Copyright © 2019 Sumit Jain. All rights reserved.
//

import Foundation

struct UBRequest {
    var path: String {
        return "rest"
    }
    
    let parameters: Parameters
    private init(parameters: Parameters) {
        self.parameters = parameters
    }
}

extension UBRequest {
    static func from(text: String) -> UBRequest {
        let defaultParameters = ["method":"flickr.photos.search", "api_key": "3e7cc266ae2b0e0d78e279ce8e361736", "format": "json", "nojsoncallback": "1", "safe_search": "1"]
        let parameters = ["text": "\(text)"].merging(defaultParameters, uniquingKeysWith: +)
        return UBRequest(parameters: parameters)
    }
}
