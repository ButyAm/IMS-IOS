//
//  File.swift
//  ismic
//
//  Created by Muluken on 6/18/17.
//  Copyright © 2017 GCME-EECMY. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


struct News {
    
    var title: String!
    var summary: String?
    var detailnews: String?
    var photoURL: String!
    var ref: DatabaseReference?
    var key: String?
    
    init(snapshot: DataSnapshot){
        
        key = snapshot.key
        ref = snapshot.ref
        title = (snapshot.value! as! NSDictionary)["newstitle"] as! String
        summary = (snapshot.value! as! NSDictionary)["newsdetail"] as? String
        detailnews = (snapshot.value! as! NSDictionary)["newsdetail"] as? String
        photoURL = (snapshot.value! as! NSDictionary)["newsimg"] as! String
        
              

        
    }
    
    
    //    func toAnyObject() -> [String: Any] {
    //        return ["email"]
    //    }
    
}
