//
//  ViewController.swift
//  PlayingCard
//
//  Created by Максим Митрофанов on 11.02.2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var playingCards: [PlayingCardView]!
    private(set) var game = PlayingCardDeck()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
        setupCardValues()
    }
    
    private var faceUpCards: [PlayingCardView] {
        playingCards.filter { $0.isFaceUp && !$0.isHidden && $0.alpha != 0 }
    }
    
    private var faceUpCardsMatch: Bool {
        if faceUpCards.count == 2 {
            let suitsMatch: Bool = faceUpCards[0].suit == faceUpCards[1].suit
            let ranksMatch: Bool = faceUpCards[0].rank == faceUpCards[1].rank
            return suitsMatch && ranksMatch
        }
        return false
    }
    
    private func setupTapGesture() {
        playingCards.forEach {
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
        }
    }
    
    private func setupCardValues() {
        game.shuffleCards()
        playingCards.forEach { $0.isFaceUp = false }
        
        var cardOptions = [PlayingCard]()
        for optionIndex in 0..<playingCards.count {
            cardOptions.append(game.cards[optionIndex])
            cardOptions.append(game.cards[optionIndex])
        }
        
        cardOptions.shuffle()
        
        for cardIndex in playingCards.indices {
            playingCards[cardIndex].suit = cardOptions[cardIndex].suit.description
            playingCards[cardIndex].rank = cardOptions[cardIndex].rank.description
        }
    }
    
    @objc private func flipCard(_ sender: UITapGestureRecognizer) {
        if let cardView = sender.view as? PlayingCardView {
            let duration: TimeInterval = 0.6
            let options: UIView.AnimationOptions = [.transitionFlipFromLeft]
            let animations = { cardView.isFaceUp.toggle() }
            
            let completion: (Bool) -> ()  = { finished in
                if self.faceUpCardsMatch {
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: duration,
                        delay: 0,
                        animations: {
                            self.faceUpCards.forEach {
                                $0.transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2)
                            }
                        },
                        completion: { position in
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: duration + 1,
                                delay: 0,
                                animations: {
                                    self.faceUpCards.forEach {
                                        $0.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
                                        $0.alpha = 0
                                    }
                                }
                            )
                        }
                    )
                }
                
                //Turning cards to FaceDown
                else if self.faceUpCards.count == 2 {
                    self.faceUpCards.forEach { faceUpCard in
                        UIView.transition(
                            with: faceUpCard,
                            duration: duration,
                            options: [.transitionFlipFromRight],
                            animations: { faceUpCard.isFaceUp = false  }
                        )
                    }
                }
                
            }
            
            //Turning a selected card to FaceUp
            UIView.transition(
                with: cardView,
                duration: duration,
                options: options,
                animations: animations,
                completion: completion
            )
        }
    }
}

