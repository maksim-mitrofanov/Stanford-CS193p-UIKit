//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by Максим Митрофанов on 11.02.2023.
//

import Foundation

struct PlayingCard: CustomStringConvertible {
    var suit: Suit
    var rank: Rank
    var description: String {
        return ("Suit: \(suit): Rank: \(rank)")
        
    }
    
    enum Suit: String, CaseIterable, CustomStringConvertible {
        var description: String {
            return self.rawValue
        }
        
        case spades = "♠️"
        case diamonds = "♦️"
        case hearts = "♥️"
        case clubs = "♣️"
    }
    
    enum Rank: CustomStringConvertible {
        var description: String {
            switch self {
            case .ace: return "Ace"
            case .numeric(let pipsCount): return pipsCount.description
            case .face(let face): return face.description
            }
        }
        
        case ace
        case face(Face)
        case numeric(Int)
        
        var order: Int {
            switch self {
            case .ace: return 1
            case .numeric(let pips): return pips
            case .face(let face):
                return 10 + face.rawValue
            }
        }
        
        static var all: [Rank] {
            var allRanks: [Rank] = [.ace]
            for pips in 2...10 {
                allRanks.append(.numeric(pips))
            }
            let faces: [Rank] = [.face(.jack), .face(.queen), .face(.king)]
            allRanks.append(contentsOf: faces)
            
            return allRanks
        }
    }
    
    enum Face: Int, CaseIterable, CustomStringConvertible {
        var description: String {
            switch self {
            case .king: return "King"
            case .jack: return "Jack"
            case .queen: return "Queen"
            }
        }
        
        case jack = 1
        case queen = 2
        case king = 3
    }
}
