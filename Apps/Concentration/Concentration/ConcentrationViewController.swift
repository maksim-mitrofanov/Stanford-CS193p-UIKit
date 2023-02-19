//
//  ConcentrationViewController.swift
//  Concentration
//
//  Created by Максим Митрофанов on 29.01.2023.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    private lazy var game = ConcentrationGame(numberOfPairsOfCards: (concentrationCards.count + 1) / 2)
    
    private(set) var flipCount = 0 {
        didSet {
            setAttributedLabel()
        }
    }
    
    @IBOutlet weak var flipCountLabel: UILabel! {
        didSet {
            setAttributedLabel()
        }
    }
    @IBOutlet var concentrationCards: [UIButton]!
    @IBAction func cardPressed(_ sender: UIButton) { flipCard(sender: sender) }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        concentrationCards.forEach {
            $0.backgroundColor = UIColor(named: "CardBackgroundColor")
            $0.layer.cornerRadius = 8
        }
    }
    
    private func flipCard(sender: UIButton) {
        if let cardIndex = concentrationCards.firstIndex(of: sender) {
            flipCount += 1
            game.chooseCard(at: cardIndex)
            updateViewFromModel()
        }
    }
    
    private func updateViewFromModel() {
        if concentrationCards != nil {
            for index in concentrationCards.indices {
                let cardData = game.cards[index]
                updateAppearanceForCardAt(index: index, with: cardData)
            }
        }
    }
    
    private func updateAppearanceForCardAt(index: Int, with cardData: FlipCard) {
        if cardData.isFaceUp {
            concentrationCards[index].setTitle(emoji(for: cardData), for: .normal)
            concentrationCards[index].backgroundColor = .white
            concentrationCards[index].layer.borderWidth = 3
            concentrationCards[index].layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        }
        
        else {
            concentrationCards[index].setTitle("", for: .normal)
            concentrationCards[index].backgroundColor = cardData.isMatched ? .clear : UIColor(named: "CardBackgroundColor")
            concentrationCards[index].layer.borderColor = UIColor.black.withAlphaComponent(0).cgColor

        }
    }
    
    var theme: [String]? {
        didSet {
            currentThemeEmojis = theme ?? []
            emojiDictionary = [:]
        }
    }
    private var currentThemeEmojis = ["🧑‍🚀", "🧑‍⚖️", "🦸🏻‍♂️", "🦹‍♀️", "🥷", "🧙‍♂️", "🧝‍♀️", "🧌", "🧛‍♀️", "🧟‍♂️", "🧞‍♂️"]
    private var emojiDictionary = [Int:String]()
    
    private func emoji(for card: FlipCard) -> String {
        if emojiDictionary[card.identifier] == nil, currentThemeEmojis.count > 0 {
            let randomElementIndex = currentThemeEmojis.count.arc4random
            emojiDictionary[card.identifier] = currentThemeEmojis.remove(at: randomElementIndex)
        }
        return emojiDictionary[card.identifier] ?? "❌"
    }
    
    private func setAttributedLabel() {
        let attributes: [NSAttributedString.Key : Any] = [
            .strokeWidth : 5.0,
            .strokeColor : UIColor.black
        ]
        
        let attributedTitle = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedTitle
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        
        else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        }
        
        else {
            return self
        }
    }
}
