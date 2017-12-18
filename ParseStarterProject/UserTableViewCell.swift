//
//  UserTableViewCell.swift
//  ParseStarterProject-Swift
//
//  Created by WM1 on 12/8/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.frame.origin.x += 10
        
        self.frame.size.width -= 20
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        var color = self.followText.backgroundColor // Store the color
//        super.setSelected(selected, animated: animated)
        self.followText.backgroundColor = color
        self.contentView.backgroundColor = UIColor.white
    }

    @IBOutlet weak var summary: UILabel!
    
    @IBOutlet weak var followText: UILabel!
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    


}
