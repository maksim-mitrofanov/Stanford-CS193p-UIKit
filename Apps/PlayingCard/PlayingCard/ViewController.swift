//
//  ViewController.swift
//  PlayingCard
//
//  Created by Максим Митрофанов on 11.02.2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var playingCard: PlayingCardView!
    var game = PlayingCardDeck()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwipeGesture()
    }
    
    private func setupSwipeGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToNextCard(_: )))
        playingCard.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func swipeToNextCard(_ sender: UIGestureRecognizer) {
        if let card = game.draw() {
            playingCard.suit = card.suit.description
            playingCard.rank = card.rank.description
        }
    }
}

