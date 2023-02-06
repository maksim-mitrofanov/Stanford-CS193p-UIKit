//
//  SetGame.swift
//  SET Game
//
//  Created by Максим Митрофанов on 06.02.2023.
//

import Foundation

struct SetGame {
    
    private var allCards = [SetCard]()
    var displayedCards = [SetCard]()
    
    init() {
        allCards = SetGame.getAllPossibleCards()
        
        print(allCards.count)
    }
    
    func addMoreCards() {
        if displayedCards.count <= 21 {
            for _ in 1...3 {
                
            }
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
    var randomValueUpToSelf: Int {
        if self > 0 {
            
        }
        
        else if self < 0 {
            
        }
        
        else {
            return 0
        }
    }
}
