//
//  HomeViewController.swift
//  ismic
//
//  Created by Muluken on 6/17/17.
//  Copyright © 2017 GCME-EECMY. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage

class HomeViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    @IBOutlet weak var menuBar: UIBarButtonItem!
//    
//    @IBOutlet weak var detailChurchLogo: UIImageView!
//    @IBOutlet weak var detailChurchName: UILabel!
    
    let emailField = "eecmyims1@gmail.com"
    let pwdField = "hacktaton"

    
    //sending contents of News to detail news view
    // sending title to detail event view
    var sendNewsTitle: AnyObject? {
        
        get {
            return UserDefaults.standard.object(forKey: "newsTitle") as AnyObject?
        }
        set {
            UserDefaults.standard.set(newValue!, forKey: "newsTitle")
            UserDefaults.standard.synchronize()
        }
    }
    var sendNewsDetail: AnyObject? {
        
        get {
            return UserDefaults.standard.object(forKey: "newsDetail") as AnyObject?
        }
        set {
            UserDefaults.standard.set(newValue!, forKey: "newsDetail")
            UserDefaults.standard.synchronize()
        }
    }
    var sendNewsImage: AnyObject? {
        
        get {
            return UserDefaults.standard.object(forKey: "newsImage") as AnyObject?
        }
        set {
            UserDefaults.standard.set(newValue!, forKey: "newsImage")
            UserDefaults.standard.synchronize()
        }
    }

    //sending contents of News to detail news view
    // sending title to detail event view
    var sendTestimonyTitle: AnyObject? {
        
        get {
            return UserDefaults.standard.object(forKey: "testimonyTitle") as AnyObject?
        }
        set {
            UserDefaults.standard.set(newValue!, forKey: "testimonyTitle")
            UserDefaults.standard.synchronize()
        }
    }
    var sendTestimonyDetail: AnyObject? {
        
        get {
            return UserDefaults.standard.object(forKey: "testimonyDetail") as AnyObject?
        }
        set {
            UserDefaults.standard.set(newValue!, forKey: "testimonyDetail")
            UserDefaults.standard.synchronize()
        }
    }
    var sendTestimonyImage: AnyObject? {
        
        get {
            return UserDefaults.standard.object(forKey: "testimonyImage") as AnyObject?
        }
        set {
            UserDefaults.standard.set(newValue!, forKey: "testimonyImage")
            UserDefaults.standard.synchronize()
        }
    }

    
    
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var collectionView1: UICollectionView!
    var cellIdentifier = "news"
    var cellIdentifier2 = "testimony"
    var numberOfItemsPerRow : Int = 2
    
    
    var usersArray = [User]()
    var testArray = [Testimony]()
    
    var dataBaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    
    var storageRef: Storage {
        
        return Storage.storage()
    }
    
    
    var refreshControl:UIRefreshControl?
    
   
//    // collection items size
//    var cellWidth:CGFloat{
//        if(collectionView == collectionView1)
//        {
//            return collectionView1.frame.size.width/2
//            //return cell for collection1
//        }
//        else
//        {
//           return collectionView2.frame.size.width/2
//            //return cell for collection2
//        }
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if revealViewController() != nil {
            
            menuBar.target = revealViewController()
            menuBar.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            
            
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        

        
        
        //collectionview
        collectionView1.dataSource = self
        collectionView1.delegate = self
        collectionView2.dataSource = self
        collectionView2.delegate = self

        
        Auth.auth().signIn(withEmail: emailField, password: pwdField, completion: { (user, error) in
            if error == nil {
                print("Buty: Email user authenticated with Firebase")
                
            } else {
                print("Buty: Unable to authenticate with Firebase using email")
                
                
            }
        })

        
        
           }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchNews()
        fetchTestimony()
    }
    
  

    func fetchNews(){
        
        dataBaseRef.child("global-news").observe(.value, with: { (snapshot) in
            var results = [User]()
            
            for user in snapshot.children {
                
                let user = User(snapshot: user as! DataSnapshot)
                
                results.append(user)
                
                
            }
            
            self.usersArray = results.sorted(by: { (u1, u2) -> Bool in
                u1.newsTitle < u2.newsTitle
            })
            self.collectionView1.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    func fetchTestimony(){
        
        dataBaseRef.child("testimony").observe(.value, with: { (snapshot) in
            var fetchedTestimonies = [Testimony]()
            
            for user in snapshot.children {
                
                let user = Testimony(snapshot: user as! DataSnapshot)
                
                fetchedTestimonies.append(user)
                
                
            }
            
            self.testArray = fetchedTestimonies.sorted(by: { (u1, u2) -> Bool in
                u1.testTitle < u2.testTitle
            })
            self.collectionView2.reloadData()
            print(fetchedTestimonies)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }


    
    // MARK: <UICollectionViewDataSource>
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        if(collectionView == collectionView1)
        {
            return 1
            //return cell for collection1
        }
        else
        {
            return 1

            //return cell for collection2
        }
        
           }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
     if collectionView == self.collectionView1 {
        
        let cell = collectionView1.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! NewsCollectionViewCell
        // Configure the cell...
        
        cell.title.text = usersArray[indexPath.row].newsTitle
        //        cell.titlenews.text = usersArray[indexPath.row].title
        //        cell.pubdatenews.text = usersArray[indexPath.row].pubdate!
        //
        let imageURL = usersArray[indexPath.row].photoURL!
        
        cell.storageRef.reference(forURL: imageURL).getData(maxSize: 15 * 1024 * 1024, completion: { (imgData, error) in
            
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

        }
        else {
            let cell2 = collectionView2.dequeueReusableCell(withReuseIdentifier: cellIdentifier2, for: indexPath) as! TestimonyCollectionViewCell
            // Configure the cell...
            
            cell2.titleTest.text = testArray[indexPath.row].testTitle
            //        cell.titlenews.text = usersArray[indexPath.row].title
            //        cell.pubdatenews.text = usersArray[indexPath.row].pubdate!
            //
            let testImage = testArray[indexPath.row].imageURLTest!
            
            cell2.storageRef.reference(forURL: testImage).getData(maxSize: 15 * 1024 * 1024, completion: { (imgDataTest, error) in
                
                if error == nil {
                    DispatchQueue.main.async {
                        if let data = imgDataTest {
                            cell2.imageTest.image = UIImage(data: data)
                        }
                    }
                    
                }else {
                    print(error!.localizedDescription)
                    
                }
                
                
            })
        
            return cell2

        }
        
           }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView == collectionView1)
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
    
    
    
//    // MARK: <UICollectionViewDelegateFlowLayout>
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//                    //return cell for collection1
//        if(collectionView == collectionView)
//        {
//            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
//            let totalSpace = flowLayout.sectionInset.left
//                + flowLayout.sectionInset.right
//                + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
//            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
//            return CGSize(width: size, height: size)
//            //return cell for collection1
//        }
//        else
//        {
//            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
//            let totalSpace = flowLayout.sectionInset.left
//                + flowLayout.sectionInset.right
//                + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
//            let size = Int((collectionView2.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
//            return CGSize(width: size, height: size)
//            //return cell for collection2
//        }
//        
//       
//    }
    
//    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
//        return CGRect(x: x, y: y, width: width, height: height)
//    }
//    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       
        
        if(collectionView == collectionView1)
        {
            sendNewsTitle = usersArray[indexPath.row].newsTitle as AnyObject
            sendNewsImage = usersArray[indexPath.row].photoURL! as AnyObject?
            sendNewsDetail = usersArray[indexPath.row].newsDetail! as AnyObject?
        }
        else  if(collectionView == collectionView2)
        {
            sendTestimonyTitle = testArray[indexPath.row].testTitle as AnyObject
            sendTestimonyImage = testArray[indexPath.row].imageURLTest as AnyObject?
            sendTestimonyDetail = testArray[indexPath.row].testDetail! as AnyObject?
            
        }
        
    }
    
    
}


