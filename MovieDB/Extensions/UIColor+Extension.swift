//
//  UIColor+Extension.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 01/06/21.
//

import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let dbBackground = rgb(red: 37, green: 39, blue: 42, alpha: 1)
    static let dbSecondaryBackground = rgb(red: 32, green: 33, blue: 35, alpha: 1)
    static let dbTertiaryBackground = rgb(red: 255, green: 255, blue: 255, alpha: 0.87)
    static let dbYellow = rgb(red: 255, green: 209, blue: 48, alpha: 1)
    static let dbSecondaryYellow = rgb(red: 122, green: 108, blue: 54, alpha: 1)
}
