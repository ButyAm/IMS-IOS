//
//  Testimony.swift
//  ismic
//
//  Created by Muluken on 6/18/17.
//  Copyright © 2017 GCME-EECMY. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


struct Testimony {
    
    var testTitle: String!
    
    var testDetail: String!
    
    var imageURLTest: String!
    var ref: DatabaseReference?
    var key: String?
    
    init(snapshot: DataSnapshot){
        
        key = snapshot.key
        ref = snapshot.ref
        testTitle = (snapshot.value! as! NSDictionary)["testimonytitle"] as! String
        testDetail = (snapshot.value! as! NSDictionary)["testimonydetail"] as! String
        
        imageURLTest = (snapshot.value! as! NSDictionary)["testimonyimg"] as! String
        
    }
    
    
    //    func toAnyObject() -> [String: Any] {
    //        return ["email"]
    //    }
    
}
