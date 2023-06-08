//
//  MovieDetailViewModelTests.swift
//  MoviesAppTests
//
//  Created by Madrit Kacabumi on 08.06.23.
//

@testable import MoviesApp
import XCTest
import Combine

class MovieDetailViewModelTests: XCTestCase {
    
    // MARK: Properties
    let disposeBag = DisposeBag()
    private var viewModel: MovieDetailViewModel!
    private var fetchMovieImageUseCase: FetchMovieImageUseCaseMock!
    
    // MARK: I/O
    private var input: MovieDetailViewModel.Input!
    private var output: MovieDetailViewModel.Output!
    
    // MARK: triggers
    private var loadPageTrigger = Trigger<Void>()
    private var openPageDetailTrigger = Trigger<Void>()
    
    override func setUp() {
        super.setUp()
        
        fetchMovieImageUseCase = FetchMovieImageUseCaseMock()
        viewModel = MovieDetailViewModel(movie: MockProvider.moviesListResponse!.results.first!, fetchImageUseCase: fetchMovieImageUseCase)
        self.input = MovieDetailViewModel.Input(loadPageTrigger: loadPageTrigger)
        self.output = viewModel.transform(self.input, disposeBag: disposeBag)
    }
    
    func test_CountersAndSuccessTrigger() throws {
        
        _ = try triggeredPublisher(output.$loaded.filter { $0 }, trigger: {
            self.input.loadPageTrigger.fire()
        })
        
        XCTAssertTrue(self.fetchMovieImageUseCase.counter.count == 1)
        XCTAssertFalse(self.output.attributes.isEmpty)
        XCTAssertFalse(self.output.title.isEmpty)
        XCTAssertNotNil(self.output.loadImagePublisher)
        
        _ = try triggeredPublisher(output.loadImagePublisher!, trigger: {
            self.input.loadPageTrigger.fire()
        })
    }
    
}
