//
//  ViewController.swift
//  Todoey
//
//  Created by George Hadjisavvas on 30/12/2018.
//  Copyright © 2018 George Hadjisavvas. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            //WE Call only when we got a category value
            loadItems()
        }
    }
   
    //for datacore
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
        )
    
        //calling loadItems function
      
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
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
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
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
    
    
    
    //MARK: - Model Manupulation Methods
    func saveItems(){
        
        do {
            try context.save()
            
        } catch {
            print ("Error saving context \(error)")
        }
        //reloas the page to show the data
        self.tableView.reloadData()
    }
    
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),predicate:NSPredicate? = nil) {
        
        //This is the query for relationships
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@" , selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        //our application should communicate with context FIRST
        do {
           itemArray = try context.fetch(request)
        } catch {
            print ("Error Fetching Data \(error)")
        }
        tableView.reloadData()
    }
    
   
    
}

//MARK: - Search bar methods
//WE Can spit up the functionaluity of our viewcontroller
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //query structure
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending : true)]
        
    
        //run the request and take the results
        loadItems(with: request,predicate:predicate)

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
