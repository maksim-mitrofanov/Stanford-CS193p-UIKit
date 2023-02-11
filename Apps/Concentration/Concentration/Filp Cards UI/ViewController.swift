//
//  ViewController.swift
//  Concentration
//
//  Created by Максим Митрофанов on 29.01.2023.
//

import UIKit

class ViewController: UIViewController {
    
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
    }
    
    private func flipCard(sender: UIButton) {
        if let cardIndex = concentrationCards.firstIndex(of: sender) {
            flipCount += 1
            game.chooseCard(at: cardIndex)
            updateViewFromModel()
        }
    }
    
    private func updateViewFromModel() {
        for index in concentrationCards.indices {
            let cardData = game.cards[index]
            updateAppearanceForCardAt(index: index, with: cardData)
        }
    }
    
    private func updateAppearanceForCardAt(index: Int, with cardData: FlipCard) {
        if cardData.isFaceUp {
            concentrationCards[index].setTitle(emoji(for: cardData), for: .normal)
            concentrationCards[index].backgroundColor = .white
        }
        
        else {
            concentrationCards[index].setTitle("", for: .normal)
            concentrationCards[index].backgroundColor = cardData.isMatched ? .clear : UIColor.systemOrange
        }
    }
    
    private var heroEmojis = ["🧑‍🚀", "🧑‍⚖️", "🦸🏻‍♂️", "🦹‍♀️", "🥷", "🧙‍♂️", "🧝‍♀️", "🧌", "🧛‍♀️", "🧟‍♂️", "🧞‍♂️"]
    private var emojiDictionary = [Int:String]()
    
    private func emoji(for card: FlipCard) -> String {
        if emojiDictionary[card.identifier] == nil, heroEmojis.count > 0 {
            let randomElementIndex = heroEmojis.count.arc4random
            emojiDictionary[card.identifier] = heroEmojis.remove(at: randomElementIndex)
        }
        return emojiDictionary[card.identifier] ?? "😶‍🌫️"
    }
    
    private func setAttributedLabel() {
        let attributes: [NSAttributedString.Key : Any] = [
            .strokeWidth : 5.0,
            .strokeColor : UIColor.orange
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
