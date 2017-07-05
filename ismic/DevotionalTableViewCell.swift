//
//  DevotionalTableViewCell.swift
//  ismic
//
//  Created by Muluken on 6/18/17.
//  Copyright © 2017 GCME-EECMY. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage


class DevotionalTableViewCell: UITableViewCell {
    @IBOutlet weak var devoImage: UIImageView!
   
    @IBOutlet weak var devoDetail: UITextView!
    @IBOutlet weak var devoTItle: UILabel!
//    @IBOutlet weak var devTitle: UILabel!
//    @IBOutlet weak var devDetail: UITextView!
//    @IBOutlet weak var devImage: UIImageView!
    
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
    
    func configureCell(user: Devotion){
        
        self.devoDetail.text = user.devoSummary
        self.devoTItle.text = user.devoTitle
        
        
        let imageURL = user.devoPhotoURL!
        
        self.storageRef.reference(forURL: imageURL).getData(maxSize: 15 * 1024 * 1024, completion: { (imgData, error) in
            
            if error == nil {
                DispatchQueue.main.async {
                    if let data = imgData {
                        self.devoImage.image = UIImage(data: data)
                    }
                }
                
            }else {
                print(error!.localizedDescription)
                
            }
            
            
        })
    }
    
}
