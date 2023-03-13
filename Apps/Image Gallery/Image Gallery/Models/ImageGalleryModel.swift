//
//  ImageGalleryModel.swift
//  Image Gallery
//
//  Created by Максим Митрофанов on 13.03.2023.
//

import Foundation

struct ImageGalleryModel {
    private(set) var name: String
    
    
    mutating func rename(to newValue: String) {
        name = newValue
    }
}
