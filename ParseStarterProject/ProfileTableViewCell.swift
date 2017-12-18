//
//  ProfileTableViewCell.swift
//  ParseStarterProject-Swift
//
//  Created by WM1 on 12/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
     
        // Initialization code
    }
    
    @IBOutlet weak var settingText: UILabel!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
