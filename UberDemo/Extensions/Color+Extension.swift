//
//  Color+Extension.swift
//  UberDemo
//
//  Created by Sumit Jain on 07/07/19.
//  Copyright © 2019 Sumit Jain. All rights reserved.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
