//
//  AccountTableViewCell.swift
//  Passlet
//
//  Created by Pulido on 7/21/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import RealmSwift

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
