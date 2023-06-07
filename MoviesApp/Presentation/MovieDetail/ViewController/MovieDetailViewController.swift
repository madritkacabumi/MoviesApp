//
//  MovieDetailViewController.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 07.06.23.
//

import UIKit
import Combine

class MovieDetailViewController: UIViewController {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    let viewModel: MovieDetailViewModel
    let loadItemsTrigger = Trigger<Void>()
    
    // MARK: - UIViews
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var scrollableContent: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var movieCard: MovieCardView = {
        let card = MovieCardView(axis: .vertical)
        card.translatesAutoresizingMaskIntoConstraints = false
        card.widthAnchor.constraint(equalToConstant: 120).isActive = true
        card.heightAnchor.constraint(equalToConstant: 160).isActive = true
        return card
    }()
    
    lazy var attributesContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Styles.Color.blackOpaque80Color
        view.cornerRadius = 16
        return view
    }()
    
    lazy var attributesStack: UIStackView = {
        let attributesStack = UIStackView()
        attributesStack.spacing = 10
        attributesStack.distribution = .fill
        attributesStack.axis = .vertical
        return attributesStack
    }()
    
    // MARK: - Construct
    init(_ viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    func setupView() {
        self.view.backgroundColor = .white
        
        // add scrollview
        self.view.addSubviewWithParentConstraints(subView: scrollView, useSafeArea: true)
        // add scrollable container
        scrollView.addSubviewWithParentConstraints(subView: self.scrollableContent)
        scrollableContent.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        scrollableContent.addSubview(movieCard)
        movieCard.centerXAnchor.constraint(equalTo: scrollableContent.centerXAnchor).isActive = true
        movieCard.topAnchor.constraint(equalTo: scrollableContent.topAnchor, constant: 20).isActive = true
        
        // add attributes container
        scrollableContent.addSubview(attributesContainer)
        attributesContainer.topAnchor.constraint(equalTo: self.movieCard.bottomAnchor, constant: 20).isActive = true
        attributesContainer.leadingAnchor.constraint(equalTo: self.scrollableContent.leadingAnchor, constant: 16).isActive = true
        attributesContainer.trailingAnchor.constraint(equalTo: self.scrollableContent.trailingAnchor, constant: -16).isActive = true
        attributesContainer.bottomAnchor.constraint(lessThanOrEqualTo: self.scrollableContent.bottomAnchor, constant: -20).isActive = true
        
        // add stackview
        attributesContainer.addSubviewWithParentConstraints(subView: self.attributesStack, edges: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
    }
    
    private func generateAttributeView(labelString: String, value: String) -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .top
        stack.spacing = 10
        
        let labelAttr = UILabel()
        labelAttr.font = .boldSystemFont(ofSize: 16)
        labelAttr.textColor = .white
        labelAttr.text = labelString
        
        let labelValue = UILabel()
        labelValue.font = .systemFont(ofSize: 16)
        labelValue.textColor = .white
        labelValue.text = value
        labelAttr.contentMode = .center
        labelValue.numberOfLines = .zero
        
        stack.addArrangedSubview(labelAttr)
        stack.addArrangedSubview(labelValue)
        
        return stack
    }
}

// MARK: - Bind
extension MovieDetailViewController {
    
    func bind() {
        
        let input = MovieDetailViewModel.Input(
            loadPageTrigger: loadItemsTrigger)
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.$loaded
            .filter { $0 }
            .sink { [weak self] _ in
                self?.loadDataIntoViews(with: output)
            }.store(in: disposeBag)
        
        loadItemsTrigger.fire()
    }
    
    private func loadDataIntoViews(with output: MovieDetailViewModel.Output) {
        self.title = output.title
        if let loadImagePublisher = output.loadImagePublisher {
            self.movieCard.load(title: output.title, imagePublisher: loadImagePublisher)
        }
        attributesStack.arrangedSubviews.forEach { subView in
            attributesStack.removeArrangedSubview(subView)
        }
        
        for attribute in output.attributes {
            let view = self.generateAttributeView(labelString: attribute.label, value: attribute.value)
            attributesStack.addArrangedSubview(view)
        }
    }
}
