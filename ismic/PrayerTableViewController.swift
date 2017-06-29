//
//  PrayerTableViewController.swift
//  ismic
//
//  Created by Muluken on 6/18/17.
//  Copyright © 2017 GCME-EECMY. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage



class PrayerTableViewController: UITableViewController {
        
        var prayArray = [Pray]()
        
        var dataBaseRef: FIRDatabaseReference! {
            return FIRDatabase.database().reference()
        }
        
        
        var storageRef: FIRStorage {
            
            return FIRStorage.storage()
        }
        override func viewDidLoad() {
            super.viewDidLoad()
          //  let nav = self.navigationController?.navigationBar
//            nav?.barStyle = UIBarStyle.black
//            nav?.tintColor = UIColor.white
//            nav?.backgroundColor = UIColor(red: 38.0/255.0, green: 64.0/255.0, blue: 103.0/255.0, alpha: 1.0)
//            nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orange]
//            
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            fetchPrayer()
        }
        
        func fetchPrayer(){
            
            dataBaseRef.child("prayer").observe(.value, with: { (snapshot) in
                var results = [Pray]()
                
                for user in snapshot.children {
                    
                    let user = Pray(snapshot: user as! FIRDataSnapshot)
                    
                    results.append(user)
                    
                    
                }
                
                self.prayArray = results.sorted(by: { (u1, u2) -> Bool in
                    u1.titlePray < u2.titlePray
                })
                self.tableView.reloadData()
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
        }
        // MARK: - Table view data source
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return prayArray.count
        }
        
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "prayCell", for: indexPath) as! PrayerTableViewCell
            
            // Configure the cell...
            
            cell.prayDetail.text = prayArray[indexPath.row].summaryPray
            cell.prayTitle.text = prayArray[indexPath.row].titlePray
            
            
            return cell
        }
    
        
    
}
