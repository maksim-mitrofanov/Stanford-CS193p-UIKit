//
//  EmojiArtView.swift
//  EmojiArt
//
//  Created by Максим Митрофанов on 01.03.2023.
//

import UIKit

class EmojiArtView: UIView {
    var imageToDisplay: UIImage? { didSet { setNeedsDisplay() }}
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = .black
        self.subviews.forEach { $0.removeFromSuperview() }
        
        let imageView = UIImageView(image: imageToDisplay)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        self.addSubview(imageView)
    }
}
