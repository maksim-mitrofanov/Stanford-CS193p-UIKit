//
//  GalleryDocument.swift
//  Persistent Image Gallery
//
//  Created by Максим Митрофанов on 22.03.2023.
//

import UIKit

class GalleryDocument: UIDocument {
    
    var currentGallery: ImageGalleryModel?
    
    override func contents(forType typeName: String) throws -> Any {
        return currentGallery?.json ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let json = contents as? Data {
            currentGallery = ImageGalleryModel(json: json)
        }
    }
}

