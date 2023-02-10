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
}

extension ViewController {
    private func handleSelection(of sender: UIButton) {
        //Timer
        if !game.status.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.game.replaceSelectedCards()
                self.updateGameUIFromModel()
            }
        }
    }

    private func updateCardDisplayedValue(at index: Int) {
       
    }

    private func updateSelectedCardsAppearance() {
        
    }
}






extension ViewController {
    private func setDefaultAppearanceForUI() {
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
