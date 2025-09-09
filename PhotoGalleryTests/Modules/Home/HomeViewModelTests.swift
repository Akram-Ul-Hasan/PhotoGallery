//
//  HomeViewModelTests.swift
//  PhotoGalleryTests
//
//  Created by Techetron Ventures Ltd on 9/9/25.
//

import XCTest
import Combine
@testable import PhotoGallery

final class HomeViewModelTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
    var viewModel : HomeViewModel!
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        cancellables.removeAll()
        viewModel = nil
        super.tearDown()
    }
}
