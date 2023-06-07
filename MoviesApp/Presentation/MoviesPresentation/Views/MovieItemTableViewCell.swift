//
//  MovieItemTableViewCell.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 07.06.23.
//

import Foundation

import UIKit

class MovieItemTableViewCell: UITableViewCell {
    
    static var reuseIdentifier: String { String(describing: MovieItemTableViewCell.self) }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var entity: MovieItemEntity?
    
    // MARK: - UIViews
    lazy var movieCard: MovieCardView = {
        let card = MovieCardView(axis: .horizontal)
        card.borderWidth = 3
        card.borderColor = .clear
        return card
    }()
    
    // MARK: - Construct
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: Self.reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup View
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.addSubviewWithParentConstraints(subView: movieCard, edges: UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20))
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
            self.movieCard.borderColor = newValue ? Styles.Color.primaryBlueColor : .clear
        }
        get {
            return self.entity?.isSelected.value ?? false
        }
    }
}
