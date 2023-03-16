//
//  GalleryCollectionViewCell.swift
//  Image Gallery
//
//  Created by Максим Митрофанов on 14.03.2023.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    
    var imageURL: URL? { didSet { updateDisplayedImage() }}
    
    func setup(with url: URL) {
        imageURL = url
    }
    
    private func updateDisplayedImage() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let imageURL = self?.imageURL {
                guard let urlContents = try? Data(contentsOf: imageURL) else { return }
                guard let fetchedImage = UIImage(data: urlContents) else { return }
                
                DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = fetchedImage
                }
            }
        }
    }
}
