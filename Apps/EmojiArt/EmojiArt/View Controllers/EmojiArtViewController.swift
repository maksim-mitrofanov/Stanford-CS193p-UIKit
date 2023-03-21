//
//  EmojiArtViewController.swift
//  EmojiArt
//
//  Created by Максим Митрофанов on 01.03.2023.
//

import UIKit

class EmojiArtViewController: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet var dropZone: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var scrollViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var emojiCollectionView: UICollectionView! {
        didSet {
            emojiCollectionView.dataSource = self
            emojiCollectionView.delegate = self
            emojiCollectionView.dragDelegate = self
            emojiCollectionView.dropDelegate = self
            emojiCollectionView.dragInteractionEnabled = true
        }
    }
    
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 1/4
            scrollView.maximumZoomScale = 2.0
            scrollView.delegate = self
            scrollView.addSubview(emojiArtView)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction private func toggleAddEmoji() {
        if isAddingEmojis { collectionViewEmojis.remove(at: 0) }
        else { collectionViewEmojis = [" "] + collectionViewEmojis }
        
        isAddingEmojis.toggle()
        emojiCollectionView.reloadSections(IndexSet(integer: 1))
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        saveEmojiArt()
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        saveEmojiArt()
        document?.close()
        dismiss(animated: true)
    }
    // MARK: - Properties
    
    private var collectionViewEmojis = "🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷".map { $0.description }
    private var isAddingEmojis: Bool = false
    
    private var _emojiArtBackgroundImageURL: URL?
    
    private var emojiArtView = EmojiArtView()
    private var imageFetcher: ImageFetcher!
    
    private var emojiArt: EmojiArt? {
        get {
            let networkURL = emojiArtBackgroundImage.url?.description ?? ""
            let emojis = emojiArtView.subviews.compactMap { $0 as? UILabel }
            return EmojiArt(url: networkURL, emojis: emojis.compactMap { EmojiArt.EmojiInfo(label: $0) })
        }
        
        set {
            let emojis = emojiArtView.subviews.compactMap { $0 as? UILabel }
            emojis.forEach { $0.removeFromSuperview() }
            
            if let document = newValue {
                if document.url.count != 0  {
                    print("Fetching image")
                    fetchImageFromDocumentURL(document: document)
                    setLabels(from: document)
                } else {
                    print("Setting default background")
                    setDefaultBackground()
                }
            }
        }
    }

    // MARK: - UIViewController Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setDropInteraction()
        activityIndicator.startAnimating()
        setDefaultBackground()
        
        if let documentsURL = try?
            FileManager.default.url(for:  .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) {
            let fileURL = documentsURL.appendingPathComponent("Untitled.json")
            document = EmojiArtDocument(fileURL: fileURL)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadEmojiArt()
    }
    
    // MARK: - Persistance
    var document: EmojiArtDocument?
    
    private func saveEmojiArt() {
        document?.emojiArt = emojiArt
        
        if document?.emojiArt != nil {
            document?.thumbnail = emojiArtView.snapshot
            document?.updateChangeCount(.done)
        }
    }
    
    private func loadEmojiArt() {
        document?.open() { success in
            if success {
                self.title = self.document?.localizedName
                self.emojiArt = self.document?.emojiArt
            }
        }
    }
}

// MARK: - Private Methods
extension EmojiArtViewController {
    private func setDefaultBackground() {
        emojiArtBackgroundImage = (nil, UIImage(named: "DefaultBackground"))
    }
    
    private func setDropInteraction() {
        let drop = UIDropInteraction(delegate: self)
        dropZone.addInteraction(drop)
    }
    
    private var emojiArtBackgroundImage: (url: URL?, image: UIImage?) {
        get { (_emojiArtBackgroundImageURL, emojiArtView.imageToDisplay) }
        set {
            _emojiArtBackgroundImageURL = newValue.url
            scrollView?.zoomScale = 1.0
            emojiArtView.imageToDisplay = newValue.image
            let size = newValue.image?.size ?? CGSize.zero
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
    
    // MARK: - FetchingImages
    private func fetchImageFromDocumentURL(document: EmojiArt) {
        print("Called")
        DispatchQueue.global(qos: .userInitiated).async {
            guard let URL = URL(string: document.url) else { return }
            guard let data = try? Data(contentsOf: URL) else { return }
            guard let image = UIImage(data: data) else { return }
            
            print("Fetching image")
            DispatchQueue.main.async { [weak self] in
                self?.emojiArtBackgroundImage = (URL, image)
            }
        }
    }
    
    private func setLabels(from document: EmojiArt) {
        document.emojis.forEach { [weak self] in
            self?.emojiArtView.addLabel(
                with: $0.text,
                size: CGFloat($0.size),
                at: CGPoint(x: CGFloat($0.x), y: CGFloat($0.y))
            )
        }
    }
}

// MARK: - DropInteractionDelegate

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
        emojiArtBackgroundImage = (nil, nil)
        activityIndicator.startAnimating()
        
        imageFetcher = ImageFetcher() { (url, image) in
            DispatchQueue.main.async {
                self.emojiArtBackgroundImage = (url, image)
                self.emojiArt?.url = url.description
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

// MARK: -ScrollViewDelegate
extension EmojiArtViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        emojiArtView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewHeightConstraint.constant = scrollView.contentSize.height
        scrollViewWidthConstraint.constant = scrollView.contentSize.width
    }
}

// MARK: -CollectionViewDelegate
extension EmojiArtViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        else { return collectionViewEmojis.count }
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
                            self?.collectionViewEmojis.remove(at: 0)
                            self?.collectionViewEmojis = [text] + self!.collectionViewEmojis
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
                    emojiCell.mainLabel.text = collectionViewEmojis[indexPath.item].description
                    
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

// MARK: -CollectionViewDragDelegate
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

// MARK: -CollectionViewDropDelegate
extension EmojiArtViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        
        coordinator.items.forEach { item in
            //Local
            if let sourceIndexPath = item.sourceIndexPath {
                if let attributedString = item.dragItem.localObject as? NSAttributedString {
                    collectionView.performBatchUpdates {
                        collectionViewEmojis.remove(at: sourceIndexPath.item)
                        collectionViewEmojis.insert(attributedString.string, at: destinationIndexPath.item)
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
                                self.collectionViewEmojis.insert(text.string, at: insertionIndexPath.item)
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

extension EmojiArt.EmojiInfo {
    init?(label: UILabel) {
        guard let font = label.font else { return nil }
        
        self.x = Int(label.center.x)
        self.y = Int(label.center.y)
        self.text = label.text ?? ""
        self.size = Int(font.pointSize)
    }
}
