//
//  ViewController.swift
//  SET Game
//
//  Created by Максим Митрофанов on 06.02.2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var currentScoreLabel: UILabel!
    @IBOutlet private weak var showMoreCardsButton: UIButton!
    @IBOutlet private weak var matchStatusLabel: UILabel!
    @IBOutlet private weak var cardsLeftLabel: UILabel!
    @IBOutlet private weak var startNewGameButton: UIButton!
    @IBOutlet private weak var extraButton: UIButton!
    @IBOutlet private var cardsOnScreen: [UIButton]!
        
    @IBAction private func showMoreCardsTapped(_ sender: UIButton) {
        game.addMoreCards()
        updateGameUIFromModel()
    }
    
    @IBAction private func startNewGameTapped(_ sender: UIButton) {
        game = SetGame()
        updateGameUIFromModel()
    }
    
    @IBAction func gameCardTapped(_ sender: UIButton) {
        handleSelection(of: sender)
        updateGameUIFromModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultAppearanceForUI()
        updateGameUIFromModel()
    }
    
    private var game = SetGame()
    private var canSelect: Bool = true
}

extension ViewController {
    private func handleSelection(of sender: UIButton) {
        if canSelect, let selectedCardIndex = cardsOnScreen.firstIndex(of: sender) {
            game.selectCard(at: selectedCardIndex)
            updateGameUIFromModel()
        }
        
        if !game.status.isEmpty {
            canSelect = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.game.replaceSelectedCards()
                self.updateGameUIFromModel()
                self.canSelect = true
            }
        }
    }
    
    private func updateCardDisplayedValue(at index: Int) {
        cardsOnScreen[index].alpha = 1
        let attributedTitle = SetGameTheme.getAttributedTitle(for: game.displayedCards[index])
        cardsOnScreen[index].setAttributedTitle(attributedTitle, for: .normal)
    }
    
    private func updateSelectedCardsAppearance() {
        cardsOnScreen.forEach { $0.layer.borderColor = UIColor.clear.cgColor }
        
        for index in game.selectedCardIndices {
            cardsOnScreen[index].layer.borderColor = UIColor.black.cgColor
            cardsOnScreen[index].layer.borderWidth = 3
        }
    }
}






extension ViewController {
    private func setDefaultAppearanceForUI() {
        //Hiding extra button
        extraButton.alpha = 0
        
        //Setting corner radius and shadow for cards
        cardsOnScreen.forEach { $0.layer.cornerRadius = 8 }
        cardsOnScreen.forEach { $0.setDefaultShadow() }
        
        //Setting corner radius and shadow for bottom buttons
        showMoreCardsButton.layer.cornerRadius = 12
        startNewGameButton.layer.cornerRadius = 12
        showMoreCardsButton.setDefaultShadow()
        startNewGameButton.setDefaultShadow()
        
        //Setting corner radius for top labels
        matchStatusLabel.layer.cornerRadius = 8
        currentScoreLabel.layer.cornerRadius = 8
        
        //Setting corner radius for cards left label
        cardsLeftLabel.layer.cornerRadius = 8
    }
    
    private func updateGameUIFromModel() {
        //Updating labels
        cardsLeftLabel.text = "Cards: \(game.cardsLeftCount)"
        currentScoreLabel.text = "Score: \(game.score)"
        
        //Updating controls
        showMoreCardsButton.isEnabled = game.displayedCards.count < 24
        
        //Resetting cards displayed values
        cardsOnScreen.forEach { $0.alpha = 0 }
        game.displayedCards.indices.forEach { updateCardDisplayedValue(at: $0) }
    
        //Updating selected cards
        updateSelectedCardsAppearance()
        
        //Updating matchLabel
        matchStatusLabel.text = game.status
        matchStatusLabel.isHidden = game.status.isEmpty
    }
}

extension UIView {
    func setDefaultShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 2
    }
}
