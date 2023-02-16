//
//  CardView.swift
//  SET Game
//
//  Created by Максим Митрофанов on 16.02.2023.
//

import UIKit

class CardView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet private weak var mainButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup(for cardData: SetCard, isSelected: Bool) {
        let attributedTitle = SetGameTheme.getAttributedTitle(for: cardData)
        mainButton.setAttributedTitle(attributedTitle, for: .normal)
        
        if isSelected {
            mainButton.layer.borderColor = UIColor.black.cgColor
            mainButton.layer.borderWidth = 3
        }
        setupShadowsAndCornerRadius()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed("CardView", owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func setupShadowsAndCornerRadius() {
        mainButton.layer.cornerRadius = 8
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize(width: 2, height: 2)
        contentView.layer.shadowRadius = 2
    }
}
