//
//  ImageCacheService.swift
//  PhotoGallery
//
//  Created by Akram Ul Hasan on 9/8/25.
//

import Foundation
import Combine
import UIKit

final class ImageCacheService: ImageCacheServiceProtocol {
    static let shared = ImageCacheService()
    private init() {}
    
    private let cache = URLCache(
        memoryCapacity: 100 * 1024 * 1024,
        diskCapacity: 200 * 1024 * 1024,
        diskPath: "imageCache"
    )
    
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.urlCache = self.cache
        config.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: config)
    }()
    
    private var activeRequests: [URL: AnyPublisher<UIImage?, Never>] = [:]
    private let requestQueue = DispatchQueue(label: "imageCache", attributes: .concurrent)
    
    
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        
        let request = URLRequest(url: url)
        if let cachedResponse = cache.cachedResponse(for: request),
           let image = UIImage(data: cachedResponse.data) {
            return Just(image).eraseToAnyPublisher()
        }
        
        return requestQueue.sync {
            if let existingPublisher = activeRequests[url] {
                return existingPublisher
            }
            
            let publisher = session.dataTaskPublisher(for: request)
                .subscribe(on: DispatchQueue.global(qos: .userInitiated))
                .map { [weak self] data, response -> UIImage? in
                    guard let self else { return nil }
                    
                    let cachedResponse = CachedURLResponse(
                        response: response as! HTTPURLResponse,
                        data: data
                    )
                    self.cache.storeCachedResponse(cachedResponse, for: request)
                    
                    return UIImage(data: data, scale: UIScreen.main.scale)
                }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveCompletion: { [weak self] _ in
                    self?.requestQueue.async(flags: .barrier) {
                        self?.activeRequests.removeValue(forKey: url)
                    }
                })
                .share()
                .eraseToAnyPublisher()
            
            activeRequests[url] = publisher
            return publisher
        }
    }
}
