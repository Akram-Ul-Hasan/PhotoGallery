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
    
    @StateObject private var loader = ImageLoader()
    
    var body: some View {
        ZStack {
            if let image = loader.image {
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
            if let url = URL(string: "https://picsum.photos/id/\(photo.id)/\(Int(cellSize))/\(Int(cellSize))") {
                loader.load(from: url)
            }
        }
    }
}
