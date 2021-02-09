//
//  ListContactsTableViewCell.swift
//  Contact
//
//  Created by Chyanna Wee on 29/04/2018.
//  Copyright © 2018 Chyanna Wee. All rights reserved.
//

import UIKit

class ListContactsTableViewCell: UITableViewCell {

    @IBOutlet weak var noteModificationTimeStamp: UILabel!
    
    @IBOutlet weak var noteTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
