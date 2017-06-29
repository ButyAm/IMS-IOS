//
//  NewsTableViewController.swift
//  ismic
//
//  Created by Muluken on 6/18/17.
//  Copyright © 2017 GCME-EECMY. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage


class NewsTableViewController: UITableViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    var newsArray = [News]()
    
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
//        let nav = self.navigationController?.navigationBar
//        nav?.barStyle = UIBarStyle.black
//        nav?.tintColor = UIColor.white
//        nav?.backgroundColor = UIColor(red: 38.0/255.0, green: 64.0/255.0, blue: 103.0/255.0, alpha: 1.0)
//        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orange]
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchNews()
    }
    
    func fetchNews(){
        
        dataBaseRef.child("global-news").observe(.value, with: { (snapshot) in
            var results = [News]()
            
            for user in snapshot.children {
                
                let user = News(snapshot: user as! FIRDataSnapshot)
                
                results.append(user)
                
                
            }
            
            self.newsArray = results.sorted(by: { (u1, u2) -> Bool in
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
        return newsArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        
        // Configure the cell...
        
        cell.newsDetail.text = newsArray[indexPath.row].summary
        cell.newsTitle.text = newsArray[indexPath.row].title
        
        let imageURL = newsArray[indexPath.row].photoURL!
        
        cell.storageRef.reference(forURL: imageURL).data(withMaxSize: 15 * 1024 * 1024, completion: { (imgData, error) in
            
            if error == nil {
                DispatchQueue.main.async {
                    if let data = imgData {
                        cell.newsImage.image = UIImage(data: data)
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
            
            let VC = segue.destination as! DetailNewsViewController
            if let indexpath = self.tableView.indexPathForSelectedRow {
                
                let Title = newsArray[indexpath.row].title as String
                VC.SentData1 = Title
                print(newsArray)
                
                
                
                let Imageview = newsArray[indexpath.row].photoURL as String
                VC.SentData3 = Imageview
                let detailDesc = newsArray[indexpath.row].detailnews! as String
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
