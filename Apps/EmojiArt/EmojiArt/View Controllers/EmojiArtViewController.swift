//
//  EmojiArtViewController.swift
//  EmojiArt
//
//  Created by Максим Митрофанов on 01.03.2023.
//

import UIKit

class EmojiArtViewController: UIViewController {

    @IBOutlet var dropZone: UIView!
    @IBOutlet private weak var emojiArtView: EmojiArtView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultBackground()
        setDropInteraction()
    }
    
    override func viewDidLayoutSubviews() {
        emojiArtView.redraw()
    }
    
    private func setDropInteraction() {
        let drop = UIDropInteraction(delegate: self)
        emojiArtView.addInteraction(drop)
    }
    
    private func setDefaultBackground() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.activityIndicator.stopAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.emojiArtView.imageToDisplay = UIImage(named: "Curiosity_Selfie")
            }
        }
        
    }
    
    private var imageFetcher: ImageFetcher!
}

extension EmojiArtViewController: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        let canLoadImage = session.canLoadObjects(ofClass: UIImage.self)
        let canLoadURL = session.canLoadObjects(ofClass: NSURL.self)
        
        return canLoadURL && canLoadImage
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        imageFetcher = ImageFetcher() { (url, image) in
            DispatchQueue.main.async {
                self.emojiArtView.imageToDisplay = image
            }
        }
        
        session.loadObjects(ofClass: UIImage.self) { imageProviders in
            if let loadedImage = imageProviders.first as? UIImage {
                self.imageFetcher.backup = loadedImage
            }
        }
        
        session.loadObjects (ofClass: NSURL.self) { urlProviders in
            if let loadedURL = urlProviders.first as? URL {
                self.imageFetcher.fetch(loadedURL)
            }
        }
    }
}
