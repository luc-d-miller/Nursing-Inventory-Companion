//
//  ItemModel.swift
//  Nursing Inventory Companion
//
//  Created by Lucas Miller on 2/3/20.
//  Copyright © 2020 Lucas Miller. All rights reserved.
//

import UIKit

class ItemModel: NSObject {
    var id: Int?
    var name: String?
    var quantity: Int?
    
    init(Id: Int, Name: String, Quantity: Int) {
        id = Id
        name = Name
        quantity = Quantity
    }
    
    init?(json: [String: Any]) {
        id = json["itemID"] as? Int
        name = json["itemName"] as? String
        quantity = json["quantity"] as? Int
    }
    
    override var description: String {
        return "ID: \(id!) Name: \(name!) Quantity: \(quantity!)"
    }
}
