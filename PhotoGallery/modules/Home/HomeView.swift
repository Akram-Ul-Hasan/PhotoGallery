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
                if viewModel.isFirstLoad {
                    ProgressView(StringConstants.Home.loadingPhotos)
                } else if let error = viewModel.errorMessage, viewModel.photos.isEmpty {
                    Text(error)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: spacing) {
                            ForEach(viewModel.photos) { photo in
                                NavigationLink(destination: FullScreenView(photoURL: photo.downloadURL)) {
                                    PhotoGridCell(photo: photo, cellSize: cellSize)
                                }
                                .onAppear {
                                    viewModel.loadMorePhotosIfNeeded(currentItem: photo)
                                }
                            }
                        }
                        .padding(spacing)
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .padding()
                        }
                    }
                }
            }
            
            .navigationTitle(StringConstants.Home.title)
            .onAppear {
                if viewModel.photos.isEmpty {
                    viewModel.loadInitialPhotos()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
