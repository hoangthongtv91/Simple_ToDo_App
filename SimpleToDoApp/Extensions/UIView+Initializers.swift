//
//  UIView+Initializers.swift
//  SimpleToDoApp
//
//  Created by Thong Hoang Nguyen on 2019-05-02.
//  Copyright © 2019 Thong Hoang Nguyen. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(title: String?, color: UIColor, fontSize : CGFloat, isBold: Bool) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        if let title = title {
            text = title
        }
        textColor = color
        if isBold {
            font = UIFont.boldSystemFont(ofSize: fontSize)
        } else {
            font = UIFont.systemFont(ofSize: fontSize)
        }
        heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
    }
}
