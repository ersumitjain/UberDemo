//
//  ImageCell.swift
//  UberDemo
//
//  Created by Sumit Jain on 30/06/19.
//  Copyright © 2019 Sumit Jain. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {
    //MARK: Outlets
    @IBOutlet private weak var imgView          : UIImageView!
    @IBOutlet private weak var indicatorView    : UIActivityIndicatorView!
    
    //MARK: Lifecycle Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: .none)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        indicatorView.hidesWhenStopped = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
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
            indicatorView.stopAnimating()
        } else {
            indicatorView.startAnimating()
        }
    }
}
