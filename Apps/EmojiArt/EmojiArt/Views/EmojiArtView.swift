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
        imageToDisplay?.draw(in: self.bounds)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addInteraction(UIDropInteraction(delegate: self))
    }
}

extension EmojiArtView: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        session.canLoadObjects(ofClass: String.self) && !session.canLoadObjects(ofClass: NSURL.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        if session.canLoadObjects(ofClass: String.self) {
            let _ = session.loadObjects(ofClass: String.self) { itemProviders in
                let dropPoint = session.location(in: self)
                
                for string in itemProviders {
                    DispatchQueue.main.async { [weak self] in
                        self?.addLabel(with: string, at: dropPoint)
                    }
                }
            }
        }
    }
    
    func addLabel(with value: String, size: CGFloat? = nil, at position: CGPoint) {
        let label = UILabel()
        label.backgroundColor = .clear
        label.center = position
        
        if let fontSize = size {
            label.font = UIFont.systemFont(ofSize: fontSize)
        } else {
            label.font = UIFont.systemFont(ofSize: 200)
        }
            
        label.text = value
        label.sizeToFit()
        addEmojiArtGestureRecognizers(to: label)
        addSubview(label)
    }
}
