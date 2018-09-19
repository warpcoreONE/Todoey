//
//  TodoListTableViewController.swift
//  Todoey
//
//  Created by Kuan-Sheng Hsieh on 2018-09-18.
//  Copyright © 2018 Kuan-Sheng Hsieh. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()

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
            let item = Item()
            item.title = text.text ?? "New Item"
            self.itemArray.append(item)

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
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print(error)
            }
        }
    }
}
