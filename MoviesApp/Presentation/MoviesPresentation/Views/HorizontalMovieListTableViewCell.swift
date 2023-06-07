//
//  HorizontalMovieListTableViewCell.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 06.06.23.
//

import UIKit

class HorizontalMovieListTableViewCell: UITableViewCell {
    
    static var reuseIdentifier: String { String(describing: HorizontalMovieListTableViewCell.self) }
    
    // MARK: - Properties
    let adapter = HorizontalMoviePresentationAdapter()
    
    // MARK: - UIViews
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.contentInset = UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: 16)
        collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 140).isActive = true
        collectionView.backgroundColor = .clear
        return collectionView
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
    
    // MARK: - SetupView
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.addSubviewWithParentConstraints(subView: collectionView)
        
        adapter.registerCells(for: collectionView)
        self.collectionView.delegate = adapter
        self.collectionView.dataSource = adapter
        
    }
    
    func bind(with movieEntities: [MovieItemEntity]) {
        adapter.movieEntities = movieEntities
        self.collectionView.reloadData()
    }
}
