//
//  ViewController.swift
//  Todoey
//
//  Created by Andrew Nyago on 07/10/2018.
//  Copyright © 2018 janus. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemTittlesArray = ["Find Mike", "Buy Eggs", "Destroy Demogorgon", "As", "people", "fleeing", "from", "various", "regimes,", "their", "ideology", "was", "understandably", "anti-Bachwezi,", "anti-Babito", "and", "anti-Bahima.", "It", "is", "not", "surprising", "that", "traditions", "linking", "Buganda", "to", "any", "of", "the", "three", "groups", "have", "been", "suppressed,", "even", "where", "the", "evidence", "is", "overwhelming.", "For", "instance,", "when", "we", "compare", "the", "Bachwezi", "traditions", "of", "Bunyoro", "and", "Nkore", "with", "the", "traditions", "of", "Buganda,", "which", "rarely", "refer", "to", "the", "Bachwezi,", "we", "find", "several", "similarities", "which", "historians", "cannot", "afford", "to", "ignore.", "In", "Bunyoro", "and", "Nkore", "the", "gatekeeper", "of", "King", "Isaza", "of", "Kitara", "was", "Bukulu", "of", "the", "Balanzi", "clan.", "On", "the", "Sesse", "Islands", "the", "traditions", "of", "the", "otter", "clan", "–", "which", "is", "the", "same", "as", "the", "Balanzi", "clan", "–", "name", "one", "Bukulu.", "In", "Bunyoro", "and", "Nkore,", "the", "daughter", "of", "Bukulu,", "and", "hence", "the", "mother", "of", "King", "Ndahura,", "was", "Nyinamwiru.", "The", "Kiganda", "equivalent", "is", "Namuddu,", "who", "is", "widely", "found", "in", "Sesse", "legends.", "From", "the", "west", "we", "learn", "that", "Bukulu’s", "grandson", "was", "called", "Mugasha,", "and", "in", "Buganda", "tradition", "gives", "the", "name", "of", "Bukulu’s", "grandson", "as", "Mukasa.", "W", "e", "learn", "from", "the", "traditions", "of", "Nkore", "that", "Mugasha", "disappeared", "in", "Lake", "Victoria;", "according", "to", "Bunyoro", "tradition,", "King", "Wamara", "disappeared", "into", "the", "lake", "and", "he", "was", "also", "responsible", "for", "the", "construction", "of", "Lake", "Wamala.", "In", "Buganda,", "Wamala,", "who", "is", "a", "descendant", "of", "Bukulu,", "is", "associated", "with", "the", "making", "of", "the", "same", "lake.", "Moreover,", "just", "as", "the", "Bachwezi", "spirits", "are", "deified", "in", "the", "Kitara", "complex", "area,", "the", "Buganda", "deify", "the", "spirits", "of", "the", "descendants", "of", "Bukulu,", "such", "as", "Nende", "and", "Mukasa.", "Is", "it", "not", "possible,", "therefore,", "that", "the", "descendants", "of", "Bukulu", "in", "Buganda were", "Bachwezi?"]
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath!)
        

        //loadHardItems()
        loadItems()
        // Do any additional setup after loading the view, typically from a nib.
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        print("cellForRowAt indexPath called")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
       
        cell.accessoryType = item.done ? .checkmark : .none //usig the Ternary Operator
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    //MARK: TableView delegate methods..
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        tableView.reloadData() //force the data source methods again.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add new items using alerts (Fialog Boxes)
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            self.tableView.reloadData()
            self.saveItems()
            
            //self.defaults.set(self.itemArray , forKey: "TodoListArray")
            //action.style = UIAlertActionStyle.default
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems()  {
        let encoder = PropertyListEncoder()
        do {
            
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error Encoding item array, \(error)")
        }
    }
    
    func loadItems(){
        
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }catch {
                print("Error Decoding item array, \(error)")
            }
        }
    }
    
    func loadHardItems() {
        for itemTittle in itemTittlesArray {
            let newItem = Item()
            newItem.title = itemTittle
            itemArray.append(newItem)
        }
        itemArray[0].done = true //test
    }
}

