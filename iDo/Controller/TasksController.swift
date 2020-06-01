//
//  TasksController.swift
//  iDo
//
//  Created by Beatriz Novais on 29/05/20.
//  Copyright © 2020 Beatriz Novais. All rights reserved.
//

import UIKit

class TasksController: UITableViewController {
    
    var taskStore: TaskStore! {
        didSet {
            // get data
            taskStore.tasks = TasksUtility.fetch()!
            
            // reload tableView
            tableView.reloadData()
        }
    }
    
    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // remove as linhas extras da TB caso não exista cell/ texto
        tableView.tableFooterView = UIView()
     
    }
    
    // MARK: - Add Button Function
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        
        // Associar Alert Controller
        
        let alertController = UIAlertController(title: "Add iDo", message: nil, preferredStyle: .alert)
        
        // Actions for allert Controller
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            
            // grab textField text
            guard let name = alertController.textFields?.first?.text else { return }
            
            // create a task
            let newTask = Task(nameOfTask: name)
            
            // add task
            self.taskStore.add(newTask, at: 0)
            
            // reload data in tableView
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            
           // MARK: - Save Dthe data
            TasksUtility.save(self.taskStore.tasks)
            
        }
        // (*) tem que se inverter o status para false
        addAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Text Field
        alertController.addTextField { textField in
            textField.placeholder = "Your iDo task... "
            textField.addTarget(self, action: #selector(self.handleTextChanged), for: .editingChanged)
            }
        
        // Add actions to alert controller
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        // Present
        present(alertController, animated: true)
    }
    
    @objc private func handleTextChanged(_ sender: UITextField) {
        // Apenas proceder com o "addTask" caso exista texto no Text field do alert
        guard let alertController = presentedViewController as? UIAlertController,
              let addAction = alertController.actions.first,
              let text = sender.text
            else { return }
        
        // Botão "Add" na action está apenas abeled caso exista texto no TextField (*)
        addAction.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
}

    // MARK: - Datasource

extension TasksController {
    
    // HEADERS
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "To Do" : "Done"
    }
    
    // SECTIONS
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return taskStore.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskStore.tasks[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = taskStore.tasks[indexPath.section][indexPath.row].nameOfTask
        return cell
    }

}

    //MARK: - Delegate
    
    extension TasksController {
        
        override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 54
        }
        
        // Right swipe for the table Cell = Delete Action
        
        override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, sourceView, completionHandler) in
                
                // Defenir se a task está no isDone
                guard let isDone = self.taskStore.tasks[indexPath.section][indexPath.row].isDone else { return }
                
                // Remover a task do array correspondente
                self.taskStore.remove(at: indexPath.row, isDone: isDone)
                
                // Reload a table view (Delete rows)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
                // MARK: - Save Dthe data
                TasksUtility.save(self.taskStore.tasks)
                
                // Indicar se a task foi realizada
                completionHandler(true)
            }
            
            deleteAction.image = #imageLiteral(resourceName: "delete")
            deleteAction.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            
            return UISwipeActionsConfiguration(actions: [deleteAction])
            
        }
        
        // Left Swipe of the table Cell = Done Action
        
        override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
            let doneAction = UIContextualAction(style: .normal, title: nil) { (action, sourceView, completionHandler) in
                
                // Toggle task is done
                self.taskStore.tasks[0][indexPath.row].isDone = true
                
                // Remove task from array containing to-do tasks
                let doneTask = self.taskStore.remove(at: indexPath.row)
                
                // Reload Table View
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
                // add task to array that contains isDone tasks
                self.taskStore.add(doneTask, at: 0, isDone: true)
                
                // Reload table view
                tableView.insertRows(at: [IndexPath.init(row: 0, section: 1)], with: .automatic)
                
                // MARK: - Save Dthe data
                TasksUtility.save(self.taskStore.tasks)
                
                // indicate action was performed
                completionHandler(true)
                
            }
            
            doneAction.image = #imageLiteral(resourceName: "done")
            doneAction.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            
            return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [doneAction]) : nil
            
        }
        
    }


