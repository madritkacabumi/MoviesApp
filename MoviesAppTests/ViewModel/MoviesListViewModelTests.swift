//
//  MoviesListViewModelTests.swift
//  MoviesAppTests
//
//  Created by Madrit Kacabumi on 07.06.23.
//

@testable import MoviesApp
import XCTest
import Combine

class MoviesListViewModelTests: XCTestCase {
    
    // MARK: Properties
    let disposeBag = DisposeBag()
    private var viewModel: MoviesListViewModel!
    
    // MARK: Mock
    private var coordinator: MainCoordinatorMock!
    private var fetchMoviesUseCase: FetchMoviesListUseCaseMock!
    private var fetchFavouritesUseCase: FetchFavouritesMoviesUseCaseMock!
    private var fetchMovieImageUseCase: FetchMovieImageUseCaseMock!
    
    // MARK: I/O
    private var input: MoviesListViewModel.Input!
    private var output: MoviesListViewModel.Output!
    
    // MARK: triggers
    private var loadPageTrigger = Trigger<Void>()
    private var openPageDetailTrigger = Trigger<Void>()
    
    override func setUp() {
        super.setUp()
        
        coordinator = MainCoordinatorMock()
        coordinator.start()
        fetchMoviesUseCase = FetchMoviesListUseCaseMock(isFailure: false)
        fetchFavouritesUseCase = FetchFavouritesMoviesUseCaseMock()
        fetchMovieImageUseCase = FetchMovieImageUseCaseMock()
        extraSetupViewModel()
    }
    
    private func extraSetupViewModel() {
        viewModel = MoviesListViewModel(moviesListUseCase: fetchMoviesUseCase,
                                        favouritesUseCase: fetchFavouritesUseCase,
                                        fetchImageUseCase: fetchMovieImageUseCase,
                                        coordinator: coordinator)
        self.input = MoviesListViewModel.Input(loadPageTrigger: loadPageTrigger, openDetailsTrigger: openPageDetailTrigger)
        self.output = viewModel.transform(self.input, disposeBag: disposeBag)
    }
    
    func test_CountersAndSuccessTrigger() throws {
        
        _ = try triggeredPublisher(output.$sections.dropFirst(), trigger: {
            self.input.loadPageTrigger.fire()
        })
        
        XCTAssertTrue(self.fetchMoviesUseCase.counter.count == 1)
        XCTAssertTrue(self.fetchFavouritesUseCase.counter.count == 1)
        XCTAssertFalse(self.output.sections.isEmpty)
        XCTAssertFalse(self.output.sections.first!.movies.isEmpty)
        XCTAssertNil(self.output.errorMessage)
        
        _ = try triggeredPublisher(output.sections.first!.movies.first!.imagePublisher)
        XCTAssertTrue(self.fetchMovieImageUseCase.counter.count == 1)
        
        output.sections.first!.movies.first!.isSelected.send(true)
        self.input.openDetailsTrigger.fire()
        
        XCTAssertTrue(self.coordinator.startCounter.count == 1)
        XCTAssertTrue(self.coordinator.openDetailsCounter.count == 1)
    }
    
    func test_Error() throws {
        fetchMoviesUseCase = FetchMoviesListUseCaseMock(isFailure: true)
        self.extraSetupViewModel()
        
        _ = try triggeredPublisher(output.$errorMessage.compactMap { $0 }, trigger: {
            self.input.loadPageTrigger.fire()
        })
        
        XCTAssertNotNil(self.output.errorMessage)
    }
    
}
