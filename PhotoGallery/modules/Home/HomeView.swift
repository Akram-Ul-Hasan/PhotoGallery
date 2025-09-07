//
//  HomeView.swift
//  PhotoGallery
//
//  Created by Techetron Ventures Ltd on 9/7/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    @State private var selectedPhoto: Photo?
    @State private var showFullScreen: Bool = false
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let spacing: CGFloat = 10
    
    var body: some View {
        NavigationStack {
            let screenWidth = UIScreen.main.bounds.width
            let totalSpacing: CGFloat = spacing * CGFloat(columns.count + 1)
            let cellSize = (screenWidth - totalSpacing) / CGFloat(columns.count)
            
            ZStack {
                if viewModel.isLoading {
                    ProgressView(StringConstants.Home.loadingPhotos)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: spacing) {
                            ForEach(viewModel.photos) { photo in
                                PhotoGridCell(photo: photo, cellSize: cellSize)
                            }
                        }
                        .padding(spacing)
                    }
                }
            }
            .onAppear {
                viewModel.fetchPhotos()
            }
            .navigationTitle(StringConstants.Home.title)
        }
    }
}

#Preview {
    HomeView()
}
