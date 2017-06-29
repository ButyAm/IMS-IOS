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


struct Pray {
    
    var titlePray: String!
    var summaryPray: String?
    var ref: FIRDatabaseReference?
    var key: String?
    
    init(snapshot: FIRDataSnapshot){
        
        key = snapshot.key
        ref = snapshot.ref
        titlePray = (snapshot.value! as! NSDictionary)["prayertitle"] as! String
        summaryPray = (snapshot.value! as! NSDictionary)["prayerdetail"] as? String
        
    }
    
    
    //    func toAnyObject() -> [String: Any] {
    //        return ["email"]
    //    }
    
}
