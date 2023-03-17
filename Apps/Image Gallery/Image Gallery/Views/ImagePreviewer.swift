//
//  ImagePreviewer.swift
//  Image Gallery
//
//  Created by Максим Митрофанов on 16.03.2023.
//

import UIKit

class ImagePreviewer: UIView {
    
    var imageToDisplay: UIImage? { didSet { setNeedsDisplay() }}

    override func draw(_ rect: CGRect) {
        imageToDisplay?.draw(in: self.bounds)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }    
}
