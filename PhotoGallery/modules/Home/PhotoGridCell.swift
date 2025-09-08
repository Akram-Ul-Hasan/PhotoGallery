//
//  PhotoGridCell.swift
//  PhotoGallery
//
//  Created by Akram Ul Hasan on 9/7/25.
//

import SwiftUI
import Combine

struct PhotoGridCell: View {
    let photo: Photo
    let cellSize: CGFloat
    
    @State private var image: UIImage? = nil
    @State private var cancellable: AnyCancellable? = nil
    
    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: cellSize, height: cellSize)
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            } else {
                ProgressView()
                    .frame(width: cellSize, height: cellSize)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            }
        }
        .onAppear {
            loadImage()
        }
        .onDisappear {
            cancellable?.cancel()
        }
    }
    
    private func loadImage() {
        guard let url = URL(string: photo.downloadURL) else { return }
        
        if image != nil {
            return
        }
        
        cancellable = ImageCacheService.shared.loadImage(from: url)
            .sink { image in
                self.image = image
            }
    }
}
