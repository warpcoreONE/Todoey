//
//  TodoListTableViewController.swift
//  Todoey
//
//  Created by Kuan-Sheng Hsieh on 2018-09-18.
//  Copyright © 2018 Kuan-Sheng Hsieh. All rights reserved.
//

import UIKit
import CoreData

class TodoListTableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    var category:Category? {
        didSet{
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.plist")
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)

        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }

    // Mark: Tableview delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        guard cell != nil else {
            return
        }
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Mark: Add new items
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        var text = UITextField()
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen when user click the Add Item

            let newItem = Item(context: self.context)
            newItem.title = text.text ?? "New Item"
            newItem.done = false
            newItem.parentCategory = self.category
            self.itemArray.append(newItem)

            self.saveItems()
        }
        
        alert.addAction(action)
        alert.addTextField { (textField) in
            textField.placeholder = "Create new item"
            text = textField
        }
        present(alert, animated: true, completion: nil)
    }
    
    // Mark: Model Manupulation Methods
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", category!.name!)
        if let additionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
            request.predicate = compoundPredicate
        }else {
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
            tableView.reloadData()
        }catch{
            print(error)
        }
    }
}

// Mark: - Search bar methods
extension TodoListTableViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        loadItems(with:request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
