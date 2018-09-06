//
//  TableViewController.swift
//  CoreData-Swift4
//
//  Created by NETBIZ on 29/06/18.
//  Copyright © 2018 Netbiz.in. All rights reserved.
//

import UIKit
import CoreData
class TableViewController: UITableViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext?
    var tableData: [Any]?



    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        context = appDelegate.persistentContainer.viewContext
        loadTableData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadTableData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context?.fetch(request)
            tableData = result
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "name") as! String)

            }
            
        } catch {
            
            print("Failed")
        }
    }

    @IBAction func add_employee(_ sender: Any) {
        let add_alert = UIAlertController(title: "Add Employee", message: "Add the following details", preferredStyle: .alert)
        add_alert.addTextField { (nameFld : UITextField!) -> Void in
            nameFld.placeholder = "Name"
        }
        add_alert.addTextField { (desigFld : UITextField!) -> Void in
            desigFld.placeholder = "Designation"
        }
        add_alert.addTextField { (idFld : UITextField!) -> Void in
            idFld.placeholder = "Employee ID"
        }
        
        
        let add_action = UIAlertAction(title: "Add", style: .default) { [unowned add_alert] _ in
            let name = add_alert.textFields![0].text!
            let designation = add_alert.textFields![1].text!
            let emp_id = add_alert.textFields![2].text!
            
            
            print("Name:\(name) \nDesignation:\(designation) \nID:\(emp_id)")
            
            //code to add to database
            let entity = NSEntityDescription.entity(forEntityName: "Employee", in: self.context!)
            let newEmp = NSManagedObject(entity: entity!, insertInto: self.context)
            newEmp.setValue(name, forKey: "name")
            newEmp.setValue(designation, forKey: "designation")
            newEmp.setValue(emp_id ,forKey: "employeeID")
            //save
            do {
                try self.context!.save()
                print("Saved!")
                self.loadTableData()
                self.tableView.reloadData()
            } catch {
                print("Failed saving")
            }
        }
        let cancel_action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        add_alert.addAction(add_action)
        add_alert.addAction(cancel_action)
        
        present(add_alert, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableData!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = ((tableData?[indexPath.row] as AnyObject).value(forKey: "name") as! String)
        cell.detailTextLabel?.text = "\(((tableData?[indexPath.row] as AnyObject).value(forKey: "designation") as! String)) : \(((tableData?[indexPath.row] as AnyObject).value(forKey: "employeeID") as! String))"

        return cell
    }
    


    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    ///This method will be superseded by tableView(_:trailingSwipeActionsConfigurationForRowAt:) and tableView(_:leadingSwipeActionsConfigurationForRowAt:)
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        //An array of UITableViewRowAction objects representing the actions for the row.
        let deleteTitle = NSLocalizedString("Delete", comment: "Delete action")
        let deleteAction = UITableViewRowAction(style: .destructive,
                                                title: deleteTitle) { (action, indexPath) in
//                                                    self.dataSource?.delete(at: indexPath)
        }
        
        let favoriteTitle = NSLocalizedString("Favorite", comment: "Favorite action")
        let favoriteAction = UITableViewRowAction(style: .normal,
                                                  title: favoriteTitle) { (action, indexPath) in
//                                                    self.dataSource?.setFavorite(true, at: indexPath)
        }
        favoriteAction.backgroundColor = .green
        return [favoriteAction, deleteAction]
    }
    
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let favAction = UIContextualAction(style: .normal, title: "Favorite") { (action, view, handler) in
            print("Favorite Tapped")
        }
        favAction.backgroundColor =  #colorLiteral(red: 0.9449999928, green: 0.7689999938, blue: 0.05900000036, alpha: 1)
        let configuration = UISwipeActionsConfiguration(actions: [favAction])
        return configuration
    }
    
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            print("Edit Tapped")
            let edit_alert = UIAlertController(title: "Edit Employee Info", message: "Edit the following details", preferredStyle: .alert)
            edit_alert.addTextField { (nameFld : UITextField!) -> Void in
                nameFld.placeholder = ((self.tableData?[indexPath.row] as AnyObject).value(forKey: "name") as! String)
            }
            edit_alert.addTextField { (desigFld : UITextField!) -> Void in
                desigFld.placeholder = ((self.tableData?[indexPath.row] as AnyObject).value(forKey: "designation") as! String)
            }
            edit_alert.addTextField { (idFld : UITextField!) -> Void in
                idFld.placeholder = ((self.tableData?[indexPath.row] as AnyObject).value(forKey: "employeeID") as! String)
            }
            
            
            let edit_action = UIAlertAction(title: "Save", style: .default) { [unowned edit_alert] _ in
                /*
                let name = add_alert.textFields![0].text as! String
                let designation = add_alert.textFields![1].text as! String
                let emp_id = add_alert.textFields![2].text as! String
                
                
                //print("Name:\(name) \nDesignation:\(designation) \nID:\(emp_id)")
                
                //code to add to database
                let entity = NSEntityDescription.entity(forEntityName: "Employee", in: self.context!)
                let newEmp = NSManagedObject(entity: entity!, insertInto: self.context)
                newEmp.setValue(name, forKey: "name")
                newEmp.setValue(designation, forKey: "designation")
                newEmp.setValue(emp_id ,forKey: "employeeID")
                //save
                do {
                    try self.context!.save()
                    print("Saved!")
                    self.loadTableData()
                    self.tableView.reloadData()
                } catch {
                    print("Failed saving")
                }
                */
            }
 
            edit_alert.addAction(edit_action)
            
            self.present(edit_alert, animated: true)
            
        }
        editAction.backgroundColor = #colorLiteral(red: 0.1019999981, green: 0.7369999886, blue: 0.6119999886, alpha: 1)
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            print("Delete Tapped")
            let name = ((self.tableData?[indexPath.row] as AnyObject).value(forKey: "name") as! String)
            
            let del_alert = UIAlertController(title: "Delete Employee", message: "Are you sure about deleting \(name) ?", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "Confirm", style: .destructive, handler: { (confirm) in
                // code to delete
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            del_alert.addAction(confirm)
            del_alert.addAction(cancel)
            
            self.present(del_alert, animated: true, completion: nil)
            
            
            
            
        }
        deleteAction.backgroundColor = #colorLiteral(red: 0.9060000181, green: 0.2980000079, blue: 0.2349999994, alpha: 1)
        
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        return configuration
    }
 

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
