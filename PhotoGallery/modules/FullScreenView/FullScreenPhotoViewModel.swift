//
//  FullScreenPhotoViewModel.swift
//  PhotoGallery
//
//  Created by Techetron Ventures Ltd on 9/7/25.
//

import Foundation
import UIKit

@MainActor
class FullScreenPhotoViewModel: ObservableObject {
    @Published var message: String?
    
    private var photoSaver: PhotoSaverServiceProtocol
    
    init(photoSaver: PhotoSaverServiceProtocol = PhotoSaverService.shared) {
        self.photoSaver = photoSaver
    }
    
    func savePhotoToGallery(_ photoURL: String) {
        Task {
            do {
                try await photoSaver.savePhoto(photoURL)
                message = "Photo saved successfully"
                print("Photo saved successfully")

            } catch {
                message = "Failed to save photo: \(error.localizedDescription)"
                print("Failed to save photo: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.message = nil
            }
        }
    }
}
