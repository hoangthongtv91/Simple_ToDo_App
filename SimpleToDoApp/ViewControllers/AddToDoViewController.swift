//
//  AddToDoViewController.swift
//  SimpleToDoApp
//
//  Created by Thong Hoang Nguyen on 2019-05-02.
//  Copyright © 2019 Thong Hoang Nguyen. All rights reserved.
//

import UIKit
import CoreData

protocol AddToDoViewControllerDelegate: class {
    func didFinishAddToDo(_ todo: ToDo)
    func didCancelAddToDo()
    
}

class AddToDoViewController: UIViewController {
    var themeFLAG = false
    weak var delegate: AddToDoViewControllerDelegate?
    
    let titleLabel = UILabel(title: "Task: ", color: .darkGray, fontSize: 20, isBold: true)
    let titleTextField = createTextField(placeholder: "Enter task here", keyboardType: .default)
    lazy var titleStackView = createStackView(subViews: [titleLabel, titleTextField])
    
    let descriptionLabel = UILabel(title: "Description: ", color: .darkGray, fontSize: 20, isBold: true)
    let descriptionTextField = createTextField(placeholder: "Enter description here", keyboardType: .default)
    lazy var descriptionStackView = createStackView(subViews: [descriptionLabel, descriptionTextField])
    
    let priorityLabel = UILabel(title: "Priority: ", color: .darkGray, fontSize: 20, isBold: true)
    let priorityTextField = createTextField(placeholder: "Enter priority here (1 - 5)", keyboardType: .phonePad)
    lazy var priorityStackView = createStackView(subViews: [priorityLabel, priorityTextField])
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleStackView, descriptionStackView, priorityStackView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 30
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationItem.title = "Add task"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didAddToDo))
    }
    
    @objc fileprivate func didAddToDo() {
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let newToDo = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext)
        newToDo.setValue(titleTextField.text, forKey: "title")
        newToDo.setValue(descriptionTextField.text, forKey: "toDoDescription")
        newToDo.setValue(Int(priorityTextField.text!) ?? 1, forKey: "priority")
        CoreDataManager.shared.saveContext()
        
        delegate?.didFinishAddToDo(newToDo as! ToDo)
        navigationController?.popViewController(animated: true)
    }
    fileprivate func setupUI() {
        view.addSubview(stackView)
        if themeFLAG {
            view.backgroundColor = .black
            titleLabel.textColor = .white
            titleTextField.textColor = .white
            descriptionLabel.textColor = .white
            descriptionTextField.textColor = .white
            priorityLabel.textColor = .white
            priorityTextField.textColor = .white
        } else {
            view.backgroundColor = .white
            titleLabel.textColor = .black
            titleTextField.textColor = .black
            descriptionLabel.textColor = .black
            descriptionTextField.textColor = .black
            priorityLabel.textColor = .black
            priorityTextField.textColor = .black
        }
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    static func createTextField(placeholder: String, keyboardType : UIKeyboardType) -> UITextField {
        let tf = UITextField(frame: .zero)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = placeholder
        tf.keyboardType = keyboardType
        return tf
    }
    func createStackView(subViews: [UIView]) -> UIStackView {
        let sv = UIStackView(arrangedSubviews: subViews)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fillEqually
        sv.spacing = 20
        return sv
    }
}
