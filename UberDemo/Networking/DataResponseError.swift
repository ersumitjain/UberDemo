//
//  DataResponseError.swift
//  UberDemo
//
//  Created by Sumit Jain on 30/06/19.
//  Copyright © 2019 Sumit Jain. All rights reserved.
//

import Foundation

enum DataResponseError: Error {
  case network
  case decoding
  
  var reason: String {
    switch self {
    case .network:
      return UBConstants.networkError.localizedString
    case .decoding:
      return UBConstants.debugError.localizedString
    }
  }
}
