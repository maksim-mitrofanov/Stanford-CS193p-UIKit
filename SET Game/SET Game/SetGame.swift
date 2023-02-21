//
//  SetGame.swift
//  SET Game
//
//  Created by Максим Митрофанов on 06.02.2023.
//

import Foundation

struct SetGame {
    private(set) var selectedCardIndices = [Int]()
    private var cardsInTheDeck = [SetCardData]()
        
    var displayedCards = [SetCardData]()
    var currentGameStatus: SetGameStatus = .unmatched
    var currentGameScore: Int = 0
    var hasStarted: Bool = false
    
    var cardsLeftCount: Int {
        return cardsInTheDeck.count
    }
    
    var canDealMoreCards: Bool {
        return cardsInTheDeck.count >= 3
    }
    
    init() {
        cardsInTheDeck = SetGame.getAllPossibleCards()
        setDisplayedCards()
    }
    
    mutating func selectCard(at index: Int) {
        hasStarted = true
        //Deselection
        if selectedCardIndices.count < 3 && selectedCardIndices.contains(where: { $0 == index }) {
            selectedCardIndices.removeAll(where: { $0 == index })
            currentGameScore -= 1
        }
        
        //Selection
        else if selectedCardIndices.count < 3 {
            selectedCardIndices.append(index)
            if selectedCardIndices.count == 3 {
                let areMatching = checkCardsForMatching(at: selectedCardIndices)
                currentGameScore += areMatching ? 5 : -1
                currentGameStatus = areMatching ? .matched : .mismatched
            }
        }
        
        //New Set
        else if selectedCardIndices.count == 3 {
            selectedCardIndices.removeAll()
            selectedCardIndices.append(index)
        }
        
        if selectedCardIndices.count < 3 { currentGameStatus = .unmatched }
    }
    
    mutating func replaceSelectedCards() {
        if currentGameStatus == .matched {
            if cardsInTheDeck.count > 0 {
                for index in selectedCardIndices {
                    let randomCardIndex = cardsInTheDeck.count.arc4random
                    displayedCards[index] = cardsInTheDeck.remove(at: randomCardIndex)
                }
            }
            else {
                while selectedCardIndices.count > 0 {
                    print(selectedCardIndices[0])
                    displayedCards.remove(at: selectedCardIndices[0])
                    selectedCardIndices.remove(at: 0)
                    if selectedCardIndices.count > 0, selectedCardIndices[0] > 0 { selectedCardIndices[0] -= 1 }
                }
            }
        }
        
        selectedCardIndices.removeAll()
        currentGameStatus = .unmatched
    }
    
    mutating func addMoreCards() {
        if canDealMoreCards {
            for _ in 1...3 {
                let randomIndex = cardsInTheDeck.count.arc4random
                let poppedCard = cardsInTheDeck.remove(at: randomIndex)
                displayedCards.append(poppedCard)
            }
        }
    }
}

extension SetGame {
    enum SetGameStatus: String {
        case matched = "Match: ✅"
        case mismatched = "Match: ❌"
        case unmatched = "Match: ❓"
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
            Set(SetCardData.GameSymbol.allCases) == Set([firstCard.symbol, secondCard.symbol, thirdCard.symbol])
        }()
        
        let allHaveUniqueColors: Bool = {
            Set(SetCardData.SymbolColor.allCases) == Set([firstCard.color, secondCard.color, thirdCard.color])
        }()
        
        let allHaveUniqueSymbolCount: Bool = {
            Set(SetCardData.SymbolCount.allCases) == Set([firstCard.symbolCount, secondCard.symbolCount, thirdCard.symbolCount])
        }()
        
        let allHaveUniqueFillStyle: Bool = {
            Set(SetCardData.FillStyle.allCases) == Set([firstCard.fillStyle, secondCard.fillStyle, thirdCard.fillStyle])
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
    static func getAllPossibleCards() -> [SetCardData] {
        var cards = [SetCardData]()
        
        //Gives all possible cards (81 cards)
        for symbol in SetCardData.GameSymbol.allCases {
            for fillStyle in SetCardData.FillStyle.allCases {
                for symbolCount in SetCardData.SymbolCount.allCases {
                    for symbolColor in SetCardData.SymbolColor.allCases {
                        cards.append(SetCardData(symbol: symbol, symbolCount: symbolCount, fillStyle: fillStyle, color: symbolColor))
                    }
                }
            }
        }
        
        //Debug (27 cards)
//        for symbol in SetCardData.GameSymbol.allCases {
//            for fillStyle in SetCardData.FillStyle.allCases {
//                for symbolCount in SetCardData.SymbolCount.allCases {
//                    cards.append(SetCardData(symbol: symbol, symbolCount: symbolCount, fillStyle: fillStyle, color: .purple))
//                }
//            }
//        }
        
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
