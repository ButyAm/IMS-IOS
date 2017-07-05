//
//  DevotionTableViewController.swift
//  ismic
//
//  Created by Muluken on 6/18/17.
//  Copyright © 2017 GCME-EECMY. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage

class DevotionTableViewController: UITableViewController {


    
    var devotionalArray = [Devotion]()
    
    var dataBaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    
    var storageRef: Storage {
        
        return Storage.storage()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let nav = self.navigationController?.navigationBar
        //        nav?.barStyle = UIBarStyle.black
        //        nav?.tintColor = UIColor.white
        //        nav?.backgroundColor = UIColor(red: 38.0/255.0, green: 64.0/255.0, blue: 103.0/255.0, alpha: 1.0)
        //        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orange]

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        dataBaseRef.child("devo").observe(.value, with: { (snapshot) in
            var fetchedDevotionals = [Devotion]()
            
            for user in snapshot.children {
                
                let user = Devotion(snapshot: user as! DataSnapshot)
                
                fetchedDevotionals.append(user)
                
                
            }
            
            self.devotionalArray = fetchedDevotionals.sorted(by: { (u1, u2) -> Bool in
                u1.devoTitle < u2.devoTitle
            })
            self.tableView.reloadData()
            print(fetchedDevotionals)
            
        }) { (error) in
            print(error.localizedDescription)
        }

    }
    
   
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return devotionalArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "devoCell", for: indexPath) as! DevotionalTableViewCell
        
        // Configure the cell...
        
        cell.devoDetail.text = devotionalArray[indexPath.row].devoSummary
        cell.devoTItle.text = devotionalArray[indexPath.row].devoTitle
        
                let imageURL = devotionalArray[indexPath.row].devoPhotoURL!
        
                cell.storageRef.reference(forURL: imageURL).getData(maxSize: 15 * 1024 * 1024, completion: { (imgData, error) in
        
                    if error == nil {
                        DispatchQueue.main.async {
                            if let data = imgData {
                                cell.devoImage.image = UIImage(data: data)
                            }
                        }
        
                    }else {
                        print(error!.localizedDescription)
        
                    }
        
        
                })
        
        return cell
    }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
            if (segue.identifier == "devotionaldetail") {
    
                let VC = segue.destination as! DetailDevotionalViewController
                if let indexpath = self.tableView.indexPathForSelectedRow {
    
                    let Title = devotionalArray[indexpath.row].devoTitle as String
                    VC.SentData1 = Title
                    print(devotionalArray)
    
                 
    
                    let Imageview = devotionalArray[indexpath.row].devoPhotoURL as String
                    VC.SentData3 = Imageview
                    let detailDesc = devotionalArray[indexpath.row].devoSummary! as String
                    VC.SentData4 = detailDesc
                    //                let Imageview2 = imageGoalBot[indexpath.row] as String
                    //                VC.SentData5 = Imageview2
                    
                }
                
                
            }
        }
        
    //    @IBAction func back(_ sender: Any) {
    //        self.dismiss(animated: true, completion: nil)
    //    }
    //    
    
}
