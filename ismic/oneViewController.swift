//
//  oneViewController.swift
//  ismic
//
//  Created by Muluken on 6/18/17.
//  Copyright © 2017 GCME-EECMY. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage

class oneViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    @IBOutlet weak var menuBar: UIBarButtonItem!
    //
    //    @IBOutlet weak var detailChurchLogo: UIImageView!
    //    @IBOutlet weak var detailChurchName: UILabel!
    
    let emailField = "eecmyims1@gmail.com"
    let pwdField = "hacktaton"
    
    
    
    // sending images to detail event view
    var sendChurchEventTitle: AnyObject? {
        
        get {
            return UserDefaults.standard.object(forKey: "churchEventName") as AnyObject?
        }
        set {
            UserDefaults.standard.set(newValue!, forKey: "churchEventName")
            UserDefaults.standard.synchronize()
        }
    }
    var sendChurchEventImages: AnyObject? {
        
        get {
            return UserDefaults.standard.object(forKey: "churchEventImage") as AnyObject?
        }
        set {
            UserDefaults.standard.set(newValue!, forKey: "churchEventImage")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    // get data eventnamesfrom event main controller
    
    //get imagesfrom main eventviewcntroller
    
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    var cellIdentifier = "news"
    var cellIdentifier2 = "testimony"
    var numberOfItemsPerRow : Int = 2
    
    
    var usersArray = [User]()
    var testArray = [Testimony]()
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    
    var storageRef: FIRStorage {
        
        return FIRStorage.storage()
    }
    
    
    var refreshControl:UIRefreshControl?
    
    
    // collection items size
    var cellWidth:CGFloat{
        if(collectionView == collectionView)
        {
            return collectionView.frame.size.width/2
            //return cell for collection1
        }
        else
        {
            return collectionView2.frame.size.width/2
            //return cell for collection2
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionview
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView2.dataSource = self
        collectionView2.delegate = self
        
        
        FIRAuth.auth()?.signIn(withEmail: emailField, password: pwdField, completion: { (user, error) in
            if error == nil {
                print("Buty: Email user authenticated with Firebase")
                
            } else {
                print("Buty: Unable to authenticate with Firebase using email")
                
                
            }
        })
        
        sideMenus()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchUsers()
        fetchTestimony()
    }
    
    func sideMenus() {
        
        if revealViewController() != nil {
            
            menuBar.target = revealViewController()
            menuBar.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            
            
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        
    }
    
    func fetchUsers(){
        
        dataBaseRef.child("global-news").observe(.value, with: { (snapshot) in
            var results = [User]()
            
            for user in snapshot.children {
                
                let user = User(snapshot: user as! FIRDataSnapshot)
                
                results.append(user)
                
                
            }
            
            self.usersArray = results.sorted(by: { (u1, u2) -> Bool in
                u1.newsTitle < u2.newsTitle
            })
            self.collectionView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    func fetchTestimony(){
        
        dataBaseRef.child("testimony").observe(.value, with: { (snapshot) in
            var result = [Testimony]()
            
            for user in snapshot.children {
                
                let user = Testimony(snapshot: user as! FIRDataSnapshot)
                
                result.append(user)
                
                
            }
            
            self.testArray = result.sorted(by: { (u1, u2) -> Bool in
                u1.testTitle < u2.testTitle
            })
            self.collectionView2.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    
    // MARK: <UICollectionViewDataSource>
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! NewsCollectionViewCell
            // Configure the cell...
            
            cell.title.text = usersArray[indexPath.row].newsTitle
            //        cell.titlenews.text = usersArray[indexPath.row].title
            //        cell.pubdatenews.text = usersArray[indexPath.row].pubdate!
            //
            let imageURL = usersArray[indexPath.row].photoURL!
            
            cell.storageRef.reference(forURL: imageURL).data(withMaxSize: 15 * 1024 * 1024, completion: { (imgData, error) in
                
                if error == nil {
                    DispatchQueue.main.async {
                        if let data = imgData {
                            cell.image.image = UIImage(data: data)
                        }
                    }
                    
                }else {
                    print(error!.localizedDescription)
                    
                }
                
                
            })
            
            return cell
            
        } else { // do not do this check: if collectionView == self.hourCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier2, for: indexPath) as! TestimonyCollectionViewCell
            // Configure the cell...
            
            cell.titleTest.text = testArray[indexPath.row].testTitle
            //        cell.titlenews.text = usersArray[indexPath.row].title
            //        cell.pubdatenews.text = usersArray[indexPath.row].pubdate!
            //
            //            let imageURL = testArray[indexPath.row].imageURL!
            //
            //            cell.storageRef.reference(forURL: imageURL).data(withMaxSize: 15 * 1024 * 1024, completion: { (imgData, error) in
            //
            //                if error == nil {
            //                    DispatchQueue.main.async {
            //                        if let data = imgData {
            //                            cell.imageTest.image = UIImage(data: data)
            //                        }
            //                    }
            //
            //                }else {
            //                    print(error!.localizedDescription)
            //
            //                }
            //
            //
            //            })
            //
            return cell
            
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == collectionView)
        {
            return usersArray.count
            //return cell for collection1
        }
        else
        {
            return testArray.count
            //return cell for collection2
        }
        
    }
    
    
    
    // MARK: <UICollectionViewDelegateFlowLayout>
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(collectionView == collectionView)
        {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
            return CGSize(width: size, height: size)
            //return cell for collection1
        }
        else
        {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
            let size = Int((collectionView2.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
            return CGSize(width: size, height: size)
            //return cell for collection2
        }
        
        
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    //
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        
    //        sendChurchEventTitle = churchEventNames? [indexPath.row] as AnyObject?
    //        sendChurchEventImages = churchEventImages? [indexPath.row] as AnyObject?
    //        
    //        
    //    }
    
    
}


