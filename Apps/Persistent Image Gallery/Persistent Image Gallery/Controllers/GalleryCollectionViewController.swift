//
//  GalleryCollectionViewController.swift
//  Image Gallery
//
//  Created by Максим Митрофанов on 13.03.2023.
//

import UIKit

private let cellReuseIdentifier = "GalleryCell"

class GalleryCollectionViewController: UICollectionViewController {
    
    private var dataModel = ImageGalleryModel(name: "Template", imageURLs: ImageGalleryModel.shortURLs)
    private var cellsAcross: CGFloat { return 3 }


    
    @IBAction func done(_ sender: UIBarButtonItem) {
        saveDataModel()
        dismiss(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveDataModel()
    }
}
















// MARK: - Persistence

extension GalleryCollectionViewController {
    private var fileURL: URL {
        guard let documentsDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else { fatalError() }
        
        let filePath = documentsDirectory.appendingPathComponent("Untitled.json")
        return filePath
    }
    
    private func saveDataModel() {
        FileManager.default.createFile(atPath: fileURL.path, contents: dataModel.json)
    }
    
    private func loadDataModel() {
        let fileExists = FileManager.default.fileExists(atPath: fileURL.path)
        
        if fileExists {
            guard let contentsData = FileManager.default.contents(atPath: fileURL.path) else { return }
            guard let galleryData = ImageGalleryModel(json: contentsData) else { return }
            dataModel = galleryData
        }
    }
}









// MARK: - Navigation

extension GalleryCollectionViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PreviewSelectedImage" {
            guard let destinationVC = segue.destination as? PresenterViewController else { return }
            guard let sender = sender as? GalleryCollectionViewCell else { return }
            guard let image = sender.imageView.image else { return }
            destinationVC.setup(with: image)
        }
    }
}









// MARK: - Data Source

extension GalleryCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModel.imageURLs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        guard let imageCell = cell as? GalleryCollectionViewCell else { fatalError() }
        let imageURL = dataModel.imageURLs[indexPath.row]
        
        imageCell.setup(with: imageURL)
        
        return imageCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell else { return }
        guard let _ = cell.imageView.image else { return }
        performSegue(withIdentifier: "PreviewSelectedImage", sender: collectionView.cellForItem(at: indexPath))
    }
}









// MARK: - Flow Delegate

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









// MARK: - Drag Delegate

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









// MARK: - Drop Delegate

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
            
            collectionView.performBatchUpdates {
                coordinator.drop(firstDragItem.dragItem, toItemAt: destinationIndexPath)
                collectionView.reloadItems(at: [destinationIndexPath])
            }
        }
        
        //Outside of app drop
        else {
            firstDragItem.dragItem.itemProvider.loadObject(ofClass: NSURL.self, completionHandler: { provider, error in
                guard let url = provider as? NSURL else { return }
                
                DispatchQueue.main.async { [weak self] in
                    collectionView.performBatchUpdates {
                        self?.dataModel.acceptExternalDrop(of: url as URL, to: destinationIndexPath)
                        self?.collectionView.insertItems(at: [destinationIndexPath])
                        self?.collectionView.reloadItems(at: [destinationIndexPath])
                    }
                }
            })
        }
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
