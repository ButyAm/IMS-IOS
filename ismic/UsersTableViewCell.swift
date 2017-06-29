//
//  NewsTableViewCell.swift
//  globalstart
//
//  Created by Muluken on 2/17/17.
//  Copyright © 2017 globalstart. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage


class UsersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titlenews: UILabel!

    @IBOutlet weak var summarynews: UILabel!
    
 
    @IBOutlet weak var pubdatenews: UILabel!
    


    @IBOutlet weak var newsimage: UIImageView!
    
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
    
    func configureCell(user: User){
        
        self.summarynews.text = user.summary
        self.titlenews.text = user.title
        self.pubdatenews.text = user.pubdate!
        
        let imageURL = user.photoURL!
        
        self.storageRef.reference(forURL: imageURL).data(withMaxSize: 1 * 1024 * 1024, completion: { (imgData, error) in
            
            if error == nil {
                DispatchQueue.main.async {
                    if let data = imgData {
                        self.newsimage.image = UIImage(data: data)
                    }
                }
                
            }else {
                print(error!.localizedDescription)
                
            }
            
            
        })
    }
    
}
