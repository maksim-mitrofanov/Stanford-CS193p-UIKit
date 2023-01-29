//
//  ViewController.swift
//  Concentration
//
//  Created by Максим Митрофанов on 29.01.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flip Count: \(flipCount)"
        }
    }
    
    var cardEmojis = ["🧑‍🚀", "🧑‍⚖️", "🦸🏻‍♂️", "🦹‍♀️"]
    
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet var concentrationCards: [UIButton]!
    @IBAction func cardPressed(_ sender: UIButton) { flipCard(sender: sender) }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func flipCard(sender: UIButton) {
        flipCount += 1
        
        if let cardIndex = concentrationCards.firstIndex(of: sender) {
            let cardEmoji = cardEmojis[cardIndex]
            
            if sender.currentTitle != cardEmoji {
                flipCardToFaceUp(withIndex: cardIndex)
            }
            
            else {
                flipCardToFaceDown(withIndex: cardIndex)
            }
        }
    }
    
    func flipCardToFaceUp(withIndex index: Int) {
        concentrationCards[index].setTitle(cardEmojis[index], for: .normal)
        concentrationCards[index].backgroundColor = .white
    }
    
    func flipCardToFaceDown(withIndex index: Int) {
        concentrationCards[index].setTitle("", for: .normal)
        concentrationCards[index].backgroundColor = UIColor.systemOrange
    }
}

