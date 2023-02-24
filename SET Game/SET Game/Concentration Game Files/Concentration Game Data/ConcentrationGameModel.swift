//
//  ConcentrationGameModel.swift
//  Concentration
//
//  Created by Максим Митрофанов on 29.01.2023.
//

import Foundation

class ConcentrationGameModel {
    var cards = [ConcentrationCardModel]()
    var currentScore = 0
    var flipCount = 0
    
    var indexOfTheOneAndOnlyFaceUpCard: Int?
    
    func chooseCard(at index: Int) {
        if !cards[index].isFaceUp, !cards[index].isMatched {
            if let faceUpCardIndex = indexOfTheOneAndOnlyFaceUpCard {
                //Cards are matching
                if cards[index].identifier == cards[faceUpCardIndex].identifier {
                    cards[index].isMatched = true
                    cards[faceUpCardIndex].isMatched = true
                    currentScore += 2
                }
                
                //Cards are not matching
                else {
                    if cards[index].wasMismatched { currentScore -= 1 }
                    cards[index].wasMismatched = true
                    cards[faceUpCardIndex].wasMismatched = true
                }
                
                indexOfTheOneAndOnlyFaceUpCard = nil
            }
            else {
                for flipIndex in cards.indices {
                    cards[flipIndex].isFaceUp = false
                }
                indexOfTheOneAndOnlyFaceUpCard = index
            }
            flipCount += 1
            cards[index].isFaceUp = true
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = ConcentrationCardModel()
            cards += [card, card]
        }
        cards.shuffle()
    }
}
