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
    
    override init() {
        
    }
    
    init(id: Int, name: String, quantity: Int) {
        self.id = id
        self.name = name
        self.quantity = quantity
    }
    
    override var description: String {
        return "ID: \(id) Name: \(name) Quantity: \(quantity)"
    }
}
