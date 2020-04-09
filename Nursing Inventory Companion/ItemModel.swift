//
//  ItemModel.swift
//  Nursing Inventory Companion
//
//  Created by Lucas Miller on 2/3/20.
//  Copyright © 2020 Lucas Miller. All rights reserved.
//

import UIKit

class ItemModel: NSObject, Comparable {
    var id: Int?
    var name: String?
    var quantity: Int?
    var company: String?
    var price: Int?
    var boxQuantity: Int?
    var shelfLocation: Character?
    var minSupplies: Int?
    var barcode: String?
    
    init(Id: Int, Name: String, Quantity: Int, Company: String, Price: Int, BoxQuantity: Int, ShelfLocation: Character, MinSupplies: Int, Barcode: String) {
        id = Id
        name = Name
        quantity = Quantity
        company = Company
        price = Price
        boxQuantity = BoxQuantity
        shelfLocation = ShelfLocation
        minSupplies = MinSupplies
        barcode = Barcode
    }
    
    override var description: String {
        return "ID: \(id!) Name: \(name!) Quantity: \(quantity!)"
    }
    
    static func ==(lhs: ItemModel, rhs: ItemModel) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func <(lhs: ItemModel, rhs: ItemModel) -> Bool {
        return lhs.name! < rhs.name!
    }
}
