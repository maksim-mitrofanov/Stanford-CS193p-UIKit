//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Максим Митрофанов on 16.02.2023.
//

import UIKit


@IBDesignable class PlayingCardView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet private weak var cardBackground: UIImageView!
    @IBOutlet private weak var topLeadingLabel: UILabel!
    @IBOutlet private weak var bottomTrailingLabel: UILabel!
    
    @IBInspectable var rank: String = "" {
        didSet {
            topLeadingLabel.text = "\(rank)\n\(suit)"
            bottomTrailingLabel.text = "\(rank)\n\(suit)"
        }
    }
    
    @IBInspectable var suit: String = "" {
        didSet {
            topLeadingLabel.text = "\(rank)\n\(suit)"
            bottomTrailingLabel.text = "\(rank)\n\(suit)"
        }
    }
    
    
    var isFaceUp: Bool = false {
        didSet {
            if isFaceUp {
                topLeadingLabel.alpha = 1
                bottomTrailingLabel.alpha = 1
                cardBackground.alpha = 0
            } else {
                topLeadingLabel.alpha = 0
                bottomTrailingLabel.alpha = 0
                cardBackground.alpha = 1
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibFile()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibFile()
        setup()
    }
        
    private func setup() {
        isFaceUp = false
        contentView.layer.cornerRadius = contentView.bounds.height / 10
        topLeadingLabel.font = UIFont.systemFont(ofSize: contentView.bounds.height / 8)
        bottomTrailingLabel.font = UIFont.systemFont(ofSize: contentView.bounds.height / 8)
        bottomTrailingLabel.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi)
    }
    
    private func loadNibFile() {
        Bundle.main.loadNibNamed("PlayingCardView", owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.clipsToBounds = true
    }
}
