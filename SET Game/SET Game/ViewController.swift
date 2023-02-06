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
    @IBOutlet private weak var startNewGameButton: UIButton!
    @IBOutlet private weak var extraButton: UIButton!
    @IBOutlet private var cardsOnScreen: [UIButton]!
    
    private var game = SetGame()
    
    @IBAction private func showMoreCardsTapped(_ sender: UIButton) {
        game.addMoreCards()
        updateGameUI()
    }
    
    @IBAction private func startNewGameTapped(_ sender: UIButton) {
        game = SetGame()
        updateGameUI()
    }
    
    @IBAction func gameCardTapped(_ sender: UIButton) {
        updateGameUI()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideLastButton()
        updateGameUI()
        setRoundedCornersForButtons()
    }
}

extension ViewController {
    private func setRoundedCornersForButtons() {
        cardsOnScreen.forEach { $0.layer.cornerRadius = 8 }
        cardsOnScreen.forEach {
            $0.layer.masksToBounds = false
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.3
            $0.layer.shadowOffset = CGSize(width: 2, height: 2)
            $0.layer.shadowRadius = 2
        }
    }
    
    private func hideLastButton() {
        extraButton.alpha = 0
    }
    
    private func updateCardsFromModel() {
        cardsOnScreen.forEach { $0.alpha = 0 }
        
        for index in game.displayedCards.indices {
            updateDisplayedCard(at: index)
        }
    }
    
    private func updateButtonsFromModel() {
        showMoreCardsButton.isEnabled = game.displayedCards.count < 24
    }
    
    private func updateGameUI() {
        updateCardsFromModel()
        updateButtonsFromModel()
    }
    
    private func updateDisplayedCard(at index: Int) {
        cardsOnScreen[index].alpha = 1
        let cardTitle = getAttributedTitle(from: game.displayedCards[index])
        cardsOnScreen[index].setAttributedTitle(cardTitle, for: .normal)
    }
    
    private func getAttributedTitle(from card: SetCard) -> NSMutableAttributedString {
        var title: String {
            switch card.symbol {
            case .rect:
                return String(repeating: "■", count: card.symbolCount.rawValue)
            case .square:
                return String(repeating: "▲", count: card.symbolCount.rawValue)
            case .circle:
                return String(repeating: "●", count: card.symbolCount.rawValue)
            }
        }
        
        var cardColor: UIColor {
            switch card.color {
            case .purple:
                return UIColor.blue
            case .green:
                return UIColor.green
            case .red:
                return UIColor.red
            }
        }
        
        
        //Code cleaning
        //Card filled with 0.5 alpha if is striped
        let cardForegroundColor: UIColor = card.fillStyle == .outlined ? .clear : cardColor
        let cardStrokeColor: UIColor = card.fillStyle == .filled ? .black : cardColor
        
        
        return NSMutableAttributedString(string: title, attributes: [
            .strokeColor : cardStrokeColor.withAlphaComponent(card.fillStyle == .striped ? 0.5 : 1),
                .strokeWidth: -5,
                .foregroundColor : cardForegroundColor])
    
    }
}

