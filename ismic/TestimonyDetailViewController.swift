//
//  TestimonyDetailViewController.swift
//  ismic
//
//  Created by Muluken on 6/20/17.
//  Copyright © 2017 GCME-EECMY. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class TestimonyDetailViewController: UIViewController {
    
    var dataBaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    
    var storageRef: Storage {
        
        return Storage.storage()
    }
    
    @IBOutlet weak var detailtitle: UILabel!
    
    
    @IBOutlet weak var imagedetail: UIImageView!
    
    @IBOutlet weak var detaildesc: UITextView!
    
    
    var getTestTitle: AnyObject? {
        
        get {
            return UserDefaults.standard.object(forKey: "testimonyTitle") as AnyObject?
        }
        
    }
    var getTestDetail: AnyObject? {
        
        get {
            return UserDefaults.standard.object(forKey: "testimonyDetail") as AnyObject?
        }
        
    }
    //get imagesfrom main eventviewcntroller
    var getTestImages: AnyObject? {
        
        get {
            return UserDefaults.standard.object(forKey: "testimonyImage") as AnyObject?
        }
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        detailtitle.text = getTestTitle as? String
        detaildesc.text = getTestDetail as? String
        //  imagedetail.image = UIImage(named: getNewsImage as! String)
        
        let imageURL = getTestImages
        
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
