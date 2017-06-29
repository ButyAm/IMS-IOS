//
//  Post.swift
//  devslopes-social
//
//  Created by Jess Rascal on 25/07/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


struct User {
    
    var newsTitle: String!

    var newsDetail: String!

    var photoURL: String!
    var ref: FIRDatabaseReference?
    var key: String?
    
    init(snapshot: FIRDataSnapshot){
        
        key = snapshot.key
        ref = snapshot.ref
        newsTitle = (snapshot.value! as! NSDictionary)["newstitle"] as! String
        newsDetail = (snapshot.value! as! NSDictionary)["newsdetail"] as! String
       
        photoURL = (snapshot.value! as! NSDictionary)["newsimg"] as! String
        
    }
    
    
    //    func toAnyObject() -> [String: Any] {
    //        return ["email"]
    //    }
    
}
