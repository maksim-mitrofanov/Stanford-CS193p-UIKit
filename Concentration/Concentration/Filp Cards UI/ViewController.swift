//
//  ViewController.swift
//  Concentration
//
//  Created by Максим Митрофанов on 29.01.2023.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = ConcentrationGame(numberOfPairsOfCards: (concentrationCards.count + 1) / 2)
    
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var concentrationCards: [UIButton]!
    @IBAction func cardPressed(_ sender: UIButton) { flipCard(sender: sender) }
    
    @IBAction func newGameButtonPressed(_ sender: Any) {
        startNewGame()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
    }
    
    func flipCard(sender: UIButton) {
        if let cardIndex = concentrationCards.firstIndex(of: sender) {
            game.chooseCard(at: cardIndex)
            updateViewFromModel()
        }
    }
    
    func updateViewFromModel() {
        flipCountLabel.text = "Flips: \(game.flipCount)"
        for index in concentrationCards.indices {
            let cardData = game.cards[index]
            updateAppearanceForCardAt(index: index, with: cardData)
        }
        
        scoreLabel.text = "Score: \(game.currentScore)"
    }
    
    func updateAppearanceForCardAt(index: Int, with cardData: FlipCard) {
        if cardData.isFaceUp {
            concentrationCards[index].setTitle(emoji(for: cardData), for: .normal)
            concentrationCards[index].backgroundColor = .white
        }
        
        else {
            concentrationCards[index].setTitle("", for: .normal)
            concentrationCards[index].backgroundColor = cardData.isMatched ? .clear : currentTheme.backgroundColor
        }
    }
    
    let themes = [
        Theme(emojis: ["🧑‍🚀", "🧑‍⚖️", "🦸🏻‍♂️", "🦹‍♀️", "🥷", "🧙‍♂️", "🧝‍♀️", "🧌", "🧛‍♀️", "🧟‍♂️", "🧞‍♂️"], backgroundColor: UIColor.systemOrange),
        Theme(emojis:["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉"], backgroundColor: UIColor.systemBlue),
        Theme(emojis: ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎️", "🚓"], backgroundColor: UIColor.systemMint),
        Theme(emojis: ["🍅", "🍆", "🥑", "🥦", "🧄", "🧅", "🥔"], backgroundColor: UIColor.systemPink),
        Theme(emojis: ["🍔", "🧇", "🥓", "🥞", "🍖", "🌭", "🍕"], backgroundColor: UIColor.systemGreen)
    ]
    
    lazy var currentEmojiSet = [String]()
    lazy var currentTheme = Theme(emojis: [], backgroundColor: .systemOrange)
    var emojiDictionary = [Int:String]()
    
    func emoji(for card: FlipCard) -> String {
        if emojiDictionary[card.identifier] == nil, currentEmojiSet.count > 0 {
            let randomElementIndex = Int(arc4random_uniform(UInt32(currentEmojiSet.count)))
            emojiDictionary[card.identifier] = currentEmojiSet.remove(at: randomElementIndex)
        }
        return emojiDictionary[card.identifier] ?? "😶‍🌫️"
    }
    
    func startNewGame() {
        emojiDictionary.removeAll()
        if let randomTheme = themes.randomElement() {
            currentEmojiSet = randomTheme.emojis
            currentTheme = randomTheme
        }
        game = ConcentrationGame(numberOfPairsOfCards: (concentrationCards.count + 1) / 2)
        updateViewFromModel()
    }
}

