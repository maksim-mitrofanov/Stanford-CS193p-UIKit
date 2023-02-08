//
//  SetGame.swift
//  SET Game
//
//  Created by Максим Митрофанов on 06.02.2023.
//

import Foundation

struct SetGame {
    var displayedCards = [SetCard]()
    var status: String = ""
    var score: Int = 0
    private var hasMatched: Bool {
        status == "Match: ✅"
    }
    
    private(set) var selectedCardIndices = [Int]()
    private var cardsInTheDeck = [SetCard]()
    
    var cardsLeftCount: Int {
        cardsInTheDeck.count
    }
    
    init() {
        cardsInTheDeck = SetGame.getAllPossibleCards()
        setDisplayedCards()
    }
    
    mutating func selectCard(at index: Int) {
        //Deselection
        if selectedCardIndices.count < 3 && selectedCardIndices.contains(where: { $0 == index }) {
            selectedCardIndices.removeAll(where: { $0 == index })
            score -= 1
        }
        
        //Selection
        else if selectedCardIndices.count < 3 {
            selectedCardIndices.append(index)
            if selectedCardIndices.count == 3 {
                let areMatching = checkCardsForMatching(at: selectedCardIndices)
                score += areMatching ? 5 : -1
                status = areMatching ? "Match: ✅" : "Match: ❌"
            }
        }
        
        //New Set
        else if selectedCardIndices.count == 3 {
            selectedCardIndices.removeAll()
            selectedCardIndices.append(index)
        }
        
        if selectedCardIndices.count < 3 { status.removeAll() }
    }
    
    mutating func replaceSelectedCards() {
        if hasMatched {
            for index in selectedCardIndices {
                if cardsInTheDeck.count > 0 {
                    let randomCardIndex = cardsInTheDeck.count.arc4random
                    displayedCards[index] = cardsInTheDeck.remove(at: randomCardIndex)
                }
            }
        }
        
        selectedCardIndices.removeAll()
        status.removeAll()
    }
    
    mutating func addMoreCards() {
        if displayedCards.count <= 21 {
            for _ in 1...3 {
                let randomIndex = cardsInTheDeck.count.arc4random
                let poppedCard = cardsInTheDeck.remove(at: randomIndex)
                displayedCards.append(poppedCard)
            }
        }
    }
}

extension SetGame {
    private mutating func setDisplayedCards() {
        for _ in 1...4 {
            addMoreCards()
        }
    }
    
    private func checkCardsForMatching(at indices: [Int]) -> Bool {
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
        
        let cardsAreMatching = [matchBySymbol, matchBySymbolCount, matchByFillStyle, matchByColor].allSatisfy { $0 == true }
        return cardsAreMatching
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
