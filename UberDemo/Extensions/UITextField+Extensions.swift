//
//  UITextField+Extensions.swift
//  UberDemo
//
//  Created by Sumit Jain on 30/06/19.
//  Copyright © 2019 Sumit Jain. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
  func setBottomBorder() {
    borderStyle = .none
    layer.backgroundColor = UIColor.white.cgColor
    
    layer.masksToBounds = false

    layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    layer.shadowOpacity = 1.0
    layer.shadowRadius = 0.0
  }
}
