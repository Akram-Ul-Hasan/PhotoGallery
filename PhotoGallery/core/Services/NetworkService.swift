//
//  NetworkService.swift
//  PhotoGallery
//
//  Created by Akram Ul Hasan on 9/7/25.
//

import Foundation
import Combine

final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    private init() {}
    
    private let baseURL = "https://picsum.photos/v2/list"
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.urlCache = URLCache(
            memoryCapacity: 50 * 1024 * 1024,
            diskCapacity: 50 * 1024 * 1024,
            diskPath: "urlCache"
        )
        config.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: config)
    }()
    
    func fetchPhotos(page: Int, limit: Int) -> AnyPublisher<[Photo], any Error> {
        guard let url = URL(string: "\(baseURL)?page=\(page)&limit=\(limit)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let request = URLRequest(url: url)
        
        return session.dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                guard 200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                
                return data
            }
            .decode(type: [Photo].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
