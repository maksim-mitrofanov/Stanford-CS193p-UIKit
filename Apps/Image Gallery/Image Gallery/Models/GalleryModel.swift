//
//  GalleryModel.swift
//  Image Gallery
//
//  Created by Максим Митрофанов on 13.03.2023.
//

import Foundation

struct GalleryModel: Codable, Equatable {
    var name: String
    var imageURLs: [URL]
    var json: Data? { try? JSONEncoder().encode(self)}
    
    //Caching
    private static var cache = URLCache.shared
    
    static func loadFromCache(url: URL) -> Data? {
        guard let cachedResponse = cache.cachedResponse(for: URLRequest(url: url)) else { return nil }
        return cachedResponse.data
    }
    
    static func saveToCache(url: URL, with data: Data) {
        guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        else { return }
        
        let cachedResponse = CachedURLResponse(response: response, data: data)
        cache.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
    }
}

extension GalleryModel {
    init?(json: Data) {
        guard let newValue = try? JSONDecoder().decode(GalleryModel.self, from: json) else { return nil }
        self = newValue
    }
}








// MARK: - Mutating Methods

extension GalleryModel {
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

extension GalleryModel {
    static let animalURLs = [
        URL(string: "https://adamwillows.com/publications/two-perspectives-animal-morality/monkey-grooming-helping-1x1.webp"),
        URL(string:         "https://i.natgeofe.com/n/42dfedf7-cc27-4ffd-9a1f-4e3da0743209/nationalgeographic_1777610_square.jpg"),
        URL(string: "https://static.boredpanda.com/blog/wp-content/uuuploads/national-geographic-traveler-photo-contest-2013/national-geographic-traveler-photo-contest-2013-1.jpg"),
        URL(string: "https://cdn.pixabay.com/photo/2018/12/24/02/34/animal-3892151_1280.jpg"),
        URL(string: "https://media.newyorker.com/photos/62c4511e47222e61f46c2daa/4:3/w_2663,h_1997,c_limit/shouts-animals-watch-baby-hemingway.jpg"),
        URL(string: "https://i.pinimg.com/originals/33/2e/a4/332ea41e3f81d39e870f53cd252440b6.jpg"),
        URL(string: "https://i.pinimg.com/originals/8b/f3/12/8bf3123dcd3512a629054db6426e6ef8.jpg"),
        URL(string: "https://free4kwallpapers.com/uploads/originals/2020/02/08/animal-beauty-wallpaper.jpg")
        ] as! [URL]
    
    
    
    static let animals = GalleryModel(name: "National Geographic 🌏", imageURLs: animalURLs)
}
