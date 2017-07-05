//
//  TestiTableViewCell.swift
//  ismic
//
//  Created by Muluken on 6/18/17.
//  Copyright © 2017 GCME-EECMY. All rights reserved.
//

import UIKit

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage


class TestiTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageTesti: UIImageView!
    @IBOutlet weak var testiTitle: UILabel!

    @IBOutlet weak var testiDetail: UITextView!
    
    var dataBaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    var storageRef: Storage {
        
        return Storage.storage()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // newsimage.layer.cornerRadius = 54
        
    }
    
    func configureCell(testi: Testi){
        
        self.testiDetail.text = testi.testimonyDetail
        self.testiTitle.text = testi.testimonyTitle
        
        let testimonyImageUrl = testi.testimonyImages!
        
        self.storageRef.reference(forURL: testimonyImageUrl).getData(maxSize: 15 * 1024 * 1024, completion: { (imgData, error) in
            
            if error == nil {
                DispatchQueue.main.async {
                    if let data = imgData {
                        self.imageTesti.image = UIImage(data: data)
                    }
                }
                
            }else {
                print(error!.localizedDescription)
                
            }
            
            
        })
    }
    
}
