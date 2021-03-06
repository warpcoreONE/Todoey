//
//  TodoListTableViewController.swift
//  Todoey
//
//  Created by Kuan-Sheng Hsieh on 2018-09-18.
//  Copyright © 2018 Kuan-Sheng Hsieh. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListTableViewController: SwipeTableViewController {
    let realm = try! Realm()
    var items:Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    var category:Category? {
        didSet{
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        title = category?.name
        guard let colorHex = category?.backgroundColor else { fatalError() }
        updateNavBar(withHexCode: colorHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
        
    }
    // MARK: - Nav bar setup
    func updateNavBar(withHexCode colorHexCode:String){
        guard let navBar = navigationController?.navigationBar else {fatalError("Nav bar doesn't exist")}
        guard let tintColor = UIColor(hexString: colorHexCode) else { fatalError("Can Not find category background color!")}
        navBar.barTintColor = tintColor
        navBar.tintColor = ContrastColorOf(tintColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(tintColor, returnFlat: true)]
        searchBar.barTintColor = navBar.barTintColor
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            if let color = UIColor(hexString: category!.backgroundColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        }else
        {
            cell.textLabel?.text = "No Item"
            cell.accessoryType = .none
        }
        return cell
    }

    // Mark: Tableview delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        guard cell != nil else {
            return
        }
        
        if let item = items?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                }
                self.tableView.reloadData()
            }catch{
                print (error)
            }
        }
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Mark: Add new items
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        var text = UITextField()

        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen when user click the Add Item

            if let category = self.category {
                do{
                    guard text.text != nil && text.text!.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
                        return
                    }
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = text.text!
                        newItem.createdDate = Date()
                        category.items.append(newItem)
                        self.tableView.reloadData()
                    }
                    
                }catch{
                    print(error)
                }
            }
        }
        
        alert.addAction(action)
        alert.addTextField { (textField) in
            textField.placeholder = "Create new item"
            text = textField
        }
        present(alert, animated: true, completion: nil)
    }
    
    // Mark: Model Manupulation Methods
    
    func loadItems(){
        items = category?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do{
                try realm.write {
                    realm.delete(item)
                }
            }catch{
                print(error)
            }
        }
        
    }
}

// Mark: - Search bar methods
extension TodoListTableViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        items = items?.filter(predicate).sorted(byKeyPath: "createdDate", ascending: true)
        tableView.reloadData()
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
