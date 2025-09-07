//
//  NetworkServiceProtocol.swift
//  PhotoGallery
//
//  Created by Akram Ul Hasan on 9/7/25.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func fetchPhotos(page: Int, limit: Int) -> AnyPublisher<[Photo], Error>
}
