//
//  ViewController.swift
//  Todoey
//
//  Created by George Hadjisavvas on 30/12/2018.
//  Copyright © 2018 George Hadjisavvas. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "By eggos","Destroy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK - Tableview datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
        
        
    }

    //returns number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - TableView Delagate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        //checks if has already checkmark it removes it else it inserts a checkmark
        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
             tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
             tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - ADD NEW Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item ", message: "", preferredStyle: .alert)
        
        //Down function will trigger when the add Item will be pressed
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add item button on our UIalert
            
            self.itemArray.append(textField.text!)
            //reloas the page to show the data
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
           
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    } // end of AddButtonPressed
    
    
    
}

