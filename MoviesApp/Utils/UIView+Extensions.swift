//
//  UIView+Extensions.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 06.06.23.
//

import UIKit

typealias Image = UIImage

extension UIView {
    
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    func borderAsCircle(){
        self.layer.cornerRadius = self.frame.width / 2;
        self.layer.masksToBounds = true
    }
    
    func addSubviewWithParentConstraints(subView: UIView, edges: UIEdgeInsets = .zero, useSafeArea: Bool = false) {
        addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        subView.leadingAnchor.constraint(equalTo: useSafeArea ? self.safeAreaLayoutGuide.leadingAnchor : self.leadingAnchor, constant: edges.left).isActive = true
        subView.trailingAnchor.constraint(equalTo: useSafeArea ? self.safeAreaLayoutGuide.trailingAnchor : self.trailingAnchor, constant: -edges.right).isActive = true
        subView.topAnchor.constraint(equalTo: useSafeArea ? self.safeAreaLayoutGuide.topAnchor : self.topAnchor, constant: edges.top).isActive = true
        subView.bottomAnchor.constraint(equalTo: useSafeArea ? self.safeAreaLayoutGuide.bottomAnchor : self.bottomAnchor, constant: -edges.bottom).isActive = true
    }
    
}
