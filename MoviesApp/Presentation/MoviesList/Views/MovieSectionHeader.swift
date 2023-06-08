//
//  MovieSectionHeader.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 07.06.23.
//

import UIKit

class MovieSectionHeader: UIView {
    
    let title: String
    
    lazy var sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Styles.Color.blackOpaque80Color
        label.font = Styles.Font.titleLargeSystemFont
        return label
    }()
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    func setupView() {
        self.backgroundColor = Styles.Color.white
        addSubviewWithParentConstraints(subView: sectionTitleLabel,
                                        edges: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        sectionTitleLabel.text = title
    }
    
}
