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
            ZStack {
                if viewModel.isLoading {
                    ProgressView(StringConstants.Home.loadingPhotos)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    let screenWidth = UIScreen.main.bounds.width
                    let totalSpacing: CGFloat = spacing * CGFloat(columns.count + 1)
                    let cellSize = (screenWidth - totalSpacing) / CGFloat(columns.count)
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: spacing) {
                            ForEach(viewModel.photos) { photo in
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
                        .padding(spacing)
                    }
                }
            }
            .onAppear {
                viewModel.fetchPhotos()
            }
        }
    }
}

#Preview {
    HomeView()
}
