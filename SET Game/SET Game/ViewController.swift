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
    
    private var game = SetGame() {
        didSet {
            selectedCardsIndices.removeAll()
        }
    }
    private var selectedCardsIndices: [Int] = [] {
        didSet {
            updateSelectedCardsAppearance()
        }
    }
}

extension ViewController {
    private func updateGameUIFromModel() {
        showMoreCardsButton.isEnabled = game.displayedCards.count < 24
        
        cardsOnScreen.forEach { $0.alpha = 0 }
        for index in game.displayedCards.indices {
            updateCardAppearance(at: index)
        }
    }
    
    private func updateCardAppearance(at index: Int) {
        cardsOnScreen[index].alpha = 1
        let attributedTitle = SetGameTheme.getAttributedTitle(for: game.displayedCards[index])
        cardsOnScreen[index].setAttributedTitle(attributedTitle, for: .normal)
    }
    
    //Needs refactoring
    private func handleSelection(of sender: UIButton) {
        if let selectedCardIndex = cardsOnScreen.firstIndex(of: sender) {
            if selectedCardsIndices.count == 3 {
                selectedCardsIndices.removeAll()
                selectedCardsIndices.append(selectedCardIndex)
            }
            
            else if selectedCardsIndices.count < 3 && !selectedCardsIndices.contains(selectedCardIndex) {
                selectedCardsIndices.append(selectedCardIndex)
            }
            
            else {
                if let indexToRemove = selectedCardsIndices.firstIndex(of: selectedCardIndex) {
                    selectedCardsIndices.remove(at: indexToRemove)
                }
            }
            
            updateSelectedCardsAppearance()
        }
    }
    
    private func updateSelectedCardsAppearance() {
        cardsOnScreen.forEach { $0.layer.borderColor = UIColor.clear.cgColor }
        
        for index in selectedCardsIndices {
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
