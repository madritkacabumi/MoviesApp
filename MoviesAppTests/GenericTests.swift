//
//  GenericTests.swift
//  MoviesAppTests
//
//  Created by Madrit Kacabumi on 08.06.23.
//

@testable import MoviesApp
import XCTest
import Combine

class GenericTests: XCTestCase {
    
    func test_disposeBag() {
        
        let disposeBag = DisposeBag()
        
        Just("Nothing")
            .sink()
            .store(in: disposeBag)
        XCTAssertFalse(disposeBag.isEmpty)
        
        disposeBag.clear()
        XCTAssertTrue(disposeBag.isEmpty)
    }
}
