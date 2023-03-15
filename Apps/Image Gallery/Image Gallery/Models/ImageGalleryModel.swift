//
//  ImageGalleryModel.swift
//  Image Gallery
//
//  Created by Максим Митрофанов on 13.03.2023.
//

import Foundation

struct ImageGalleryModel {
    private(set) var name: String
    private(set) var imageCount: Int = 0    
    private(set) var imageURLs = [String]()
    let id: String = UUID().uuidString
    
    init(name: String, imageCount: Int) {
        self.name = name
        self.imageCount = imageCount
        self.imageURLs = ImageGalleryModel.getTemplatePictureURLs(count: imageCount)
    }
    
    mutating func rename(to newValue: String) {
        name = newValue
    }
    
    mutating func changeImageCount(to newValue: Int) {
        imageCount = newValue
    }
    
    mutating func addNewImage(with url: URL, at indexPath: IndexPath) {
        imageURLs.insert(url.description, at: indexPath.item)
    }
}

extension ImageGalleryModel {
    static var templates = [
        ImageGalleryModel(name: "Animals 🐶", imageCount: Int.random(in: 20...100)),
        ImageGalleryModel(name: "Sports 🏈", imageCount: Int.random(in: 20...100)),
        ImageGalleryModel(name: "Programming 🧑🏻‍💻", imageCount: Int.random(in: 20...100)),
        ImageGalleryModel(name: "Biology 🌱", imageCount: Int.random(in: 20...100)),
        ImageGalleryModel(name: "Family 🌷", imageCount: Int.random(in: 20...100)),
    ]
    
    static var templatesTwo = [
        ImageGalleryModel(name: "Farm 🌾", imageCount: Int.random(in: 20...100)),
        ImageGalleryModel(name: "Planets 🌎", imageCount: Int.random(in: 20...100))
    ]
    
    static func getTemplatePictureURLs(count: Int) -> [String] {
        var urls = [String]()
        
        for _ in 0...count {
            urls.append("https://picsum.photos/200")
        }
        
        return urls
    }
}
