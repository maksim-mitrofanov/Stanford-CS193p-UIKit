//
//  ConcentrationGameTheme.swift
//  Concentration
//
//  Created by Максим Митрофанов on 29.01.2023.
//

import UIKit

struct ConcentrationGameTheme {
    let emojis: [String]
    let backgroundColor: UIColor
}

extension ConcentrationGameTheme {
    static let characters = ConcentrationGameTheme(emojis: ["🧑‍🚀", "🧑‍⚖️", "🦸🏻‍♂️", "🦹‍♀️", "🥷", "🧙‍♂️", "🧝‍♀️", "🧌", "🧛‍♀️", "🧟‍♂️", "🧞‍♂️"], backgroundColor: UIColor.systemOrange)
    static let fruits = ConcentrationGameTheme(emojis:["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐", "🍈", "🍒", "🍑", "🥭", "🍍", "🥥", "🥝"], backgroundColor: UIColor.systemBlue)
    static let vegetables = ConcentrationGameTheme(emojis: ["🍅", "🍆", "🥑", "🥦", "🥬", "🥒", "🌶️", "🫑", "🌽", "🥕", "🫒", "🧄", "🧅", "🥔", "🍠"], backgroundColor: .purple)
    static let junkFood = ConcentrationGameTheme(emojis: ["🥐", "🥯", "🍞", "🥖", "🥨", "🧀", "🧈", "🍳", "🥞", "🧇", "🥓", "🥩", "🍗", "🍖"], backgroundColor: .systemPink)
    static let vehicles = ConcentrationGameTheme(emojis: ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎️", "🚓", "🛵", "🚲", "🚛", "🚜", "🚒", "🚑"], backgroundColor: UIColor.systemMint)
    
    static func randomTheme() -> ConcentrationGameTheme {
        let allThemes: [ConcentrationGameTheme] = [.characters, .fruits, .vegetables, .vehicles, .junkFood]
        return allThemes.shuffled()[0]
    }
}
