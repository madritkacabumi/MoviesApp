//
//  HorizontalMoviePresentationAdapter.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 07.06.23.
//

import UIKit

class HorizontalMoviePresentationAdapter: NSObject {
    
    // MARK: - Properties
    var movieEntities: [MovieItemEntity] = []
    
    func registerCells(for collectionView: UICollectionView){
        collectionView.register(HorizontalMovieItemCollectionViewCell.self, forCellWithReuseIdentifier: HorizontalMovieItemCollectionViewCell.reuseIdentifier)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension HorizontalMoviePresentationAdapter: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieEntities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalMovieItemCollectionViewCell.reuseIdentifier, for: indexPath) as? HorizontalMovieItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.bind(with: movieEntities[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100.0, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        movieEntities[indexPath.row].isSelected.send(true)
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}
