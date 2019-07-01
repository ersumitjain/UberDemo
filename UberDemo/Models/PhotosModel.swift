//
//  PhotosModel.swift
//  UberDemo
//
//  Created by Sumit Jain on 30/06/19.
//  Copyright © 2019 Sumit Jain. All rights reserved.
//

import Foundation

struct PhotosModel: Decodable {
    let photos: Photos
}

struct Photos: Decodable {
    let page: Int
    let pages: Int
    let total: String
    let photo: [PhotosList]
}

struct PhotosList: Decodable {
    let farm: Int?
    let server: String?
     let id: String?
     let secret: String?
     let title: String?
    
}
