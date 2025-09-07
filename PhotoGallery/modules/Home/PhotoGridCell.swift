//
//  PhotoGridCell.swift
//  PhotoGallery
//
//  Created by Akram Ul Hasan on 9/7/25.
//

import SwiftUI

struct PhotoGridCell: View {
    let photo: Photo
    let cellSize: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: photo.downloadURL)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: cellSize, height: cellSize)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: cellSize, height: cellSize)
                    .foregroundStyle(.gray)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            case .empty:
                ProgressView()
                    .frame(width: cellSize, height: cellSize)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    
            @unknown default:
                EmptyView()
            }
        }
    }
}
