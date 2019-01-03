//
//  ViewController.swift
//  Todoey
//
//  Created by George Hadjisavvas on 30/12/2018.
//  Copyright © 2018 George Hadjisavvas. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        print (dataFilePath)
        
       
        
        
        //set the item array the array of user defaults
        
        loadItems()
    }
    
    //MARK - Tableview datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //creating constant
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //ternary operator
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done == true ? .checkmark : .none
    
        
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
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
//          The bellow code is replaced by the above in a single line (refactoring)
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }else {
//            itemArray[indexPath.row].done = false
//        }
        //calling data source method again
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - ADD NEW Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item ", message: "", preferredStyle: .alert)
        
        //Down function will trigger when the add Item will be pressed
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add item button on our UIalert
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.saveItems()
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
           
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    } // end of AddButtonPressed
    
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Erro encoding item array,\(error)")
        }
        //reloas the page to show the data
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self , from:data )
            } catch {
                print("Error decoding item array ,\(error)")
            }
        }
    }
    
}

