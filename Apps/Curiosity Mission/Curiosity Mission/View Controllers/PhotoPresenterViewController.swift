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
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView! {
        
    }
    
    private var imageView = UIImageView()
    
    private var displayedImage: UIImage? {
        get { imageView.image }
        set {
            scrollView?.isHidden = false
            activityIndicator?.isHidden = true
            imageView.image = newValue
            imageView.contentMode = .scaleAspectFill
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }
    
    private var imageURL: URL? {
        didSet {
            displayedImage = nil
            scrollView?.isHidden = true
            activityIndicator?.isHidden = false
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    
    private func updateDisplayedPhoto() {
        if imageURL == nil && displayedImage == nil {
            setDefaultPhoto()
        } else {
            fetchImage()
        }
    }
    
    private func setDefaultPhoto() {
        displayedImage = UIImage(named: "MarsFromTop")
    }
    
    private func fetchImage() {
        if let currentPhotoURL = imageURL {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: currentPhotoURL)
                DispatchQueue.main.async {
                    if let data = urlContents, currentPhotoURL == self?.imageURL {
                        self?.displayedImage = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    func setLocalPhoto(to image: UIImage) {
        displayedImage = image
    }
    
    func setPhotoURL(to url: URL) {
        imageURL = url
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        updateDisplayedPhoto()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateDisplayedPhoto()
    }
}

extension PhotoPresenterViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
