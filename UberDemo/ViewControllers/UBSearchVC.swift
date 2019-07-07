//
//  UBSearchVC.swift
//  UberDemo
//
//  Created by Sumit Jain on 30/06/19.
//  Copyright © 2019 Sumit Jain. All rights reserved.
//

import UIKit

class UBSearchVC: UIViewController {
    
    //MARK: SegueIdentifiers
    private enum SegueIdentifiers {
        static let photos = "photosSegue"
    }
    
    //MARK: Outlets
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchButton: UIButton!
    
    private var behavior: ButtonEnablingBehavior?
    
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Search", comment: "")
        behavior = ButtonEnablingBehavior(textFields: [searchTextField]) { [unowned self] enable in
            if enable {
                self.searchButton.isEnabled = true
                self.searchButton.alpha = 1
            } else {
                self.searchButton.isEnabled = false
                self.searchButton.alpha = 0.7
            }
        }
        searchTextField.setBottomBorder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.photos {
            if let photovc = segue.destination as? PhotosVC {
                photovc.searchString = searchTextField.text
            }
        }
    }
    
}
