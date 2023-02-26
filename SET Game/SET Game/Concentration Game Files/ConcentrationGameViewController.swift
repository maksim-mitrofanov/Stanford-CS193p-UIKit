//
//  ConcentrationGameViewController.swift
//  Concentration
//
//  Created by Максим Митрофанов on 29.01.2023.
//

import UIKit

class ConcentrationGameViewController: UIViewController {
    
    lazy var game = ConcentrationGameModel(numberOfPairsOfCards: (concentrationCards.count + 1) / 2)
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private var concentrationCards: [UIButton]!
    @IBAction func cardPressed(_ sender: UIButton) { flipCard(sender: sender) }
    
    @IBOutlet private weak var buttonsStackView: UIStackView!
    @IBOutlet private weak var newGameButton: UIButton!
    @IBAction func newGameButtonPressed(_ sender: Any) {
        startNewGame()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
    }
    
    private func flipCard(sender: UIButton) {
        if let cardIndex = concentrationCards.firstIndex(of: sender) {
            game.chooseCard(at: cardIndex)
            updateViewFromModel(updatingAllCards: false)
        }
    }
    
    private func updateViewFromModel(updatingAllCards: Bool) {
        flipCountLabel.text = "Flips: \(game.flipCount)"
        for index in concentrationCards.indices {
            let cardData = game.cards[index]
            
            if updatingAllCards {
                UIView.transition(with: buttonsStackView, duration: 0.5, options: [.transitionFlipFromTop]) {
                    self.updateAppearanceForCardAt(index: index, with: cardData)
                }
            } else {
                updateAppearanceForCardAt(index: index, with: cardData)
            }
        }
        
        scoreLabel.text = "Score: \(game.currentScore)"
    }
    
    private func updateAppearanceForCardAt(index: Int, with cardData: ConcentrationCardModel) {
        if cardData.isFaceUp {
            concentrationCards[index].titleLabel?.font = .systemFont(ofSize: 40)
            let titleNeedsUpdate = concentrationCards[index].currentTitle != emoji(for: cardData)
            let backgroundNeedsUpdate = concentrationCards[index].backgroundColor != .white
            let needsUpdate = titleNeedsUpdate || backgroundNeedsUpdate
            
            if needsUpdate {
                UIView.transition(with: concentrationCards[index], duration: 0.5, options: [.transitionFlipFromRight]) {
                    self.concentrationCards[index].setTitle(self.emoji(for: cardData), for: .normal)
                    self.concentrationCards[index].backgroundColor = .white
                }
            }
        }
        
        else {
            if concentrationCards[index].currentTitle != "" && concentrationCards[index].backgroundColor != currentTheme.backgroundColor {
                UIView.transition(with: concentrationCards[index], duration: 0.5, options: [.transitionFlipFromRight]) {
                    self.concentrationCards[index].setTitle("", for: .normal)
                    self.concentrationCards[index].backgroundColor = cardData.isMatched ? .clear : self.currentTheme.backgroundColor
                }
            }
            self.concentrationCards[index].setTitle("", for: .normal)
            self.concentrationCards[index].backgroundColor = cardData.isMatched ? .clear : self.currentTheme.backgroundColor
        }
    }
    
    lazy private var currentTheme = ConcentrationGameTheme.randomTheme() {
        didSet {
            emojiDictionary.removeAll()
            currentEmojiSet = currentTheme.emojis
            
        }
    }
    lazy private var currentEmojiSet = [String]()
    private var emojiDictionary = [Int:String]()
    
    private func emoji(for card: ConcentrationCardModel) -> String {
        if emojiDictionary[card.identifier] == nil, currentEmojiSet.count > 0 {
            let randomElementIndex = Int(arc4random_uniform(UInt32(currentEmojiSet.count)))
            emojiDictionary[card.identifier] = currentEmojiSet.remove(at: randomElementIndex)
        }
        return emojiDictionary[card.identifier] ?? "😶‍🌫️"
    }
    
    private func startNewGame() {
        game = ConcentrationGameModel(numberOfPairsOfCards: (concentrationCards.count + 1) / 2)
        concentrationCards.forEach { $0.backgroundColor = currentTheme.backgroundColor }
        concentrationCards.forEach { $0.layer.cornerRadius = 12 }
        newGameButton.layer.cornerRadius = 12
        updateViewFromModel(updatingAllCards: true)
    }
    
    func chooseNewTheme(_ theme: ConcentrationGameTheme) {
        currentTheme = theme
    }
}

