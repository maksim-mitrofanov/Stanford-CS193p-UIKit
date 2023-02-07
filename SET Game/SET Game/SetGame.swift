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
    var cardsLeftCount: Int {
        cardsInTheDeck.count
    }
    
    init() {
        cardsInTheDeck = SetGame.getAllPossibleCards()
        setDisplayedCards()
    }
    
    func checkCardsForMatching(at indices: [Int]) -> Bool {
        assert(indices.count == 3, "SetGame.matchCardsAt(indices:) indices count != 3")
        
        let firstCard = displayedCards[indices[0]]
        let secondCard = displayedCards[indices[1]]
        let thirdCard = displayedCards[indices[2]]
        
        
        
        //MARK: -Same Properties
        let allHaveSameSymbols: Bool = {
            let symbols = [firstCard.symbol, secondCard.symbol, thirdCard.symbol]
            return symbols.allSatisfy { $0 == firstCard.symbol }
        }()
        
        let allHaveSameColors: Bool = {
            let colors = [firstCard.color, secondCard.color, thirdCard.color]
            return colors.allSatisfy { $0 == firstCard.color }
        }()
        
        let allHaveSameSymbolCount: Bool = {
            let symbolCounts = [firstCard.symbolCount, secondCard.symbolCount, thirdCard.symbolCount]
            return symbolCounts.allSatisfy { $0 == firstCard.symbolCount }
        }()
        
        let allHaveSameFillStyle: Bool = {
            let fillStyles = [firstCard.fillStyle, secondCard.fillStyle, thirdCard.fillStyle]
            return fillStyles.allSatisfy { $0 == firstCard.fillStyle }
        }()

        
        
        //MARK: -All Different Properties
        let allHaveUniqueSymbols: Bool = {
            Set(SetCard.GameSymbol.allCases) == Set([firstCard.symbol, secondCard.symbol, thirdCard.symbol])
        }()
        
        let allHaveUniqueColors: Bool = {
            Set(SetCard.SymbolColor.allCases) == Set([firstCard.color, secondCard.color, thirdCard.color])
        }()
        
        let allHaveUniqueSymbolCount: Bool = {
            Set(SetCard.SymbolCount.allCases) == Set([firstCard.symbolCount, secondCard.symbolCount, thirdCard.symbolCount])
        }()
        
        let allHaveUniqueFillStyle: Bool = {
            Set(SetCard.FillStyle.allCases) == Set([firstCard.fillStyle, secondCard.fillStyle, thirdCard.fillStyle])
        }()
        
        //MARK: -Check for matching
        let matchBySymbol: Bool = {
            return allHaveSameSymbols || allHaveUniqueSymbols
        }()
        
        let matchBySymbolCount: Bool = {
            return allHaveSameSymbolCount || allHaveUniqueSymbolCount
        }()
        
        let matchByFillStyle: Bool = {
            return allHaveSameFillStyle || allHaveUniqueFillStyle
        }()
        
        let matchByColor: Bool = {
            return allHaveSameColors || allHaveUniqueColors
        }()
        
        let cardsAreMatching = [matchByColor, matchBySymbolCount, matchByFillStyle, matchByColor].allSatisfy { $0 == true }
        return cardsAreMatching
    }
    
    mutating func replaceCards(at indices: [Int]) {
        for index in indices {
            if cardsInTheDeck.count > 0 {
                let randomCardIndex = cardsInTheDeck.count.arc4random
                displayedCards[index] = cardsInTheDeck.remove(at: randomCardIndex)
            }
        }
        print("Cards in the deck count: \(cardsInTheDeck.count)")
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
