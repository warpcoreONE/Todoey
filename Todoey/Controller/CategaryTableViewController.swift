//
//  CategaryTableViewController.swift
//  Todoey
//
//  Created by Kuan-Sheng Hsieh on 2018-09-20.
//  Copyright © 2018 Kuan-Sheng Hsieh. All rights reserved.
//

import UIKit
import CoreData

class CategaryTableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Category]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("category.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categaryCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.category = itemArray[indexPath.row]
        }
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        var text = UITextField()
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen when user click the Add Item
            
            let newItem = Category(context: self.context)
            newItem.name = text.text ?? "New Item"
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
    
    func loadItems(with request:NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            itemArray = try context.fetch(request)
            tableView.reloadData()
        }catch{
            print(error)
        }
    }
}
