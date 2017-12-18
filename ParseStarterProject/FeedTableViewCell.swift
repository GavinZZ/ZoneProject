//
//  FeedTableViewCell.swift
//  ParseStarterProject-Swift
//
//  Created by WM1 on 12/7/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import QuartzCore

extension UITableViewCell {
    var tableView: UITableView? {
        var view = self.superview
        while (view != nil && view!.isKind(of: UITableView.self) == false) {
            view = view!.superview
        }
        return view as? UITableView
    }
}

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var postedImage: UIImageView!
    
    @IBOutlet weak var userText: UILabel!
    
    @IBOutlet weak var animationImage: UIImageView!
    
    @IBOutlet weak var heartIcon: UIImageView!
    
    @IBOutlet weak var peopleLiked: UILabel!
    
    @IBOutlet weak var createdDate: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var cellPeopleLiked = Array<String>()
    
    @IBAction func showMore(_ sender: Any) {
        
        if (counter == 0) {
            
            newLabel.isHidden = false
            
            peopleLiked.isHidden = true
            
            var newString = ""
            
            for people in cellPeopleLiked {
                
                newString += people
                
                newString += ", "
                
            }
            
            if (newString != "") {
                
                newString.removeLast()
                
                newString.removeLast()
                
                newString += "."
                
            }
            
            newLabel.text = newString
            
            counter = 1
            
        } else {
            
            newLabel.isHidden = true
            
            peopleLiked.isHidden = false
            
            counter = 0
            
        }
        
        showText.setTitle("Show Less", for: [])
        
    }
    
    @IBOutlet weak var newLabel: UILabel!
    
    var counter = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        
        newLabel.layer.masksToBounds = true
        
        newLabel.layer.cornerRadius = 5
        
        newLabel.textColor = UIColor.black
        
        newLabel.numberOfLines = 3
        
//        newLabel.adjustsFontSizeToFitWidth = true
        
        newLabel.isHidden = true
        
        newLabel.backgroundColor = UIColor.lightGray
        
        // Initialization code
    }
    @IBOutlet weak var showText: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        var color = self.peopleLiked.backgroundColor // Store the color
        super.setSelected(selected, animated: animated)
        self.peopleLiked.backgroundColor = color
        self.contentView.backgroundColor = UIColor.white
        
    }

}
