//
//  MockImageCacheService.swift
//  PhotoGalleryTests
//
//  Created by Akram Ul Hasan on 9/9/25.
//

import UIKit
import Combine
@testable import PhotoGallery

final class MockImageCacheService: ImageCacheServiceProtocol {
    var imageToReturn: UIImage?
    var callCount = 0
    var lastRequestedURL: URL?
    
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        callCount += 1
        lastRequestedURL = url
        return Just(imageToReturn).eraseToAnyPublisher()
    }
    
    
}
