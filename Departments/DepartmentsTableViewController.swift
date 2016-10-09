//
//  DepartmentsTableViewController.swift
//  Departments
//
//  Created by Norbert Czirjak on 2016. 10. 09..
//  Copyright © 2016. Norbert Czirjak. All rights reserved.
//

import UIKit
import CoreData

class DepartmentsTableViewController: UITableViewController {

    var appDel: AppDelegate =  AppDelegate()
    var context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
   
    // array amiben nsmanagedobject van tarolva, es ures es inicializatuk
    // ebbe mennek majd az adatok
    var departmensData = [NSManagedObject]()
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        //igy ferek hozza a shareinstancehoz
        appDel = UIApplication.shared.delegate as! AppDelegate
        // ez a context mostmar hozzafer a coredatahoz es tudok vele mulveteket vegrehajtnai
        context = appDel.persistentContainer.viewContext
        
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    
    }

    
    override func viewWillAppear(_ animated: Bool) {
        populateDepartmentsData()
    }
    
    func populateDepartmentsData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Departments")
        request.resultType = .managedObjectResultType
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
         request.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try context.fetch(request)
            departmensData = results as! [NSManagedObject]
            
            tableView.reloadData()
            
            
        } catch {
            print("some error over the fetching")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return departmensData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = departmensData[indexPath.row].value(forKey: "name") as! String
        

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let objectToDelete = departmensData[indexPath.row]
            context.delete(objectToDelete)
            //torles az eedit modban
            do {
                try context.save()
                departmensData.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                print("record deleted")
            } catch {
                print("error during the save")
            }
            
            // Delete the row from the data source
            
        }
        
    }
    

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
