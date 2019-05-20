//
//  Themes.swift
//  SimpleToDoApp
//
//  Created by Thong Hoang Nguyen on 2019-05-18.
//  Copyright © 2019 Thong Hoang Nguyen. All rights reserved.
//

import UIKit

struct Themes {
    static var backgroundColor: UIColor?
    static var primaryTextColor: UIColor?
    static var secondaryTextColor: UIColor?
    
    static func defaultTheme() {
        backgroundColor = .white
        primaryTextColor = .darkGray
        secondaryTextColor = .black
    }
    static func darkTheme() {
        backgroundColor = .black
        primaryTextColor = .white
        secondaryTextColor = .white
    }
    static func updateDisplay() {
        let proxyView = UIView.appearance()
        proxyView.backgroundColor = backgroundColor
        
        let proxyLabel = UILabel.appearance()
        proxyLabel.textColor = primaryTextColor
    }
}
