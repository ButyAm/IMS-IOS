//
//  TestiTableViewController.swift
//  ismic
//
//  Created by Muluken on 6/18/17.
//  Copyright © 2017 GCME-EECMY. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage


class TestiTableViewController: UITableViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var testiArray = [Testi]()
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    
    var storageRef: FIRStorage {
        
        return FIRStorage.storage()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil {
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            
            
            
            //            alertButton.target = revealViewController()
            //            alertButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        print(testiArray)
//        
//        let nav = self.navigationController?.navigationBar
//        nav?.barStyle = UIBarStyle.black
//        nav?.tintColor = UIColor.white
//        nav?.backgroundColor = UIColor(red: 38.0/255.0, green: 64.0/255.0, blue: 103.0/255.0, alpha: 1.0)
//        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orange]
//        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        dataBaseRef.child("testimony").observe(.value, with: { (snapshot) in
            var fetchedTestimonies = [Testi]()
            
            for user in snapshot.children {
                
                let user = Testi(snapshot: user as! FIRDataSnapshot)
                
                fetchedTestimonies.append(user)
                
                
            }
            
            self.testiArray = fetchedTestimonies.sorted(by: { (u1, u2) -> Bool in
                u1.testimonyTitle < u2.testimonyTitle
            })
            self.tableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        

       
    }
    
   
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return testiArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "testiCell", for: indexPath) as! TestiTableViewCell
        
        // Configure the cell...
       
        cell.testiTitle.text = testiArray[indexPath.row].testimonyTitle
        cell.testiDetail.text = testiArray[indexPath.row].testimonyDetail
       
        
        let testimonyImageUrl = testiArray[indexPath.row].testimonyImages!
        
        cell.storageRef.reference(forURL: testimonyImageUrl).data(withMaxSize: 15 * 1024 * 1024, completion: { (imgData, error) in
            
            if error == nil {
                DispatchQueue.main.async {
                    if let data = imgData {
                        cell.imageTesti.image = UIImage(data: data)
                    }
                }
                
            }else {
                print(error!.localizedDescription)
                
            }
            
            
        })
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "detailTesti") {
            
            let VC = segue.destination as! TestiDetailViewController
            if let indexpath = self.tableView.indexPathForSelectedRow {
                
                let Title = testiArray[indexpath.row].testimonyTitle as String
                VC.SentData1 = Title
                print(testiArray)
                
               
                
                let Imageview = testiArray[indexpath.row].testimonyImages as String
                VC.SentData3 = Imageview
                let detailDesc = testiArray[indexpath.row].testimonyDetail! as String
                VC.SentData4 = detailDesc
                //                let Imageview2 = imageGoalBot[indexpath.row] as String
                //                VC.SentData5 = Imageview2
                
            }
            
            
        }
    }
    
 
}
