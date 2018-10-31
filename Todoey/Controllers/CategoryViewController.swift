//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Andrew Nyago on 25/10/2018.
//  Copyright © 2018 janus. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var categoryNamesArray = ["Home", "Work", "Misc"]
    //var categoryArray = [Category]()
    //var categoryArray = [RealmCategory]()
    var categoryArray: Results<RealmCategory>?

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //loadHardCategories()
        
        tableView.rowHeight = 80.0
        loadCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:- Table view data source methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //for nscoder and coredata
        //return categoryArray.count
        
        //for realm, we use the nil coalescing operator
        return categoryArray?.count ?? 1
    }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // Configure the cell...
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
//        let category = categoryArray?[indexPath.row]
//        cell.textLabel?.text = category?.name ?? "No Categories Added Yet"
//
//        return cell
//    }
    //Set the delegate property on SwipeTableViewCell:
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
        
        cell.delegate = self
        return cell
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    //MARK:- TableView delegate methods..
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        performSegue(withIdentifier: "goToItems", sender: self)
       
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destinationVC =  segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
    //MARK:- Model Manipulation methods
    //coredata and nscoder declaration
    //func saveCategories()  {

    //realm declaration
    func saveCategories(category: RealmCategory)  {
        //let encoder = PropertyListEncoder()
        do {

            //NSCoder
            //            let data = try encoder.encode(itemArray)
            //            try data.write(to: dataFilePath!)
            
            // coreData
            //try context.save()
            
            //Realm:
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            print("Error Saving context , \(error)")
        }
    }

    //the finction parameter has a default value so when the fnction is called without the parameter, we just use the default value.
    //func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){

//        do {
//            categoryArray = try context.fetch(request)
//        } catch {
//            print("Error fetching CATEGORIES from Context ================ \n\(error)")
//        }
    }
    
    //Realm implementation:
    func loadCategories(){
        categoryArray = realm.objects(RealmCategory.self)
        
        tableView.reloadData()
    }
    //Mark:- SearchBar Delegate methods.
    func loadHardCategories() {
        for categoryName in categoryNamesArray {
            //let newCategory = Category()
            let newCategory = RealmCategory()

            newCategory.name = categoryName
            //categoryArray.append(newCategory)
        }
    }
   
    
    //MARK:- Add new categories using alerts (Dialog Boxes)
    @IBAction func addButtonPressed(_ sender: Any) {
        print("addButtonPressed")
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "MESSAGE", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            
            //let newCategory = Category(context: self.context)
            let newCategory = RealmCategory()
            newCategory.name = textField.text!
            
            //theres no need to append things in Realm. it uses auto updating contsiners/
            //self.categoryArray.append(newCategory)
            
            self.tableView.reloadData()
            //self.saveCategories()
            
            self.saveCategories(category: newCategory)

            //self.defaults.set(self.itemArray , forKey: "TodoListArray")
            //action.style = UIAlertActionStyle.default
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK:- Swipe cell Delegate Methods
extension CategoryViewController: SwipeTableViewCellDelegate {
    //Adopt the SwipeTableViewCellDelegate protocol:
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil } //ensure we are swiping to the right..
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("ITem Deleted")
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
}
