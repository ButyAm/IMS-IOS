//
//  TestimonyCollectionViewCell.swift
//  ismic
//
//  Created by Muluken on 6/18/17.
//  Copyright © 2017 GCME-EECMY. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class TestimonyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageTest: UIImageView!
    
    @IBOutlet weak var titleTest: UILabel!
    
    
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
    
    func configureCellTestimony(user: Testimony){
        
        self.titleTest.text = user.testTitle
        
        let imageURLTesti = user.imageURLTest!
        
        self.storageRef.reference(forURL: imageURLTesti).data(withMaxSize: 15 * 1024 * 1024, completion: { (imgData, error) in
            
            if error == nil {
                DispatchQueue.main.async {
                    if let data = imgData {
                        self.imageTest.image = UIImage(data: data)
                    }
                }
                
            }else {
                print(error!.localizedDescription)
                
            }
            
            
        })
    }
}

    

