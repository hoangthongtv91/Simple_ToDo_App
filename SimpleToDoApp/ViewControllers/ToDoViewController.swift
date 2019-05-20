//
//  ViewController.swift
//  SimpleToDoApp
//
//  Created by Thong Hoang Nguyen on 2019-04-30.
//  Copyright © 2019 Thong Hoang Nguyen. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: - Properties
    let delegate = UIApplication.shared.delegate as! AppDelegate
    lazy var taskArray = delegate.taskArray
    var themeFLAG = false
    
    var taskSection1: [ToDo] = []
    var taskSection2: [ToDo] = []
    //MARK: - Constants
    let cellID = "ToDoCell"
    @IBOutlet var segmentedController: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    lazy var themeSwitchButton = UIBarButtonItem(image: UIImage(named: "night"), style: .plain, target: self, action: #selector(darkModeSwitched))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // right bar button item
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToDo))
        // left bar button item
        navigationItem.leftBarButtonItems = [editButtonItem, themeSwitchButton]
        // navigation bar title
        navigationItem.title = "All Tasks"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.allowsMultipleSelectionDuringEditing = true
        
        segmentedController.setTitle("Priority", forSegmentAt: 0)
        segmentedController.setTitle("Done", forSegmentAt: 1)
        segmentedController.addTarget(self, action: #selector(segmentAction), for: UIControl.Event.valueChanged)
        fetchToDo()
        let defaults = UserDefaults.standard
        if defaults.value(forKey: "darkThemeIsOn") != nil{
            themeFLAG = !defaults.bool(forKey: "darkThemeIsOn")
            darkModeSwitched()
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        if editing {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteToDo))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToDo))
        }
    }
    @objc func addToDo() {
        //go to AddToDoViewController
        let addToDoVC = AddToDoViewController()
        navigationController?.pushViewController(addToDoVC, animated: true)
        addToDoVC.themeFLAG = self.themeFLAG
        addToDoVC.delegate = self
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return taskSection1.count
        } else {
            return taskSection2.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ToDoCell
        if indexPath.section == 0 {
            setTextForCell(cell, taskSection1, indexPath, isStrikethrough: taskSection1[indexPath.row].isCompleted)
        } else {
            setTextForCell(cell, taskSection2, indexPath, isStrikethrough: taskSection2[indexPath.row].isCompleted)
        }
        if themeFLAG {
            cell.backgroundColor = .black
            cell.titleLabel.textColor = .white
            cell.descriptionLabel.textColor = .white
            cell.priorityLabel.textColor = .red
        } else {
            cell.backgroundColor = .white
            cell.titleLabel.textColor = .darkGray
            cell.descriptionLabel.textColor = .black
            cell.priorityLabel.textColor = .red
        }
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if segmentedController.selectedSegmentIndex == 0 {
            if section == 0 {
                return "High priority"
            } else {
                return "Low priority"
            }
        } else {
            if section == 0 {
                return "Completed"
            } else {
                return "Incompleted"
            }
        }
    }
    @objc func deleteToDo(){
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        if let selectedRow = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRow.reversed() {
                if indexPath.section == 0 {
                    managedContext.delete(taskSection1[indexPath.row])
                    taskArray.removeAll{ ($0 as ToDo).title == taskSection1[indexPath.row].title}
                    taskSection1.remove(at: indexPath.row)
                } else {
                    managedContext.delete(taskSection2[indexPath.row])
                    taskArray.removeAll{ ($0 as ToDo).title == taskSection2[indexPath.row].title}
                    taskSection2.remove(at: indexPath.row)
                }
            }
            tableView.deleteRows(at: selectedRow, with: .fade)
        }
        CoreDataManager.shared.saveContext()
        arrangeList(&taskArray)

    }
    
    fileprivate func arrangeList(_ taskArray: inout [ToDo]) {
        if taskArray.count > 1 {
            for i in 0..<taskArray.count - 1 {
                for j in (i+1)..<taskArray.count {
                    if taskArray[i].priority > taskArray[j].priority {
                        taskArray.swapAt(i, j)
                    }
                }
            }
        }
    }
    fileprivate func setTextForCell(_ cell: ToDoCell,_ taskArray: [ToDo],_ indexPath: IndexPath, isStrikethrough: Bool) {
        cell.titleLabel.attributedText = NSMutableAttributedString(title: taskArray[indexPath.row].title!, isStrikeThrough: taskArray[indexPath.row].isCompleted)
        cell.descriptionLabel.attributedText = NSMutableAttributedString(title: taskArray[indexPath.row].toDoDescription!, isStrikeThrough: taskArray[indexPath.row].isCompleted)
        cell.priorityLabel.attributedText = NSMutableAttributedString(title: String(taskArray[indexPath.row].priority), isStrikeThrough: taskArray[indexPath.row].isCompleted)
        
    }
    @objc func segmentAction() {
        let index = segmentedController.selectedSegmentIndex
        setUpTaskSections(index)
        tableView.reloadData()
    }
    @objc func darkModeSwitched() {
        themeFLAG = !themeFLAG
        if themeFLAG {
            navigationController?.navigationBar.barStyle = .black
            UILabel.appearance().textColor = .white
            tableView.backgroundColor = .black
            tableView.separatorColor = .darkGray
        } else {
            navigationController?.navigationBar.barStyle = .default
            UILabel.appearance().textColor = .black
            tableView.backgroundColor = .white
        }
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        UserDefaults.standard.set(themeFLAG, forKey: "darkThemeIsOn")
    }
    fileprivate func setUpTaskSections(_ segment: Int) {
        taskSection1.removeAll()
        taskSection2.removeAll()
        if segment == 0 {
            for task in taskArray {
                if task.priority < 3 {
                    taskSection1.append(task)
                } else {
                    taskSection2.append(task)
                }
            }
        } else {
            for task in taskArray {
                if task.isCompleted {
                    taskSection1.append(task)
                } else {
                    taskSection2.append(task)
                }
            }
        }
    }
}

//MARK: - AddToDoViewControllerDelegate
extension ToDoViewController: AddToDoViewControllerDelegate {
    func didFinishAddToDo(_ todo: ToDo) {
        taskArray.append(todo)
        arrangeList(&taskArray)
        setUpTaskSections(segmentedController.selectedSegmentIndex)
        tableView.reloadData()
    }
    func didCancelAddToDo() {
        
    }
}

//MARK: - UITableViewDelegate
extension ToDoViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            let detailVC = DetailViewController()
            detailVC.themeFLAG = self.themeFLAG
            if indexPath.section == 0 {
                detailVC.toDo = taskSection1[indexPath.row]
            } else {
                detailVC.toDo = taskSection2[indexPath.row]
            }
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let task: ToDo!
        if sourceIndexPath.section == 0 {
            task = taskSection1.remove(at: sourceIndexPath.row)
        } else {
            task = taskSection2.remove(at: sourceIndexPath.row)
        }
        if destinationIndexPath.section == 0 {
            taskSection1.insert(task, at: destinationIndexPath.row)
        } else {
            taskSection2.insert(task, at: destinationIndexPath.row)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let _ = CoreDataManager.shared.persistentContainer.viewContext
        let completeAction = UIContextualAction(style: .normal, title: "Done", handler: {(ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let cell = tableView.cellForRow(at: indexPath) as! ToDoCell
            for index in 0..<self.taskArray.count {
                if self.taskArray[index].title == cell.titleLabel.text {
                    self.taskArray[index].isCompleted = true
                }
            }
            self.setUpTaskSections(self.segmentedController.selectedSegmentIndex)
            CoreDataManager.shared.saveContext()
            tableView.reloadData()
            success(true)
        })
        return UISwipeActionsConfiguration(actions: [completeAction])
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        var toDo = ToDo()
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: {(ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            if indexPath.section == 0 {
                self.taskArray.removeAll{ ($0 as ToDo).title == self.taskSection1[indexPath.row].title}
                toDo = self.taskSection1[indexPath.row]
                self.taskSection1.remove(at: indexPath.row)
            } else {
                self.taskArray.removeAll{ ($0 as ToDo).title == self.taskSection2[indexPath.row].title}
                toDo = self.taskSection2[indexPath.row]
                self.taskSection2.remove(at: indexPath.row)
            }
            managedContext.delete(toDo)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.arrangeList(&self.taskArray)
            CoreDataManager.shared.saveContext()
            success(true)
        })
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    //MARK: - CoreData Mananger functions
    func fetchToDo() {
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<ToDo>(entityName: "ToDo")
        do {
            let toDo = try managedContext.fetch(fetchRequest)
            self.taskArray = toDo
            arrangeList(&taskArray)
            setUpTaskSections(segmentedController.selectedSegmentIndex)
            tableView.reloadData()
        } catch let error{
            fatalError("Failed to fetch data \(error)")
        }
    }
}


