//
//  UIColor+Extension.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 01/06/21.
//

import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let dbBackground = rgb(red: 37, green: 39, blue: 42)
    static let dbYellow = rgb(red: 255, green: 209, blue: 48)
}
