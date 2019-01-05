//
//  ViewController.swift
//  Todoey
//
//  Created by George Hadjisavvas on 30/12/2018.
//  Copyright © 2018 George Hadjisavvas. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            //WE Call only when we got a category value
            loadItems()
        }
    }
   
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))
    
        //calling loadItems function
      
    }
    
    
    
    //MARK - Tableview datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //creating constant
        if let item = todoItems?[indexPath.row] {
        
        cell.textLabel?.text = item.title
        
        //ternary operator
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done == true ? .checkmark : .none
    
 
        }else {
        cell.textLabel?.text = "No Item Added"
        }
        return cell
    
    }
    //returns number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
   
    
    //MARK - TableView Delagate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do {
            try realm.write {
                item.done = !item.done
                
            }
            }catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
        //checks if has already checkmark it removes it else it inserts a checkmark
        //todoItems[indexPath.row].done = !todoItems[indexPath.row].done
       // saveItems()
        
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
            
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                    }
                } catch {
                    print ("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()

        }
        
      
        alert.addTextField { (alertTextField) in
        alertTextField.placeholder = "Create new item"
        textField = alertTextField
           
        }
          alert.addAction(action)
          self.present(alert,animated: true,completion: nil)
      
    } // end of AddButtonPressed
    
    
    
    //MARK: - Model Manupulation Methods
    
    
    func loadItems() {

    todoItems = selectedCategory?.items.sorted(byKeyPath: "title",ascending: true)
    tableView.reloadData()
    
    }
    
    
}



//MARK: - Search bar methods
//WE Can spit up the functionaluity of our viewcontroller
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    //This function is rensposible to revert our data into original when the search bar = 0 and also hide the keyboard
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()//with default request fetching all items

            //ASSIGN task to different threads
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }

    }
}
