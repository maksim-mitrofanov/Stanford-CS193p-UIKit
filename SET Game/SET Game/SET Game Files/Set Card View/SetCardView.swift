//
//  SetCardView.swift
//  SET Game
//
//  Created by Максим Митрофанов on 16.02.2023.
//

import UIKit

class SetCardView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet private weak var mainButton: UIButton!
    private(set) var cardData: SetCardData?
    private(set) var isSelected: Bool = false    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup(for cardData: SetCardData, isSelected: Bool = false) {
        mainButton.isEnabled = false
        let attributedTitle = SetGameTheme.getAttributedTitle(for: cardData)
        mainButton.setAttributedTitle(attributedTitle, for: .normal)
        
        if isSelected {
            mainButton.layer.borderColor = UIColor.black.cgColor
            mainButton.layer.borderWidth = 3
        } else {
            mainButton.layer.borderColor = UIColor.clear.cgColor
        }
        
        setupShadowsAndCornerRadius()
        self.cardData = cardData
        self.isSelected = isSelected
    }
    
    func getCardData() -> SetCardData? {
        return cardData
    }
    
    
    
    private func setup() {
        Bundle.main.loadNibNamed("SetCardView", owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func setupShadowsAndCornerRadius() {
        mainButton.layer.cornerRadius = 14
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize(width: 4, height: 4)
        contentView.layer.shadowRadius = 4
    }
}
