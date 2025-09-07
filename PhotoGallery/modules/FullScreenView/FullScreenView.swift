//
//  FullScreenView.swift
//  PhotoGallery
//
//  Created by Akram Ul Hasan on 9/7/25.
//

import SwiftUI

struct FullScreenView: View {
    let photoURL: String
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = FullScreenPhotoViewModel()
    
    @State private var currentScale: CGFloat = 1
    @State private var gestureScale: CGFloat = 1
    @State private var currentOffset: CGSize = .zero
    @State private var gestureOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Color.blackLevel1
                .ignoresSafeArea()
            
            AsyncImage(url: URL(string: photoURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.whiteLevel1)
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(currentScale * gestureScale)
                        .offset(
                            x: currentOffset.width + gestureOffset.width,
                            y: currentOffset.height + gestureOffset.height
                        )
                        .gesture(
                            SimultaneousGesture(
                                MagnificationGesture()
                                    .onChanged { value in
                                        gestureScale = value
                                    }
                                    .onEnded { value in
                                        currentScale *= value
                                        gestureScale = 1
                                    },
                                DragGesture()
                                    .onChanged { value in
                                        if currentScale > 1 {
                                            gestureOffset = value.translation
                                        }
                                    }
                                    .onEnded { value in
                                        if currentScale > 1 {
                                            currentOffset.width += value.translation.width
                                            currentOffset.height += value.translation.height
                                            gestureOffset = .zero
                                        }
                                    }
                            )
                        )

                        .onTapGesture(count: 2) {
                            withAnimation(.easeInOut) {
                                currentScale = 1
                                currentOffset = .zero
                            }
                        }
                    
                case .failure:
                    Image(systemName: "Photo.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.whiteLevel1.opacity(0.7))
                    
                @unknown default:
                    EmptyView()
                }
            }
            
            VStack {
                HStack(spacing: 10) {
                    Spacer()
                    
                    Button{
                        viewModel.savePhotoToGallery(photoURL)
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                            .font(.system(size: 28))
                            .foregroundStyle(Color.whiteLevel1)
                            .padding(.trailing, 30)
                            .padding(.top, 20)
                    }
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 28))
                            .foregroundStyle(Color.whiteLevel1)
                            .padding(.trailing, 30)
                            .padding(.top, 20)
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    NavigationStack {
        FullScreenView(photoURL: "https://fastly.picsum.photos/id/237/200/300.jpg?hmac=TmmQSbShHz9CdQm0NkEjx1Dyh_Y984R9LpNrpvH2D_U")
    }
}
