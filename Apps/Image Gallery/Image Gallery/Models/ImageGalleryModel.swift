//
//  ImageGalleryModel.swift
//  Image Gallery
//
//  Created by Максим Митрофанов on 13.03.2023.
//

import Foundation

struct ImageGalleryModel: Codable, Equatable {
    var name: String
    var imageURLs: [URL]
    
    var json: Data? { try? JSONEncoder().encode(self)}
}

extension ImageGalleryModel {
    init?(json: Data) {
        guard let newValue = try? JSONDecoder().decode(ImageGalleryModel.self, from: json) else { return nil }
        self = newValue
    }
}








// MARK: - Mutating Methods

extension ImageGalleryModel {
    mutating func addNewImage(with url: URL, at indexPath: IndexPath) {
        imageURLs.insert(url, at: indexPath.item)
    }
    
    mutating func acceptLocalDrop(of url: URL, from initialIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = imageURLs.remove(at: initialIndexPath.item)
        imageURLs.insert(item, at: destinationIndexPath.item)
    }
    
    mutating func acceptExternalDrop(of url: URL, to destinationIndexPath: IndexPath) {
        imageURLs.insert(url, at: destinationIndexPath.item)
    }
}









// MARK: - Template

extension ImageGalleryModel {
    static let animalURLs = [
        URL(string: "https://adamwillows.com/publications/two-perspectives-animal-morality/monkey-grooming-helping-1x1.webp"),
        URL(string:         "https://i.natgeofe.com/n/42dfedf7-cc27-4ffd-9a1f-4e3da0743209/nationalgeographic_1777610_square.jpg"),
        URL(string: "https://static.boredpanda.com/blog/wp-content/uuuploads/national-geographic-traveler-photo-contest-2013/national-geographic-traveler-photo-contest-2013-1.jpg"),
        URL(string: "https://cdn.pixabay.com/photo/2018/12/24/02/34/animal-3892151_1280.jpg"),
        URL(string: "https://wallup.net/wp-content/uploads/2018/10/05/237086-nature-animal-bird-national-geographic-green-flower-hd-wallpapers.jpg"),
        URL(string: "https://i.pinimg.com/originals/33/2e/a4/332ea41e3f81d39e870f53cd252440b6.jpg"),
        URL(string: "https://i.pinimg.com/originals/8b/f3/12/8bf3123dcd3512a629054db6426e6ef8.jpg"),
        URL(string: "https://www.cultofmac.com/wp-content/uploads/2014/10/natural-history-museum-wildlife-photographer-of-the-year-2014-designboom-02-1.jpg")
        ] as! [URL]
    
    static let shortURLs = [
        URL(string: "https://img3.wallspic.com/previews/6/5/8/1/7/171856/171856-snow-leopard-snow_leopard-macbook-carnivore-550x310.jpg"),
        URL(string:         "https://lh3.googleusercontent.com/aqiyRcEUPVV4SiaM7I-u5rgxVnfrM3s6_LACB1GQs1ToVnVD92A0luHeLfe8qkOwl8gjDOWAEGWwPGF2Nhmwl0464A=w640-h400-e365-rj-sc0x00ffffff")
    ] as! [URL]
    
    
    
    static let animals = ImageGalleryModel(name: "National Geographic 🌏", imageURLs: shortURLs)
}
