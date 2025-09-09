//
//  PhotoGridCell.swift
//  PhotoGallery
//
//  Created by Akram Ul Hasan on 9/7/25.
//

import SwiftUI

struct PhotoGridCell: View {
    let image: UIImage?
    let cellSize: CGFloat
    
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
    }
}
