//
//  MainCoordinatorMock.swift
//  MoviesAppTests
//
//  Created by Madrit Kacabumi on 07.06.23.
//

@testable import MoviesApp
import UIKit

class MainCoordinatorMock: MainCoordinatorType {
    
    let startCounter = TestCounter()
    let openDetailsCounter = TestCounter()
    
    var rootViewController: UIViewController?
    
    func start() {
        startCounter.increment()
    }
    
    func openDetails(_ movie: MoviesApp.MovieModel) {
        openDetailsCounter.increment()
    }
    
}
