//
//  DetailViewController.swift
//  SimpleToDoApp
//
//  Created by Thong Hoang Nguyen on 2019-05-02.
//  Copyright © 2019 Thong Hoang Nguyen. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    var themeFLAG = false
    var toDo: ToDo! {
        didSet {
            titleLabel.text = toDo.title
            descriptionLabel.text = "Description: \(toDo.toDoDescription ?? "")"
            priorityLabel.text = "Priority: \(toDo.priority)"
            isCompleteLabel.text = toDo.isCompleted ? "Completed" : "Incompleted"
        }
    }
    let titleLabel = UILabel(title: nil, color: .darkGray, fontSize: 30, isBold: true)
    let descriptionLabel = UILabel(title: nil, color: .black, fontSize: 20, isBold: false)
    let priorityLabel = UILabel(title: nil, color: .black, fontSize: 20, isBold: false)
    let isCompleteLabel = UILabel(title: nil, color: .black, fontSize: 20, isBold: false)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        if themeFLAG {
            view.backgroundColor = .black
            titleLabel.textColor = .white
            descriptionLabel.textColor = .white
            priorityLabel.textColor = .white
            isCompleteLabel.textColor = .white
        } else {
            view.backgroundColor = .white
            titleLabel.textColor = .darkGray
            descriptionLabel.textColor = .black
            priorityLabel.textColor = .black
            isCompleteLabel.textColor = .black
        }
        let smaillStackView: UIStackView = {
            let sv = UIStackView(arrangedSubviews: [descriptionLabel, priorityLabel, isCompleteLabel])
            sv.translatesAutoresizingMaskIntoConstraints = false
            sv.axis = .vertical
            sv.distribution = .equalSpacing
            sv.alignment = .leading
            sv.spacing = 20
            return sv
        }()
        let stackView: UIStackView = {
            let sv = UIStackView(arrangedSubviews: [titleLabel, smaillStackView])
            sv.translatesAutoresizingMaskIntoConstraints = false
            sv.axis = .vertical
            sv.distribution = .equalSpacing
            sv.alignment = .center
            sv.spacing = 20
            return sv
        }()
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            ])
        descriptionLabel.numberOfLines = 0
    }
}
