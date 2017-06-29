//
//  NewsTableViewController.swift
//  globalstart
//
//  Created by Muluken on 2/17/17.
//  Copyright © 2017 globalstart. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage


class UsersTableViewController: UITableViewController {
    
    var usersArray = [User]()
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
   
    
    var storageRef: FIRStorage {
        
        return FIRStorage.storage()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.backgroundColor = UIColor(red: 38.0/255.0, green: 64.0/255.0, blue: 103.0/255.0, alpha: 1.0)
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orange]
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchUsers()
    }
    
    func fetchUsers(){
        
        dataBaseRef.child("News").observe(.value, with: { (snapshot) in
            var results = [User]()
            
            for user in snapshot.children {
                
                let user = User(snapshot: user as! FIRDataSnapshot)
                
                                    results.append(user)
                
                
            }
            
            self.usersArray = results.sorted(by: { (u1, u2) -> Bool in
                u1.title < u2.title
            })
            self.tableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usersArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersCell", for: indexPath) as! UsersTableViewCell
        
        // Configure the cell...
        
        cell.summarynews.text = usersArray[indexPath.row].summary
        cell.titlenews.text = usersArray[indexPath.row].title
        cell.pubdatenews.text = usersArray[indexPath.row].pubdate!
        
        let imageURL = usersArray[indexPath.row].photoURL!
        
        cell.storageRef.reference(forURL: imageURL).data(withMaxSize: 1 * 1024 * 1024, completion: { (imgData, error) in
            
            if error == nil {
                DispatchQueue.main.async {
                    if let data = imgData {
                        cell.newsimage.image = UIImage(data: data)
                    }
                }
                
            }else {
                print(error!.localizedDescription)
                
            }
            
            
        })
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "newsdetail") {
            
            let VC = segue.destination as! NewsDetailViewController
            if let indexpath = self.tableView.indexPathForSelectedRow {
                
                let Title = usersArray[indexpath.row].title as String
                VC.SentData1 = Title
                print(usersArray)
                
                let pubdate = usersArray[indexpath.row].pubdate! as String
                VC.SentData2 = pubdate
                
                let Imageview = usersArray[indexpath.row].photoURL as String
                VC.SentData3 = Imageview
                let detailDesc = usersArray[indexpath.row].detailnews! as String
                VC.SentData4 = detailDesc
//                let Imageview2 = imageGoalBot[indexpath.row] as String
//                VC.SentData5 = Imageview2
                
            }
            
            
        }
    }

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
