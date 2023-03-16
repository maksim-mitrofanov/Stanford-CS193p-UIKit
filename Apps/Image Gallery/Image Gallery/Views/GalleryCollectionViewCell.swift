//
//  GalleryCollectionViewCell.swift
//  Image Gallery
//
//  Created by Максим Митрофанов on 14.03.2023.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    
    func setup(with url: URL) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let urlContents = try? Data(contentsOf: url) else { return }
            guard let fetchedImage = UIImage(data: urlContents) else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = fetchedImage
            }
        }
    }
}
