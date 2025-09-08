//
//  ImageCacheServiceProtocol.swift
//  PhotoGallery
//
//  Created by Akram Ul Hasan on 9/8/25.
//

import Foundation
import Combine
import UIKit

protocol ImageCacheServiceProtocol {
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}
