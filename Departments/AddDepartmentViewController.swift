//
//  AddDepartmentViewController.swift
//  Departments
//
//  Created by Norbert Czirjak on 2016. 10. 09..
//  Copyright © 2016. Norbert Czirjak. All rights reserved.
//

import UIKit
import CoreData

class AddDepartmentViewController: UIViewController {

    @IBOutlet weak var departmentName: UITextField!
    
    var appDel: AppDelegate =  AppDelegate()
    var context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //igy ferek hozza a shareinstancehoz
        appDel = UIApplication.shared.delegate as! AppDelegate
        // ez a context mostmar hozzafer a coredatahoz es tudok vele mulveteket vegrehajtnai
        context = appDel.persistentContainer.viewContext
        
        
    }
    //betoltesnel ures lesz a department name
    override func viewWillAppear(_ animated: Bool) {
        departmentName.text = ""
    }

    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        if departmentName.text == "" {
            // ha ures a department text akkor egy hibauzenetet dobunk fel
            let alert = UIAlertController(title: "Error", message: "You must provide the department name", preferredStyle: .actionSheet)
            let button = UIAlertAction(title: "ok", style: .default, handler: nil)
            
            alert.addAction(button)
            self.present(alert, animated: true, completion: nil)
        } else {
            
            // check if the text entered already exists in core data, then alert to the user
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Departments")
            request.resultType = .managedObjectResultType
            
            let predicate = NSPredicate(format: "name = %@", departmentName.text!)
            request.predicate = predicate
            
            do {
                let results = try context.fetch(request)
                let records = results as! [NSManagedObject]
                //ha mar van olyan record a db ben akkor hiba uzenet
                if records.count > 0 {
                    print("record exists")
                    return
                }
            } catch {
                print("error !!")
            }
            
            self.view.endEditing(true)
            
            //save department entity -  szoval itt beallitjuk h melyik tablaba akarunk menteni
            // es  a contexet hasznaljuk mint driver a menteshez
            let newDepartment = NSEntityDescription.insertNewObject(forEntityName: "Departments", into: context)
            //itt pedig megadjuk, hogy mit szeretnenk menteni es melyik mezobe
            newDepartment.setValue(departmentName.text, forKey: "name")
            
            do {
                try context.save()
                print("saved")
                // ez visszavissz egy nezetet
                self.navigationController?.popViewController(animated: true)
            }  catch {
                print("error during saving process")
            }
            
            
        }
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    

}
