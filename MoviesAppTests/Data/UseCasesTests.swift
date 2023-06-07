//
//  UseCasesTests.swift
//  MoviesAppTests
//
//  Created by Madrit Kacabumi on 08.06.23.
//

@testable import MoviesApp
import XCTest
import Combine

class UseCasesTests: XCTestCase {
    
    // MARK: - Properties
    let networkService = NetworkServiceMock()
    
    func test_moviesListUseCase() {
        let useCase = FetchMoviesListUseCase(network: networkService)
        XCTAssertNoThrow(useCase.getMoviesList())
    }
    
    func test_FavouritesListUseCase() {
        let useCase = FetchFavouritesMoviesUseCase(network: networkService)
        XCTAssertNoThrow(useCase.getFavourites())
    }
    
    func test_Images() throws {
        let useCase = FetchMovieImageUseCase(network: networkService)
        XCTAssertNoThrow(useCase.fetchMovieImage(for: "Dummy.png"))
    }
}
