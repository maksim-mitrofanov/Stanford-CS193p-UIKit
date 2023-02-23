//
//  SetGameTheme.swift
//  SET Game
//
//  Created by Максим Митрофанов on 07.02.2023.
//

import UIKit

struct SetGameTheme {
    private static func getBaseColor(for card: SetCardData) -> UIColor {
        let cardColor: UIColor = {
            switch card.color {
            case .red: return UIColor.red
            case .green: return UIColor.green
            case .purple: return UIColor.purple
            }
        }()
        
        return cardColor
    }
    
    private static func getForegroundColor(for card: SetCardData) -> UIColor {
        let cardColor = getBaseColor(for: card)
        let colorWithOpacity: UIColor = {
            switch card.fillStyle {
            case .filled: return cardColor
            case .outlined: return UIColor.clear
            case .striped: return cardColor.withAlphaComponent(0.2)
            }
        }()
        
        return colorWithOpacity
    }
    
    private static func getStrokeColor(for card: SetCardData) -> UIColor {
        let cardColor = getBaseColor(for: card)
        
        let strokeColor: UIColor = {
            switch card.fillStyle {
            case .filled: return UIColor.black.withAlphaComponent(0.3)
            case .striped: return cardColor
            case .outlined: return cardColor
            }
        }()
        
        return strokeColor
    }
    
    private static func getTitle(for card: SetCardData) -> String {
        let cardTitle: String = {
            switch card.symbol {
            case .circle: return String(repeating: "●", count: card.symbolCount.rawValue)
            case .rect: return String(repeating: "▲", count: card.symbolCount.rawValue)
            case .square: return String(repeating: "■", count: card.symbolCount.rawValue)
            }
        }()
        
        return cardTitle
    }
    
    static func getAttributedTitle(for card: SetCardData) -> NSMutableAttributedString {
        let cardTitle = SetGameTheme.getTitle(for: card)
        let cardTitleAttributes: [NSAttributedString.Key : Any] = [
            .strokeColor : SetGameTheme.getStrokeColor(for: card),
            .strokeWidth: -5,
            .foregroundColor : SetGameTheme.getForegroundColor(for: card)
        ]
        
        return NSMutableAttributedString(string: cardTitle, attributes: cardTitleAttributes)
    }
}

