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
    
    func fetchPhotos(page: Int = 1, limit: Int = 30) -> AnyPublisher<[Photo], any Error> {
        guard let url = URL(string: "\(baseURL)?page=\(page)&limit=\(limit)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Photo].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
