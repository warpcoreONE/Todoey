//
//  TodoListTableViewController.swift
//  Todoey
//
//  Created by Kuan-Sheng Hsieh on 2018-09-18.
//  Copyright © 2018 Kuan-Sheng Hsieh. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {

    var itemArray = ["First item","Second item","Third item"]
    
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

        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }

    // Mark: Tableview delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        let cell = tableView.cellForRow(at: indexPath)
        guard cell != nil else {
            return
        }
        if cell!.accessoryType == .checkmark{
            cell!.accessoryType = .none
        }else {
            cell!.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // Mark: Add new items
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        var text = UITextField()
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen when user click the Add Item
            self.itemArray.append(text.text ?? "New Item")
            self.tableView.reloadData()
            
        }
        
        alert.addAction(action)
        alert.addTextField { (textField) in
            textField.placeholder = "Create new item"
            text = textField
        }
        present(alert, animated: true, completion: nil)
    }
    
}
