//
//  HomeViewModel.swift
//  PhotoGallery
//
//  Created by Akram Ul Hasan on 9/7/25.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let networkService: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func fetchPhotos(page: Int = 1, limit: Int = 30) {
        isLoading = true
        
        networkService.fetchPhotos(page: page, limit: limit)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Error fetching photos: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] photos in
                self?.photos = photos
            }
            .store(in: &cancellables)
    }
}
