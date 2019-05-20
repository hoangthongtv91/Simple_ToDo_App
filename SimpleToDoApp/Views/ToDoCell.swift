//
//  ToDoCell.swift
//  SimpleToDoApp
//
//  Created by Thong Hoang Nguyen on 2019-05-01.
//  Copyright © 2019 Thong Hoang Nguyen. All rights reserved.
//

import UIKit

class ToDoCell: UITableViewCell {
    let titleLabel = UILabel(title: nil, color: .darkGray, fontSize: 25, isBold: true)
    let descriptionLabel = UILabel(title: nil, color: .black, fontSize: 17, isBold: false)
    let priorityLabel = UILabel(title: nil, color: .red, fontSize: 25, isBold: true)
    
    lazy var horizontalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, priorityLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fillEqually
        return sv
    }()
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [horizontalStackView, descriptionLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.alignment = .leading
        sv.distribution = .fillEqually
        return sv
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(verticalStackView)
        NSLayoutConstraint.activate([
            horizontalStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.5),
            verticalStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            verticalStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 40),
            verticalStackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
