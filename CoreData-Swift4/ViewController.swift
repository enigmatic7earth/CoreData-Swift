//
//  ViewController.swift
//  CoreData-Swift4
//
//  Created by NETBIZ on 20/07/18.
//  Copyright © 2018 Netbiz.in. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var managedObjectContext: NSManagedObjectContext? = nil
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext?
    var tableData: [Any]?
//    var refreshControl = UIRefreshControl()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        context = appDelegate.persistentContainer.viewContext
        loadTableData()
//        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
//        refreshControl.tintColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 1)
        
//        tableView.addSubview(refreshControl)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func refresh(_ : UIRefreshControl){
        loadTableData()
        tableView.reloadData()
//        refreshControl.endRefreshing()
        
    }
    func loadTableData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context?.fetch(request)
            tableData = result
            for data in result as! [NSManagedObject] {
                //print(data.value(forKey: "name") as! String)
                
            }
            
        } catch {
            
            print("Failed")
        }
    }

    
    @IBAction func addEmployee(_ sender: Any) {
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
            
            //code to add
            let entity = NSEntityDescription.entity(forEntityName: "Employee", in: self.context!)
            let newEmp = NSManagedObject(entity: entity!, insertInto: self.context)
            newEmp.setValue(name, forKey: "name")
            newEmp.setValue(designation, forKey: "designation")
            newEmp.setValue(emp_id ,forKey: "employeeID")
            //save
            do {
//                self.refreshControl.beginRefreshing()
                try self.context!.save()
                print("Saved!")
                self.showToastWithMessage(message: "Employee added!")
                self.loadTableData()
                self.tableView.reloadData()
//                self.refreshControl.endRefreshing()
            } catch {
                print("Failed saving")
            }
        }
        let cancel_action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        add_alert.addAction(add_action)
        add_alert.addAction(cancel_action)
        
        present(add_alert, animated: true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showToastWithMessage(message: String) {
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.view.layer.opacity = 0.5
        
        self.present(alert, animated: true, completion: nil)
        
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
        
    }

}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableData!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = ((tableData?[indexPath.row] as AnyObject).value(forKey: "name") as! String)
        cell.detailTextLabel?.text = "\(((tableData?[indexPath.row] as AnyObject).value(forKey: "designation") as! String)) : \(((tableData?[indexPath.row] as AnyObject).value(forKey: "employeeID") as! String))"
        
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {

        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Edit" , handler: { (action:UITableViewRowAction!, indexPath:IndexPath!) -> Void in
            
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
                
                 let name = edit_alert.textFields![0].text! 
                 let designation = edit_alert.textFields![1].text!
                 let emp_id = edit_alert.textFields![2].text!
                let old_name = ((self.tableData?[indexPath.row] as AnyObject).value(forKey: "name") as! String)
                 
                 // code to edit
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
                request.returnsObjectsAsFaults = false
                do {
                    let result = try self.context?.fetch(request)
                    for data in result as! [NSManagedObject] {
                        if (old_name  == data.value(forKey: "name")as! String ){
                            data.setValue(name, forKey: "name")
                            data.setValue(designation, forKey: "designation")
                            data.setValue(emp_id, forKey: "employeeID")

                        }
                        
                    }
//                    self.refreshControl.beginRefreshing()
                    try self.context!.save()
                    print("Saved!")
                    self.showToastWithMessage(message: "Employee info updated!")
                    self.loadTableData()
                    self.tableView.reloadData()
//                    self.refreshControl.endRefreshing()
                    
                } catch {
                    
                    print("Failed")
                }
                
            }
            
            let cancel_action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            edit_alert.addAction(edit_action)
            edit_alert.addAction(cancel_action)
            
            self.present(edit_alert, animated: true)

        })
        editAction.backgroundColor = #colorLiteral(red: 0.1019999981, green: 0.7369999886, blue: 0.6119999886, alpha: 1)
        

        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:IndexPath!) -> Void in
            let name = ((self.tableData?[indexPath.row] as AnyObject).value(forKey: "name") as! String)
            let del_alert = UIAlertController(title: "Delete employee", message: "Are you sure about deleting \(name)?", preferredStyle: .alert)
            
            let ok_action = UIAlertAction(title: "Confirm", style: .destructive, handler: { (ok_action) in
                // code to delete
                
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
                request.returnsObjectsAsFaults = false
                do {
                    let result = try self.context?.fetch(request)
                    for data in result as! [NSManagedObject] {
                        if (name  == data.value(forKey: "name")as! String ){
                            self.context?.delete(data)
                        }
                        
                    }
                    
                    try self.context!.save()
                    print("Saved!")
                    self.showToastWithMessage(message: "Employee deleted!")
                    self.loadTableData()
                    self.tableView.reloadData()
                    
                } catch {
                    
                    print("Failed")
                }
                
            })
            let cancel_action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            del_alert.addAction(ok_action)
            del_alert.addAction(cancel_action)
            
            self.present(del_alert, animated: true, completion: nil)
            

        })
        deleteAction.backgroundColor = #colorLiteral(red: 0.9060000181, green: 0.2980000079, blue: 0.2349999994, alpha: 1)
        
        return [deleteAction, editAction]
    }
    
}
