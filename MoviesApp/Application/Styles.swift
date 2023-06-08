//
//  Styles.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 06.06.23.
//

import UIKit

struct Styles {
    
    // MARK: - Color
    struct Color {
        static let primaryBlueColor = UIColor(hexString: "#0A7BBA")
        static let blackOpaque80Color = UIColor.black.withAlphaComponent(0.8)
        static let errorLabel = UIColor.red
        static let white = UIColor.white
        
    }
    
    // MARK: - UIFont
    struct Image {
        static var appIcon: UIImage? { UIImage(named: "AppIcon") }
        
    }
    
    // MARK: - UIFont
    struct Font {
        static let titleLargeSystemFont = UIFont.systemFont(ofSize: 22)
        static let mediumSystemFont = UIFont.systemFont(ofSize: 16)
        static let smallSystemFont = UIFont.systemFont(ofSize: 12)
        
    }
}

extension UIColor {
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        
        var hexFormatted: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
}
