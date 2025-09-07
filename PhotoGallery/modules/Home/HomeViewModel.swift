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
    
    private var currentPage = 1
    private var limit = 30
    private var canLoadMore = true
    
    var isFirstLoad: Bool {
        photos.isEmpty && isLoading
    }
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func loadInitialPhotos() {
        reset()
        fetchPhotos()
    }
    
    func loadMorePhotosIfNeeded(currentItem: Photo?) {
        guard let currentItem else { return }
        guard !isLoading, canLoadMore else { return }
        
        let thresholdIndex = photos.index(photos.endIndex, offsetBy: -6, limitedBy: photos.startIndex) ?? photos.startIndex
        if let index = photos.firstIndex(where: { $0.id == currentItem.id }),
           index >= thresholdIndex {
            fetchPhotos()
        }
    }
    
    func fetchPhotos() {
        guard !isLoading, canLoadMore else { return }
        
        isLoading = true
        
        networkService.fetchPhotos(page: currentPage, limit: limit)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                    print("Error fetching photos: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] newPhotos in
                guard let self = self else { return }
                self.photos.append(contentsOf: newPhotos)
                self.currentPage += 1
                self.canLoadMore = !newPhotos.isEmpty
            }
            .store(in: &cancellables)
    }
    
    private func reset() {
        photos = []
        currentPage = 1
        canLoadMore = true
        errorMessage = nil
    }
}
