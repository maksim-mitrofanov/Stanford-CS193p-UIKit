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
    private var cellsAcross: CGFloat = 3
    private var zoomFactor: Int = 0

    override func viewDidLoad() {
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
    }

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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell else { return }
        guard let _ = cell.imageView.image else { return }
        performSegue(withIdentifier: "PreviewSelectedImage", sender: collectionView.cellForItem(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PreviewSelectedImage" {
            guard let destinationVC = segue.destination as? PresenterViewController else { return }
            guard let sender = sender as? GalleryCollectionViewCell else { return }
            guard let image = sender.imageView.image else { return }
            destinationVC.setup(with: image)
        }
    }
}

extension GalleryCollectionViewController: UICollectionViewDelegateFlowLayout {
    private var cellSpacing: CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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

extension GalleryCollectionViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return []
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        guard let galleryCell = collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell else { return [] }
        guard let cellStoredURL = galleryCell.imageURL as? NSURL else { return [] }
        
        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: cellStoredURL))
        dragItem.localObject = cellStoredURL
        return [dragItem]
    }
}

extension GalleryCollectionViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        //Can drop only inside collection view
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        
        //Can drop only one image
        guard let firstDragItem = coordinator.items.first else { return }
        
        //Local drop (from one indexPath of collectionView to another indexPath)
        if let sourceIndexPath = firstDragItem.sourceIndexPath {
            insertLocalDragItemAtIndexPath(
                item: firstDragItem.dragItem,
                sourceIndexPath: sourceIndexPath,
                destinationIndexPath: destinationIndexPath
            )
            coordinator.drop(firstDragItem.dragItem, toItemAt: destinationIndexPath)
        }
        
        //Outside of app drop
        firstDragItem.dragItem.itemProvider.loadObject(ofClass: NSURL.self, completionHandler: { provider, error in
            DispatchQueue.main.async { [weak self] in
                guard let url = provider as? NSURL else { return }
                self?.dataModel.acceptExternalDrop(of: url as URL, to: destinationIndexPath)
                collectionView.reloadItems(at: [destinationIndexPath])
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let sessionContext = session.localDragSession?.localContext as? UICollectionView
        let isSelf = sessionContext == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    private func insertLocalDragItemAtIndexPath(item: UIDragItem, sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        guard let imageNSURL = item.localObject as? NSURL else { return }
        
        collectionView.performBatchUpdates {
            dataModel.acceptLocalDrop(of: imageNSURL as URL, from: sourceIndexPath, to: destinationIndexPath)
            collectionView.deleteItems(at: [sourceIndexPath])
            collectionView.insertItems(at: [destinationIndexPath])
        }
    }
}
