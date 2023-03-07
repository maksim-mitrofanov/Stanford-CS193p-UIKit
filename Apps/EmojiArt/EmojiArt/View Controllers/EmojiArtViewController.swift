//
//  EmojiArtViewController.swift
//  EmojiArt
//
//  Created by Максим Митрофанов on 01.03.2023.
//

import UIKit

class EmojiArtViewController: UIViewController {

    @IBOutlet var dropZone: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var emojiCollectionView: UICollectionView! {
        didSet {
            emojiCollectionView.dataSource = self
            emojiCollectionView.delegate = self
            emojiCollectionView.dragDelegate = self
            emojiCollectionView.dropDelegate = self
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 1/4
            scrollView.maximumZoomScale = 2.0
            scrollView.delegate = self
            scrollView.addSubview(emojiArtView)
        }
    }
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewWidthConstraint: NSLayoutConstraint!
    
    
    private var emojiArtView = EmojiArtView()
    private var imageFetcher: ImageFetcher!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDropInteraction()
        activityIndicator.startAnimating()
        emojiArtBackgroundImage = UIImage(named: "Curiosity_Selfie")
    }
    
    private func setDropInteraction() {
        let drop = UIDropInteraction(delegate: self)
        dropZone.addInteraction(drop)
    }
    
    private func setDefaultBackground() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.activityIndicator.stopAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.emojiArtBackgroundImage = UIImage(named: "Curiosity_Selfie")
            }
        }
        
    }
    
    var emojis = "🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷".map { $0.description }
    private var isAddingEmojis: Bool = false
    
    @IBAction private func addEmoji() {
        if isAddingEmojis { emojis.remove(at: 0) }
        else { emojis = [" "] + emojis }
        
        isAddingEmojis.toggle()
        emojiCollectionView.reloadSections(IndexSet(integer: 1))
    }
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
        emojiArtBackgroundImage = nil
        activityIndicator.startAnimating()
        
        imageFetcher = ImageFetcher() { (url, image) in
            DispatchQueue.main.async {
                self.emojiArtBackgroundImage = image
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

extension EmojiArtViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        emojiArtView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewHeightConstraint.constant = scrollView.contentSize.height
        scrollViewWidthConstraint.constant = scrollView.contentSize.width
    }
    
    private var emojiArtBackgroundImage: UIImage? {
        get { emojiArtView.imageToDisplay }
        set {
            scrollView?.zoomScale = 1.0
            emojiArtView.imageToDisplay = newValue
            let size = newValue?.size ?? CGSize.zero
            emojiArtView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
            scrollView?.contentSize = size
            scrollViewHeightConstraint?.constant = size.height
            scrollViewWidthConstraint?.constant = size.width
            
            if let dropZone = self.dropZone, size.width > 0, size.height > 0 {
                scrollView.zoomScale = max(
                    dropZone.bounds.size.width / size.width,
                    dropZone.bounds.size.height / size.height
                )
            }
            activityIndicator.stopAnimating()
        }
    }
}

extension EmojiArtViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        else { return emojis.count }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //First cell
        if indexPath.section == 0 {
            let addEmojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddEmojiCell", for: indexPath)
            return addEmojiCell
        }
        
        else {
            //Input Cell
            if isAddingEmojis && indexPath.item == 0 {
                let inputCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextFieldCell", for: indexPath)
                
                if let textFieldCell = inputCell as? TextFieldCollectionViewCell {
                    textFieldCell.resignationHandler = { [weak self, unowned textFieldCell] in
                        if let text = textFieldCell.textField.text {
                            self?.emojis.remove(at: 0)
                            self?.emojis = [text] + self!.emojis
                            self?.isAddingEmojis = false
                            self?.emojiCollectionView.reloadData()
                        }
                    }
                }
                
                return inputCell
            }
            
            //Emoji Cell
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath)
                
                if let emojiCell = cell as? EmojiCollectionViewCell {
                    emojiCell.mainLabel.text = emojis[indexPath.item].description
                    
                }
                
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let inputCell = cell as? TextFieldCollectionViewCell {
            inputCell.textField.becomeFirstResponder()
        }
    }
}

extension EmojiArtViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if !isAddingEmojis, let text = (emojiCollectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell)?.mainLabel.text {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: NSAttributedString(string: text)))
            dragItem.localObject = NSAttributedString(string: text)
            return [dragItem]
        }
        return []
    }
}

extension EmojiArtViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        
        coordinator.items.forEach { item in
            //Local
            if let sourceIndexPath = item.sourceIndexPath {
                if let attributedString = item.dragItem.localObject as? NSAttributedString {
                    collectionView.performBatchUpdates {
                        emojis.remove(at: sourceIndexPath.item)
                        emojis.insert(attributedString.string, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    }
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
                
            }
            //Non local
            else {
                let dropPlaceholder = UICollectionViewDropPlaceholder(
                    insertionIndexPath: destinationIndexPath,
                    reuseIdentifier: "DropPlaceholderCell"
                )
                
                let placeholderContext = coordinator.drop(item.dragItem, to: dropPlaceholder)
                
                item.dragItem.itemProvider.loadObject(ofClass: NSAttributedString.self) { (provider, error) in
                    DispatchQueue.main.async {
                        //Successfully fetched data
                        if let text = provider as? NSAttributedString {
                            placeholderContext.commitInsertion { insertionIndexPath in
                                self.emojis.insert(text.string, at: insertionIndexPath.item)
                            }
                        }
                        
                        //Could not fetch data
                        else {
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if let indexPath = destinationIndexPath, indexPath.section == 1  {
            let isSelf = (session.localDragSession?.localContext) as? UICollectionView == collectionView
            return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
        }
        
        else {
            return UICollectionViewDropProposal(operation: .cancel)
        }
    }
}
