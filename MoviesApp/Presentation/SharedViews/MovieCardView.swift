//
//  VerticalMovieCard.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 07.06.23.
//

import UIKit
import Combine

class MovieCardView: UIView {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    var imagePublisher: PassthroughSubject<UIImage?, Never> = PassthroughSubject()
    let axis: NSLayoutConstraint.Axis
    
    // MARK: - UIViews
    lazy var imageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var movieTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    // MARK: - Construct
    
    init(axis: NSLayoutConstraint.Axis) {
        self.axis = axis
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    func setupView() {
        // setup self
        self.backgroundColor = Styles.Color.blackOpaque80Color
        self.cornerRadius = 6
        
        switch axis {
        case .horizontal:
            setupViewHorizontally()
        case .vertical:
            setupViewVertically()
        @unknown default: break
        }
    }
    
    private func setupViewVertically() {
        
        // add image container
        self.addSubview(imageContainer)
        imageContainer.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        imageContainer.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        imageContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        imageContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        // adding image to container
        imageContainer.addSubviewWithParentConstraints(subView: movieImage)
        
        // add movie title
        addSubview(movieTitle)
        movieTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        movieTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        movieTitle.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: .zero).isActive = true
        movieTitle.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 5).isActive = true
        movieTitle.textAlignment = .center
    }
    
    private func setupViewHorizontally() {
        
        // add image container
        self.addSubview(imageContainer)
        imageContainer.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        imageContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        imageContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        // adding image to container
        imageContainer.addSubviewWithParentConstraints(subView: movieImage)
        
        // add movie title
        addSubview(movieTitle)
        movieTitle.font = .systemFont(ofSize: 16)
        movieTitle.leadingAnchor.constraint(equalTo: self.imageContainer.trailingAnchor, constant: 10).isActive = true
        movieTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        movieTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive = true
        movieTitle.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 5).isActive = true
        movieTitle.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: 5).isActive = true
        movieTitle.textAlignment = .left
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageContainer.asCircle()
    }
    
    func load(title: String, imagePublisher: AnyPublisher<UIImage?, Never>) {
        disposeBag.clear()
        self.movieImage.image = Styles.Images.appIcon
        self.movieTitle.text = title
        imagePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self.movieImage)
            .store(in: disposeBag)
    }
}

