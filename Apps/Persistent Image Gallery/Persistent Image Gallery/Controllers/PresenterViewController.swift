//
//  PresenterViewController.swift
//  Image Gallery
//
//  Created by Максим Митрофанов on 16.03.2023.
//

import UIKit

class PresenterViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 1 / 2
            scrollView.maximumZoomScale = 5
            scrollView.delegate = self
            scrollView.addSubview(imagePreview)
            imagePreview.image = imageToDisplay
            imagePreview.sizeToFit()
            scrollView.contentSize = imagePreview.frame.size
        }
    }
    
    private var imagePreview = UIImageView()
    private var imageToDisplay: UIImage?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func setup(with image: UIImage) {
        imageToDisplay = image
    }
}

extension PresenterViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imagePreview
    }
}
