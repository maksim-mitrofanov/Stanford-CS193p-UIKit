//
//  PhotoSelectorViewController.swift
//  Curiosity Mission
//
//  Created by Максим Митрофанов on 26.02.2023.
//

import UIKit

class PhotoSelectorViewController: UIViewController {
    @IBOutlet var selectionButtons: [UIButton]! {
        didSet {
            selectionButtons.forEach { $0.layer.cornerRadius = 12 }
        }
    }
    
    private let localGallery = [
        "Postcard": UIImage(named: "Postcard"),
        "Brush": UIImage(named: "Brush"),
        "Selfie": UIImage(named: "Selfie"),
        "Rocks": UIImage(named: "Rocks")
    ]
    
    private let serverURLs = [
        "Drill" : URL(string: "https://www.nasa.gov/sites/default/files/styles/full_width_feature/public/thumbnails/image/pia22066_0.jpg"),
        "Holder Crater" : URL(string: "https://www.nasa.gov/sites/default/files/styles/full_width_feature/public/thumbnails/image/pia23952.jpg"),
        "Funzie" : URL(string: "https://www.nasa.gov/sites/default/files/styles/full_width_feature/public/thumbnails/image/pia22212-nasa.jpg"),
        "Broken Link" : URL(string: "https://www.nasa.gov/sites/default/files/styles/full_width_feature/public/thumbnails/image/pia22212-nasa.jp")
    ]

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if let contentView = segue.destination as? PhotoPresenterViewController {
                if let localPhoto = localGallery[identifier] as? UIImage {
                    contentView.setLocalPhoto(to: localPhoto)
                } else if let photoURL = serverURLs[identifier] as? URL {
                    contentView.setPhotoURL(to: photoURL)
                }
                contentView.title = (sender as? UIButton)?.currentTitle
            }
        }
    }
}
