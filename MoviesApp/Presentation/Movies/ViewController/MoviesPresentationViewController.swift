//
//  MoviesPresentationViewController.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 06.06.23.
//

import UIKit

class MoviesPresentationViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: MoviesPresentationViewModel
    let disposeBag = DisposeBag()
    let trigger = Trigger<Void>()
    
    // MARK: - Construct
    init(viewModel: MoviesPresentationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.bind()
    }
    
    func setupView() {
        self.view.backgroundColor = .blue
    }
    
}

// MARK: - Bind
extension MoviesPresentationViewController {
    
    func bind() {
        let input = MoviesPresentationViewModel.Input(loadPageTrigger: trigger)
        let output = viewModel.transform(input, disposeBag: disposeBag)
        output.$sections
            .receive(on: DispatchQueue.main)
            .sink { sections in
                print(Thread.isMainThread)
                let tmp = ""
            }.store(in: disposeBag)
        
        trigger.fire()
    }
}

