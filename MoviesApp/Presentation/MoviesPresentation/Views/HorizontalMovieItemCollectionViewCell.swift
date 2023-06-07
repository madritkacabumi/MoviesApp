//
//  HorizontalMovieItemCollectionViewCell.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 06.06.23.
//

import UIKit
import Combine

class HorizontalMovieItemCollectionViewCell: UICollectionViewCell {
    
    static var reuseIdentifier: String { String(describing: HorizontalMovieItemCollectionViewCell.self) }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var entity: MovieItemEntity?
    
    //MARK: - UIViews
    lazy var movieCard: MovieCardView = {
        let card = MovieCardView(axis: .vertical)
        card.borderWidth = 3
        card.borderColor = .clear
        card.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return card
    }()
    
    // MARK: - Construct
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - SetupView
    private func setupView() {
        self.backgroundColor = .clear
        self.contentView.addSubviewWithParentConstraints(subView: movieCard)
    }
    
    func bind(with entity: MovieItemEntity) {
        self.entity = entity
        disposeBag.clear()
        movieCard.load(title: entity.title, imagePublisher: entity.imagePublisher)
        entity.isSelected
            .receive(on: DispatchQueue.main)
            .assign(to: \.cellSelected, on: self)
            .store(in: disposeBag)
    }
    
    // MARK: - Selection
    var cellSelected: Bool {
        set {
            self.movieCard.borderColor = newValue ? Styles.Color.primaryBlueColor : .white
        }
        get {
            return self.entity?.isSelected.value ?? false
        }
    }
}
