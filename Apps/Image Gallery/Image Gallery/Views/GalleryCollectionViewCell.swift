//
//  GalleryCollectionViewCell.swift
//  Image Gallery
//
//  Created by Максим Митрофанов on 14.03.2023.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    @IBOutlet private(set) weak var imageView: UIImageView!
    
    var imageURL: URL? {
        didSet {
            if imageURL != nil {
                updateDisplayedImage(url: imageURL!)
            }
        }
    }
    
    func setup(with url: URL) {
        imageURL = url
    }
    
    private func updateDisplayedImage(url: URL) {
        if let cachedData = GalleryModel.loadFromCache(url: url) {
            print("Did find cache")
            imageView.image = UIImage(data: cachedData)
        }
        
        else {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let imageURL = self?.imageURL {
                    guard let urlContents = try? Data(contentsOf: imageURL) else { return }
                    guard let fetchedImage = UIImage(data: urlContents) else { return }
                    GalleryModel.saveToCache(url: url, with: urlContents)
                    print("Saving to cache.")
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.imageView.image = fetchedImage
                    }
                }
            }
        }
    }
}
