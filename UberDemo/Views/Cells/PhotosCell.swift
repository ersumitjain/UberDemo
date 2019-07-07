//
//  PhotosCell.swift
//  UberDemo
//
//  Created by Sumit Jain on 07/07/19.
//  Copyright © 2019 Sumit Jain. All rights reserved.
//

import UIKit

class PhotosCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    //MARK: Lifecycle Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: .none)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView.backgroundColor = UIColor.random
        
    }
    
    func configure(with photosList: PhotosList?) {
        if let photosList = photosList, let farm = photosList.farm, let server = photosList.server, let id = photosList.id, let secret = photosList.secret{
            let urlString = "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
            
            guard let url = URL.init(string: urlString) else{
                return
            }
            APIClient.downloadImage(url: url) { (img, err) in
                DispatchQueue.main.async { [weak self] in
                    self?.imgView.image = img
                }
            }
        }
    }
}
