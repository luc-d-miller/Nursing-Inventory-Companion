//
//  ItemTableViewCell.swift
//  Nursing Inventory Companion
//
//  Created by Lucas Miller on 1/30/20.
//  Copyright © 2020 Lucas Miller. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    static var REUSE_ID = "ITEM_CELL"
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var CountLabel: UILabel!
    var id: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
