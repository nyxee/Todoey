//
//  ViewController.swift
//  Todoey
//
//  Created by Andrew Nyago on 07/10/2018.
//  Copyright © 2018 janus. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var itemTittlesArray = ["Find Mike", "Buy Eggs", "Destroy Demogorgon", "As", "people", "fleeing", "from", "various", "regimes,", "their", "ideology", "was", "understandably", "anti-Bachwezi,", "anti-Babito", "and", "anti-Bahima.", "It", "is", "not", "surprising", "that", "traditions", "linking", "Buganda", "to", "any", "of", "the", "three", "groups", "have", "been", "suppressed,", "even", "where", "the", "evidence", "is", "overwhelming.", "For", "instance,", "when", "we", "compare", "the", "Bachwezi", "traditions", "of", "Bunyoro", "and", "Nkore", "with", "the", "traditions", "of", "Buganda,", "which", "rarely", "refer", "to", "the", "Bachwezi,", "we", "find", "several", "similarities", "which", "historians", "cannot", "afford", "to", "ignore.", "In", "Bunyoro", "and", "Nkore", "the", "gatekeeper", "of", "King", "Isaza", "of", "Kitara", "was", "Bukulu", "of", "the", "Balanzi", "clan.", "On", "the", "Sesse", "Islands", "the", "traditions", "of", "the", "otter", "clan", "–", "which", "is", "the", "same", "as", "the", "Balanzi", "clan", "–", "name", "one", "Bukulu.", "In", "Bunyoro", "and", "Nkore,", "the", "daughter", "of", "Bukulu,", "and", "hence", "the", "mother", "of", "King", "Ndahura,", "was", "Nyinamwiru.", "The", "Kiganda", "equivalent", "is", "Namuddu,", "who", "is", "widely", "found", "in", "Sesse", "legends.", "From", "the", "west", "we", "learn", "that", "Bukulu’s", "grandson", "was", "called", "Mugasha,", "and", "in", "Buganda", "tradition", "gives", "the", "name", "of", "Bukulu’s", "grandson", "as", "Mukasa.", "W", "e", "learn", "from", "the", "traditions", "of", "Nkore", "that", "Mugasha", "disappeared", "in", "Lake", "Victoria;", "according", "to", "Bunyoro", "tradition,", "King", "Wamara", "disappeared", "into", "the", "lake", "and", "he", "was", "also", "responsible", "for", "the", "construction", "of", "Lake", "Wamala.", "In", "Buganda,", "Wamala,", "who", "is", "a", "descendant", "of", "Bukulu,", "is", "associated", "with", "the", "making", "of", "the", "same", "lake.", "Moreover,", "just", "as", "the", "Bachwezi", "spirits", "are", "deified", "in", "the", "Kitara", "complex", "area,", "the", "Buganda", "deify", "the", "spirits", "of", "the", "descendants", "of", "Bukulu,", "such", "as", "Nende", "and", "Mukasa.", "Is", "it", "not", "possible,", "therefore,", "that", "the", "descendants", "of", "Bukulu", "in", "Buganda were", "Bachwezi?"]
    
    //var itemArray = [Item]()
    var todoItems: Results<RealmItem>?
    let realm = try! Realm()
    
    var selectedCategory : RealmCategory? {
        didSet {
            loadItems()
        }
    }
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath!)
        

        //searchBar.delegate = self
        //loadHardItems()
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
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
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        print("cellForRowAt indexPath called")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
        
            cell.accessoryType = item.done ? .checkmark : .none //usig the Ternary Operator
        }else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    //MARK: TableView delegate methods..
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row).none
        
        //todoItems?[indexPath.row].done = !todoItems?[indexPath.row].done
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        }else {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        //saveItems()
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    //item.done = !item.done //Update item
                    realm.delete(item)       //delete item
                }
            }catch {
                print("Error saving done status , \(error)")
            }
        }
        
        tableView.reloadData() //force the data source methods again.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add new items using alerts (Dialog Boxes)
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            
            //let newItem = Item(context: self.context)
            
            if let currentCategory = self.selectedCategory {
                let newItem = RealmItem()
                //newItem.parentCategory = self.selectedCategory

                newItem.title = textField.text!
                newItem.done  = false
                //self.todoItems.append(newItem)
                
                //currentCategory.items.append(newItem) :: This method may only be called during a write transaction.
                do {
                    try self.realm.write {
                        currentCategory.items.append(newItem)
                        self.realm.add(newItem)
                    }
                } catch {
                    print("Error Saving To Realm DataBase ===========================================\n\n , \(error)")
                }
                //self.saveItems(new: newItem)
            }
            self.tableView.reloadData()
            //self.saveItems()
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
    
    //MARK:- Model Manipulation methods
    func saveItems()  {
        //let encoder = PropertyListEncoder()
        do {
            
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
            
            try context.save()
        } catch {
            print("Error Saving context , \(error)")
        }
    }
  
    func saveItems(new item: RealmItem)  { //
        //let encoder = PropertyListEncoder()
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Error Saving To Realm DataBase ===========================================\n\n , \(error)")
        }
    }
    //the finction parameter has a default value so when the fnction is called without the parameter, we just use the default value.
    //for NSCOder and CoreData
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
//
////        if let data = try? Data(contentsOf: dataFilePath!){
////            let decoder = PropertyListDecoder()
////            do {
////                itemArray = try decoder.decode([Item].self, from: data)
////            }catch {
////                print("Error Decoding item array, \(error)")
////            }
////        }
//
//       //let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name! )
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from Context ================ \n\(error)")
//        }
//        tableView.reloadData()
//    }
    
    //Realm declaration:
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
   
    //CoreData trial
//    func searchCategoryItems() {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name! )
//        request.predicate = predicate
//
//        //let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        //request.sortDescriptors = [sortDescriptor]
//
//        //loadItems(with: request)
//
//        tableView.reloadData()
//    }
    
    func loadHardItems() {
        for itemTittle in itemTittlesArray {
            let newItem = RealmItem()
            newItem.title = itemTittle
            newItem.done  = false
            //itemArray.append(newItem)
        }
        //itemArray[0].done = true //test
    }
}

//MARK:- SearchBar Methods.
extension TodoListViewController: UISearchBarDelegate {
    //Mark:- SearchBar Delegate methods.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //for CoreData
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text! ) //a case and diecretic insensitive query
//
//
//        request.predicate = predicate
//
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//
//        request.sortDescriptors = [sortDescriptor]
//
//        loadItems(with: request)
//
//        tableView.reloadData()
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

