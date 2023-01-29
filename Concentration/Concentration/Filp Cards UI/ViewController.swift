//
//  ViewController.swift
//  Concentration
//
//  Created by Максим Митрофанов on 29.01.2023.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = ConcentrationGame(numberOfPairsOfCards: (concentrationCards.count + 1) / 2)
    
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flip Count: \(flipCount)"
        }
    }
    
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet var concentrationCards: [UIButton]!
    @IBAction func cardPressed(_ sender: UIButton) { flipCard(sender: sender) }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func flipCard(sender: UIButton) {
        if let cardIndex = concentrationCards.firstIndex(of: sender) {
            flipCount += 1
            game.chooseCard(at: cardIndex)
            updateViewFromModel()
        }
    }
    
    func updateViewFromModel() {
        for index in concentrationCards.indices {
            let cardData = game.cards[index]
            updateAppearanceForCardAt(index: index, with: cardData)
        }
    }
    
    func updateAppearanceForCardAt(index: Int, with cardData: FlipCard) {
        if cardData.isFaceUp {
            concentrationCards[index].setTitle(emoji(for: cardData), for: .normal)
            concentrationCards[index].backgroundColor = .white
        }
        
        else {
            concentrationCards[index].setTitle("", for: .normal)
            concentrationCards[index].backgroundColor = cardData.isMatched ? .clear : UIColor.systemOrange
        }
    }
    
    var heroEmojis = ["🧑‍🚀", "🧑‍⚖️", "🦸🏻‍♂️", "🦹‍♀️", "🥷", "🧙‍♂️", "🧝‍♀️", "🧌", "🧛‍♀️", "🧟‍♂️", "🧞‍♂️"]
    var emojiDictionary = [Int:String]()
    
    func emoji(for card: FlipCard) -> String {
        if emojiDictionary[card.identifier] == nil, heroEmojis.count > 0 {
            let randomElementIndex = Int(arc4random_uniform(UInt32(heroEmojis.count)))
            emojiDictionary[card.identifier] = heroEmojis.remove(at: randomElementIndex)
        }
        return emojiDictionary[card.identifier] ?? "😶‍🌫️"
    }
}

