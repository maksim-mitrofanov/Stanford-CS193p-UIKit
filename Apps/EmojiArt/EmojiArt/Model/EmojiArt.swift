//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Максим Митрофанов on 20.03.2023.
//

import Foundation

struct EmojiArt: Codable {
    var url: String
    var emojis: [EmojiInfo]
    
    struct EmojiInfo: Codable {
        let x: Int
        let y: Int
        let text: String
        let size: Int
    }
    
    var json: Data? { try? JSONEncoder().encode(self) }
}

extension EmojiArt {
    init?(json: Data) {
        guard let newValue = try? JSONDecoder().decode(EmojiArt.self, from: json) else { return nil }
        self = newValue
    }
}
