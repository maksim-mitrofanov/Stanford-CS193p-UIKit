//
//  SetCard.swift
//  SET Game
//
//  Created by Максим Митрофанов on 06.02.2023.
//

import Foundation

struct SetCard {
    var isFaceUp: Bool = false
    var isMatched: Bool = false
    let symbol: GameSymbol
    let symbolCount: SymbolCount
    let fillStyle: FillStyle
    let color: SymbolColor
    
    private let id: Int
}

extension SetCard {
    init(symbol: GameSymbol, symbolCount: SymbolCount, fillStyle: FillStyle, color: SymbolColor) {
        self.symbol = symbol
        self.symbolCount = symbolCount
        self.fillStyle = fillStyle
        self.color = color
        self.id = SetCard.getNewID()
    }
}


extension SetCard {
    enum FillStyle: CaseIterable {
        case filled, outlined, striped
    }
    
    enum GameSymbol: CaseIterable {
        case rect, square, circle
    }
    
    enum SymbolCount: Int, CaseIterable {
        case one = 1
        case two = 2
        case three = 3
    }
    
    enum SymbolColor: CaseIterable  {
        case red, green, purple
    }
}

extension SetCard {
    static var idFactory: Int = 0
    static func getNewID() -> Int {
        idFactory += 1
        return idFactory
    }
}
