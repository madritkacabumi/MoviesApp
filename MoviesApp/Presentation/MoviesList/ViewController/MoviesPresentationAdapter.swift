//
//  MoviesPresentationAdapter.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 07.06.23.
//

import UIKit

protocol MoviesPresentationAdapterDelegate: AnyObject {
    func reloadData()
}

class MoviesPresentationAdapter: NSObject {
    
    // MARK: - Properties
    weak var delegate: MoviesPresentationAdapterDelegate?
    var sections: [MoviesSection] = [] {
        didSet {
            delegate?.reloadData()
        }
    }
    
    func registerCells(for tableView: UITableView) {
        tableView.register(HorizontalMovieListTableViewCell.self, forCellReuseIdentifier: HorizontalMovieListTableViewCell.reuseIdentifier)
        tableView.register(MovieItemTableViewCell.self, forCellReuseIdentifier: MovieItemTableViewCell.reuseIdentifier)
    }
}

extension MoviesPresentationAdapter: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section].sectionType {
        case .favorites:
            return 1
        case .toWatch, .watched:
            return sections[section].movies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch sections[indexPath.section].sectionType {
        case .favorites:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HorizontalMovieListTableViewCell.reuseIdentifier) as? HorizontalMovieListTableViewCell else {
                return UITableViewCell()
            }
            cell.bind(with: sections[indexPath.section].movies)
            return cell
        case .toWatch, .watched:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieItemTableViewCell.reuseIdentifier) as? MovieItemTableViewCell else {
                return UITableViewCell()
            }
            cell.bind(with: sections[indexPath.section].movies[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return MovieSectionHeader(title: sections[section].sectionType.title)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sections[indexPath.section].movies[indexPath.row].isSelected.send(true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
