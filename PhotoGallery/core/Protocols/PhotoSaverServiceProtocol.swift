//
//  PhotoSaverServiceProtocol.swift
//  PhotoGallery
//
//  Created by Akram Ul Hasan on 9/7/25.
//

import UIKit
import Photos

protocol PhotoSaverServiceProtocol {
    func savePhoto(_ urlString: String) async throws
}
