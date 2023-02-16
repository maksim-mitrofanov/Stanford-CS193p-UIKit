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
    
    
    private var isUpsideDown: Bool = false {
        didSet {
            if isUpsideDown {
                topLeadingLabel.alpha = 0
                bottomTrailingLabel.alpha = 0
                cardBackground.alpha = 1
            } else {
                topLeadingLabel.alpha = 1
                bottomTrailingLabel.alpha = 1
                cardBackground.alpha = 0
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
    
    func setup() {
        isUpsideDown = false
        contentView.layer.cornerRadius = 32
        
        bottomTrailingLabel.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi)
        
        setupGestures()
    }
    
    private func loadNibFile() {
        Bundle.main.loadNibNamed("PlayingCardView", owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.clipsToBounds = true
    }
    
    private func setupGestures() {
        let zoomGesture = UIPinchGestureRecognizer(target: self, action: #selector(zoomInCard(_:)))
        contentView.addGestureRecognizer(zoomGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(flipCard(_:)))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func flipCard(_ sender: UITapGestureRecognizer) {
        isUpsideDown.toggle()
    }
    
    @objc private func zoomInCard(_ sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .changed:
            print("Scaled to: \(sender.scale)")
            if let superview = superview {
                contentView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width * sender.scale, height: contentView.frame.height * sender.scale)
                topLeadingLabel.contentScaleFactor = sender.scale
                sender.scale = 1.0
            }
        case .ended:
            print("")
        default: return
        }
    }
}
