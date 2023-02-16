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
    @IBOutlet weak var cardsStackView: UIStackView!
    
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
        //Timer
//        if !(game.currentGameStatus == .unmatched) {
//            canSelect = false
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.game.replaceSelectedCards()
//                self.updateGameUIFromModel()
//                self.canSelect = true
//            }
//        }
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
        
        //Setting corner radius for top labels
        matchStatusLabel.layer.cornerRadius = 8
        currentScoreLabel.layer.cornerRadius = 8
        
        //Setting corner radius for cards left label
        cardsLeftLabel.layer.cornerRadius = 8
    }
    
    private func updateGameUIFromModel() {
        //Updating labels
        cardsLeftLabel.text = "Cards: \(game.cardsLeftCount)"
        currentScoreLabel.text = "Score: \(game.currentGameScore)"
        
        //Updating controls
        showMoreCardsButton.isEnabled = game.canDealMoreCards
        
        //Resetting cards displayed values
        game.displayedCards.indices.forEach { updateCardDisplayedValue(at: $0) }
    
        //Updating selected cards
        updateSelectedCardsAppearance()
        
        //Updating matchLabel
        matchStatusLabel.text = game.currentGameStatus.rawValue
        matchStatusLabel.isHidden = game.currentGameStatus == .unmatched
        if !game.hasStarted {
            matchStatusLabel.isHidden = false
        }
        
        //Updating cards
        addCardsFromModelToUI()
    }
    
    private func addCardsFromModelToUI() {
        print("Cards on Screen Count: \(game.displayedCards.count)")
        var minimumCardsOnOneRowCount: Int {
            if game.displayedCards.count < 18 {
                return 4
            } else if game.displayedCards.count < 27 {
                return 5
            } else if game.displayedCards.count < 39 {
                return 6
            } else if game.displayedCards.count < 57 {
                return 7
            } else {
                return 8
            }
        }
        
        let extraCardsCount = game.displayedCards.count % minimumCardsOnOneRowCount
        let rowsCount = {
            if extraCardsCount == 0 {
                return game.displayedCards.count / minimumCardsOnOneRowCount
            } else {
                return game.displayedCards.count / minimumCardsOnOneRowCount + 1
            }
        }()
        
        cardsStackView.subviews.forEach({ $0.removeFromSuperview() })

        for stackIndex in 0..<rowsCount {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.backgroundColor = .clear
            stackView.spacing = 6
            cardsStackView.spacing = 10
            cardsStackView.addArrangedSubview(stackView)
            
            for cardInStackIndex in 0..<minimumCardsOnOneRowCount {
                let card = CardView()
                let cardTotalIndex = stackIndex * minimumCardsOnOneRowCount + cardInStackIndex
                if game.displayedCards.count > cardTotalIndex {
                    card.setup(for: game.displayedCards[cardTotalIndex], isSelected: true)
                } else {
                    card.alpha = 0
                }
                stackView.addArrangedSubview(card)
            }
        }
    }
}
