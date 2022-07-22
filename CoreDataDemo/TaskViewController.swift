//
//  TaskViewController.swift
//  CoreDataDemo
//
//  Created by Pavel Naumov on 22.07.2022.
//

import UIKit
import CoreData

class TaskViewController: UIViewController {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private lazy var newTaskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "New Task"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1)
        button.setTitle("Save Task", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 4
        
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Cancel Task", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 4
        
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        return button
    }()
     
    var delegate: TaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews(newTaskTextField, saveButton, cancelButton)
        setConstraints(item: newTaskTextField,
                       toTop: view.topAnchor,
                       topLeft: view.leadingAnchor,
                       toRight: view.trailingAnchor,
                       toTopConst: 80,
                       toLeftConst: 40,
                       toRightConst: 40
        )
        setConstraints(item: saveButton,
                       toTop: newTaskTextField.topAnchor,
                       topLeft: view.leadingAnchor,
                       toRight: view.trailingAnchor,
                       toTopConst: 80,
                       toLeftConst: 40,
                       toRightConst: 40
        )
        setConstraints(item: cancelButton,
                       toTop: newTaskTextField.topAnchor,
                       topLeft: view.leadingAnchor,
                       toRight: view.trailingAnchor,
                       toTopConst: 40,
                       toLeftConst: 40,
                       toRightConst: 40
        )
    }
    
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setConstraints(
        item: UIView,
        toTop: NSLayoutYAxisAnchor,
        topLeft: NSLayoutXAxisAnchor,
        toRight: NSLayoutXAxisAnchor,
        toTopConst: CGFloat,
        toLeftConst: CGFloat,
        toRightConst: CGFloat
    ) {
        item.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            item.topAnchor.constraint(equalTo: toTop, constant: toTopConst),
            item.leadingAnchor.constraint(equalTo: topLeft, constant: toLeftConst),
            item.trailingAnchor.constraint(equalTo: toRight, constant: -toRightConst)
        ])
    }
    
    @objc private func save() {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return }
        task.title = newTaskTextField.text
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
        delegate?.reloadData()
        dismiss(animated: true)
    }
    
    @objc private func cancel() {
        dismiss(animated: true)
    }
}
