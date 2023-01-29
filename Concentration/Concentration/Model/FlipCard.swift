//
//  FlipCard.swift
//  Concentration
//
//  Created by Максим Митрофанов on 29.01.2023.
//

import Foundation

struct FlipCard {
    var isFaceUp: Bool = false
    var isMatched: Bool = false
    var identifier: Int
    
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = FlipCard.getUniqueIdentifier()
    }
}
