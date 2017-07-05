//
//  NewsDetailViewController.swift
//  globalstart
//
//  Created by Muluken on 3/20/17.
//  Copyright © 2017 globalstart. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class NewsDetailViewController: UIViewController {
    
    var dataBaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    
    var storageRef: Storage {
        
        return Storage.storage()
    }
   
    @IBOutlet weak var detailtitle: UILabel!
    
 
    @IBOutlet weak var imagedetail: UIImageView!
    
    @IBOutlet weak var detaildesc: UITextView!
    
    
    var getNewsTitle: AnyObject? {
        
        get {
            return UserDefaults.standard.object(forKey: "newsTitle") as AnyObject?
        }
        
    }
    var getNewsDetail: AnyObject? {
        
        get {
            return UserDefaults.standard.object(forKey: "newsDetail") as AnyObject?
        }
        
    }
    //get imagesfrom main eventviewcntroller
    var getNewsImage: AnyObject? {
        
        get {
            return UserDefaults.standard.object(forKey: "newsImage") as AnyObject?
        }
        
    }
    
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let nav = self.navigationController?.navigationBar
//     //   nav?.barStyle = UIBarStyle.black
//        nav?.tintColor = UIColor.white
//        nav?.backgroundColor = UIColor(red: 2.0/255.0, green: 80.0/255.0, blue: 151.0/255.0, alpha: 1.0)
//        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orange]
//        
//        
        detailtitle.text = getNewsTitle as? String
        detaildesc.text = getNewsDetail as? String
      //  imagedetail.image = UIImage(named: getNewsImage as! String)

        let imageURL = getNewsImage
        
        self.storageRef.reference(forURL: imageURL! as! String).getData(maxSize: 15 * 1024 * 1024, completion: { (imgData, error) in
            
            if error == nil {
                DispatchQueue.main.async {
                    if let data = imgData {
                        self.imagedetail.image = UIImage(data: data)
                    }
                }
                
            }else {
                print(error!.localizedDescription)
                
            }
            
            
        })

        
       // configureCell()
      
   }
//    func configureCell(){
//        
//        self.detailtitle.text = SentData1
//        
//        self.detaildesc.text = SentData4
//
//        let imageURL = SentData3
//        
//        self.storageRef.reference(forURL: imageURL!).data(withMaxSize: 1 * 1024 * 1024, completion: { (imgData, error) in
//            
//            if error == nil {
//                DispatchQueue.main.async {
//                    if let data = imgData {
//                        self.imagedetail.image = UIImage(data: data)
//                    }
//                }
//                
//            }else {
//                print(error!.localizedDescription)
//                
//            }
//            
//            
//        })
//    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
