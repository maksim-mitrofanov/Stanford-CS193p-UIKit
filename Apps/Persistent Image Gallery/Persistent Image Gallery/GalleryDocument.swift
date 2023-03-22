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
        // Encode your document with an instance of NSData or NSFileWrapper
        return Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
    }
}

