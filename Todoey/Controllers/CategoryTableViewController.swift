//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by George Hadjisavvas on 04/01/2019.
//  Copyright © 2019 George Hadjisavvas. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    
    
    //MARK: - TableView Datasource methods
    override func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell",for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?){
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    
    
    //MARK: - Data Manipulation Methods
    func saveCategories(){
        do {
        try context.save()
        } catch {
                print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(){
        let request : NSFetchRequest <Category> = Category.fetchRequest()
        do {
       categories = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
            
        }
        tableView.reloadData()
    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title : "Add New Category", message : "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what should happen when user pressed the add button isnide the allert
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            //call the save category method that we made
            self.saveCategories()
            
        }
        
            alert.addAction(action)
            alert.addTextField{ (field) in
                textField = field
                textField.placeholder = "Add a new Category"
            }
            
            self.present(alert,animated: true,completion: nil)
            
        }
        
    }

