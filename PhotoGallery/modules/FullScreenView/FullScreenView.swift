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
    var body: some View {
        ZStack {
            Color.blackLevel1.ignoresSafeArea()
            
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
                HStack {
                    Spacer()

                    Button{
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
