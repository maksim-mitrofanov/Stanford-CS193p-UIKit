//
//  SetGame.swift
//  SET Game
//
//  Created by Максим Митрофанов on 06.02.2023.
//

import Foundation

struct SetGame {
    private var cardsInTheDeck = [SetCard]()
    var displayedCards = [SetCard]()
    
    init() {
        cardsInTheDeck = SetGame.getAllPossibleCards()
        setDisplayedCards()
    }
}

extension SetGame {
    mutating func addMoreCards() {
        if displayedCards.count <= 21 {
            for _ in 1...3 {
                let randomIndex = cardsInTheDeck.count.arc4random
                let poppedCard = cardsInTheDeck.remove(at: randomIndex)
                displayedCards.append(poppedCard)
            }
        }
    }
    
    private mutating func setDisplayedCards() {
        for _ in 1...4 {
            addMoreCards()
        }
    }
}

extension SetGame {
    static func getAllPossibleCards() -> [SetCard] {
        var cards = [SetCard]()
        
        for symbol in SetCard.GameSymbol.allCases {
            for fillStyle in SetCard.FillStyle.allCases {
                for symbolCount in SetCard.SymbolCount.allCases {
                    for symbolColor in SetCard.SymbolColor.allCases {
                        cards.append(SetCard(symbol: symbol, symbolCount: symbolCount, fillStyle: fillStyle, color: symbolColor))
                    }
                }
            }
        }
        
        return cards
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
