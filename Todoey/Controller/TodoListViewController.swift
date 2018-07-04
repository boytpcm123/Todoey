//
//  ViewController.swift
//  Todoey
//
//  Created by hungdat1234 on 7/2/18.
//  Copyright © 2018 ninjaKID. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        loadItem()
    }
    
    //Mark - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    
    //Mark - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.saveItem()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //MARK - Add New Items
   
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user clicks the Add Item button on UIAlert
            if let item = textField.text {
                if item.count > 0{
                    let newItem = Item()
                    newItem.title = item
                    self.itemArray.append(newItem)
                    
                    self.saveItem()
                }
                
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // Mark - Model Manupulation Methods
    
    func saveItem() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        
        self.tableView.reloadData()
    }
    
    
    func loadItem() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                 itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
           
        }
        
    }
    
    

}

