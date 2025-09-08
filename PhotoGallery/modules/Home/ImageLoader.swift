//
//  ImageLoader.swift
//  PhotoGallery
//
//  Created by Akram Ul Hasan on 9/8/25.
//

import UIKit
import Combine

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?
    
    func load(from url: URL) {
        if image != nil { return }
        
        cancellable = ImageCacheService.shared.loadImage(from: url)
            .assign(to: \.image, on: self)
    }
    
    deinit {
        cancellable?.cancel()
    }
}
