//
//  PhotoSaverService.swift
//  PhotoGallery
//
//  Created by Akram Ul Hasan on 9/7/25.
//

import UIKit
import Photos

final class PhotoSaverService: PhotoSaverServiceProtocol {
    static let shared = PhotoSaverService()
    private init() {}
    
    func savePhoto(_ urlString: String) async throws {
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "PhotoSaverService", code: -1, userInfo:     [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "PhotoSaverService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to convert to UIImage"])
        }
        
        guard let jpegData = image.jpegData(compressionQuality: 1.0) else {
            throw NSError(domain: "PhotoSaverService", code: -3, userInfo: [NSLocalizedDescriptionKey: "Failed to convert to JPEG"])
        }
        
        try await withCheckedThrowingContinuation { continuation in
            PHPhotoLibrary.shared().performChanges({
                let options = PHAssetResourceCreationOptions()
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: jpegData, options: options)
                
            }) { success, error in
                DispatchQueue.main.async {
                    if success {
                        continuation.resume()
                    } else {
                        continuation.resume(throwing: error ?? NSError(domain: "PhotoSaver", code: -4, userInfo: [NSLocalizedDescriptionKey: "Unknown error"]))
                    }
                }
            }
        }
    }
}
