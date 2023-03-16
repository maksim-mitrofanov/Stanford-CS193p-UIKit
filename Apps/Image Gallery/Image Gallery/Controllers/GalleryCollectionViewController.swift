//
//  GalleryCollectionViewController.swift
//  Image Gallery
//
//  Created by Максим Митрофанов on 13.03.2023.
//

import UIKit

private let cellReuseIdentifier = "GalleryCell"

class GalleryCollectionViewController: UICollectionViewController {
    
    private(set) var dataModel = ImageGalleryModel(name: "Empty", imageCount: 20)

    override func viewDidLoad() {     }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModel.imageCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        guard let imageCell = cell as? GalleryCollectionViewCell else { fatalError() }
        guard let imageURL = URL(string: dataModel.imageURLs[indexPath.row]) else { fatalError() }
        
        imageCell.setup(with: imageURL)
        
        return imageCell
    }
}

extension GalleryCollectionViewController: UICollectionViewDelegateFlowLayout {
    private var cellSpacing: CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsAcross: CGFloat = 7
        
        let dim = (collectionView.bounds.width - ((cellsAcross - 1) * cellSpacing)) / cellsAcross
        return CGSize(width: dim, height: dim)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}

extension GalleryCollectionViewController {
    func setupWith(model: ImageGalleryModel) {
        dataModel = model
        collectionView.reloadData()
    }
}
