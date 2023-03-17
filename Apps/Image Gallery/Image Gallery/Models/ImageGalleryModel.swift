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
    
    init(name: String, images: [String]) {
        self.name = name
        self.imageURLs = images
        self.imageCount = images.count
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
    
    mutating func acceptLocalDrop(of url: URL, from initialIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = imageURLs.remove(at: initialIndexPath.item)
        imageURLs.insert(item, at: destinationIndexPath.item)
    }
    
    mutating func acceptExternalDrop(of url: URL, to destinationIndexPath: IndexPath) {
        imageURLs.insert(url.description, at: destinationIndexPath.item)
    }
}

extension ImageGalleryModel {
    static var animalURLs = [
        "https://adamwillows.com/publications/two-perspectives-animal-morality/monkey-grooming-helping-1x1.webp",
        
        "https://i.natgeofe.com/n/42dfedf7-cc27-4ffd-9a1f-4e3da0743209/nationalgeographic_1777610_square.jpg",
        
        "https://static.boredpanda.com/blog/wp-content/uuuploads/national-geographic-traveler-photo-contest-2013/national-geographic-traveler-photo-contest-2013-1.jpg",
        
        "https://cdn.pixabay.com/photo/2018/12/24/02/34/animal-3892151_1280.jpg",
        
        "https://wallup.net/wp-content/uploads/2018/10/05/237086-nature-animal-bird-national-geographic-green-flower-hd-wallpapers.jpg",
        
        "https://i.pinimg.com/originals/33/2e/a4/332ea41e3f81d39e870f53cd252440b6.jpg","https://i.pinimg.com/originals/8b/f3/12/8bf3123dcd3512a629054db6426e6ef8.jpg",
        
        "https://www.cultofmac.com/wp-content/uploads/2014/10/natural-history-museum-wildlife-photographer-of-the-year-2014-designboom-02-1.jpg"]
    
    static var templates = [
        ImageGalleryModel(name: "Animals 🐶", images: animalURLs),
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
            urls.append("https://picsum.photos/800")
        }
        
        return urls
    }
}
