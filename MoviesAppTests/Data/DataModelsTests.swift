//
//  DataModelsTests.swift
//  MoviesAppTests
//
//  Created by Madrit Kacabumi on 08.06.23.
//

@testable import MoviesApp
import XCTest

class DataModelsTests: XCTestCase {
    
    func test_dataParsing() {
        XCTAssertNotNil(MockProvider.moviesListResponse)
        XCTAssertNotNil(MockProvider.favouritesListResponse)
    }
}
