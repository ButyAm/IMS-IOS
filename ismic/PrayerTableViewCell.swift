//
//  PrayerTableViewCell.swift
//  ismic
//
//  Created by Muluken on 6/18/17.
//  Copyright © 2017 GCME-EECMY. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class PrayerTableViewCell: UITableViewCell {
    @IBOutlet weak var prayDetail: UILabel!

    @IBOutlet weak var prayTitle: UILabel!
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var storageRef: FIRStorage {
        
        return FIRStorage.storage()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // newsimage.layer.cornerRadius = 54
        
    }
    
    func configureCell(user: Pray){
        
        self.prayDetail.text = user.summaryPray
        self.prayTitle.text = user.titlePray
        
        
        
    }
    
}
