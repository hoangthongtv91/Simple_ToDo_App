//
//  String+Initializers.swift
//  SimpleToDoApp
//
//  Created by Thong Hoang Nguyen on 2019-05-02.
//  Copyright © 2019 Thong Hoang Nguyen. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    convenience init(title: String, isStrikeThrough: Bool) {
        self.init(string: title)
        if isStrikeThrough {
            addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, title.count))
        }
    }
}
