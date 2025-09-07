//
//  PhotoModel.swift
//  PhotoGallery
//
//  Created by Techetron Ventures Ltd on 9/7/25.
//

import Foundation

struct Photo: Identifiable, Decodable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let downloadURL: String

    enum codingKeys: String, CodingKey {
        case id
        case author
        case width
        case height
        case url
        case downloadURL = "download_url"
    }
}
