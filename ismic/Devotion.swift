//
//  Devotional.swift
//  ismic
//
//  Created by Muluken on 6/18/17.
//  Copyright © 2017 GCME-EECMY. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage


struct Devotion {
    
    var devoTitle: String!
    var devoSummary: String?
    var devoDetailnews: String?
    var devoPhotoURL: String!
    var ref: FIRDatabaseReference?
    var key: String?
    
    init(snapshot: FIRDataSnapshot){
        
        key = snapshot.key
        ref = snapshot.ref
        devoTitle = (snapshot.value! as! NSDictionary)["devotitle"] as! String
        devoSummary = (snapshot.value! as! NSDictionary)["devodetail"] as? String
        devoDetailnews = (snapshot.value! as! NSDictionary)["devodetail"] as? String
        devoPhotoURL = (snapshot.value! as! NSDictionary)["devoimg"] as! String
        
    }
    
    
    //    func toAnyObject() -> [String: Any] {
    //        return ["email"]
    //    }
    
}
