//
//  UniqueWithRespectTo.swift
//  EmojiArt
//
//  Created by Максим Митрофанов on 02.03.2023.
//

import Foundation

extension String {
    func iterated(for collection: [String]) -> String {
        let numberOfElementsWithSimilarPrefix = collection.filter { $0.hasPrefix(self) }.count
        
        if numberOfElementsWithSimilarPrefix > 0 {
            return self + " " + (numberOfElementsWithSimilarPrefix + 1).description
        } else {
            return self
        }
    }
}
