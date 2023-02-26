//
//  PhotoSelectorViewController.swift
//  Curiosity Mission
//
//  Created by Максим Митрофанов on 26.02.2023.
//

import UIKit

class PhotoSelectorViewController: UIViewController {
    private let localGallery = [
        "Postcard": UIImage(named: "Postcard"),
        "Brush": UIImage(named: "Brush"),
        "Selfie": UIImage(named: "Selfie"),
        "Rocks": UIImage(named: "Rocks")
    ]

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if let contentView = segue.destination as? PhotoPresenterViewController {
                if let localPhoto = localGallery[identifier] as? UIImage {
                    contentView.setLocalPhoto(to: localPhoto)
                }
            }
        }
    }
}
