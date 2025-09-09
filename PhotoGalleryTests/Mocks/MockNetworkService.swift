//
//  MockNetworkService.swift
//  PhotoGalleryTests
//
//  Created by Akram Ul Hasan on 9/9/25.
//

import Foundation
import Combine
@testable import PhotoGallery

final class MockNetworkService: NetworkServiceProtocol {
    var photosToReturn: [Photo] = []
    var errorToReturn: Error?
    
    func fetchPhotos(page: Int, limit: Int) -> AnyPublisher<[Photo], Error> {
        if let error = errorToReturn {
            return Fail(error: error)
                .eraseToAnyPublisher()
        } else {
            return Just(photosToReturn)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
