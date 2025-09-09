//
//  HomeViewModelTests.swift
//  PhotoGalleryTests
//
//  Created by Akram Ul Hasan on 9/9/25.
//

import XCTest
import Combine
@testable import PhotoGallery

final class HomeViewModelTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
    var viewModel : HomeViewModel!
    var mockNetWork: MockNetworkService!
    var mockImageCache: MockImageCacheService!
    
    
    override func setUp() {
        super.setUp()
        
        mockNetWork = MockNetworkService()
        mockImageCache = MockImageCacheService()
        viewModel = HomeViewModel(networkService: mockNetWork, imageCacheService: mockImageCache)
        cancellables = []
    }
    
    override func tearDown() {
        cancellables.removeAll()
        mockNetWork = nil
        mockImageCache = nil
        viewModel = nil
        super.tearDown()
    }
    
    func test_LoadInitialPhotos_Success() {
        let mockPhotos: [Photo] = [
            Photo(id: "1", author: "a1", width: 200, height: 200, url: "url1", downloadURL: "url1"),
            Photo(id: "2", author: "a2", width: 200, height: 200, url: "url2", downloadURL: "url2"),
        ]
        
        mockNetWork.photosToReturn = mockPhotos
        let expectation = XCTestExpectation(description: "photo loading...")
        
        viewModel.$photos
            .sink { photos in
                if photos.count == 2 {
                    expectation.fulfill()
                }
                
            }
            .store(in: &cancellables)
        
        viewModel.loadInitialPhotos()
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(viewModel.photos.count, 2)
        XCTAssertEqual(viewModel.photos.first?.id, "1")
        XCTAssertFalse(viewModel.isLoading)
        
    }
    
    
    func test_LoadInitialPhotos_Failure() {
        let networkError = URLError(.notConnectedToInternet)
        mockNetWork.errorToReturn = networkError
        let expectation = XCTestExpectation(description: "Error received")
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { error in
                if let error = error {
                    XCTAssertFalse(error.isEmpty, "Error message should not be empty")
                    XCTAssertEqual(error, networkError.localizedDescription)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.loadInitialPhotos()
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(viewModel.photos.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }

    
    func testLoadImage_cachesImage() {
        let photo = Photo(id: "1", author: "a1", width: 200, height: 200, url: "url1", downloadURL: "url1")
        
        mockImageCache.imageToReturn = UIImage(systemName: "photo")
        let expectation = XCTestExpectation(description: "Image cached")
        
        viewModel.$imagesCache
            .dropFirst()
            .sink { cache in
                XCTAssertNotNil(cache[photo.id])
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.loadImage(for: photo, size: CGSize(width: 200, height: 200))
        
        wait(for: [expectation], timeout: 1.0)
    }
}
