//
//  PhotoPresenterViewController.swift
//  Curiosity Mission
//
//  Created by Максим Митрофанов on 24.02.2023.
//

import UIKit

class PhotoPresenterViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            scrollView.addSubview(imageView)
            scrollView.minimumZoomScale = 1/10
            scrollView.maximumZoomScale = 0.5
        }
    }
    private var imageView = UIImageView()
    
    private var displayedImage: UIImage? {
        get { imageView.image }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }
    
    private var imageURL: URL? {
        didSet {
            displayedImage = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    
    
    
    private func fetchImage() {
       displayedImage = UIImage(named: "MarsFromTop")
    }
    
    func setLocalPhoto(to image: UIImage) {
        displayedImage = image
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        if displayedImage == nil {
            fetchImage()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageView.image == nil {
            fetchImage()
        }
    }
}

extension PhotoPresenterViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
