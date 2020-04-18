import UIKit

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
    
    //These two functions, gained from extending Comparable, allow me to alphabetize the list in ItemTableViewController.viewDidAppear().
    static func ==(lhs: ItemModel, rhs: ItemModel) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func <(lhs: ItemModel, rhs: ItemModel) -> Bool {
        return lhs.name! < rhs.name!
    }
}


func downloadItems() -> [ItemModel] {
        //What we're actually storing the JSON data in for now.
//        var data = Data()
        
        //This URL will be replaced by the formal database once we have it running.
        let urlPath = "http://192.168.56.101/CSCI3100/service.php"
        
        //ItemModel array to access in the ItemTableViewController
        var downloadedItems = [ItemModel]()
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        print("Using URL \(url)")
    let semaphore = DispatchSemaphore(value: 0)
        let semaphore2 = DispatchSemaphore(value: 0)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Failed to download data \(error!)")
            } else {
                //print that the data has been downloaded, parse it into json, and print it to screen
                print("Data downloaded")
                print(data!)
                    
                //get the JSON from the service
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                print(json)
                    
                //get everything from the json as an array
                if let array = json as? [Any] {
                    
                    //append each item in the array into the item list
                    for object in array {
                            
                        if let dictionary = object as? [String: Any] {
                            let id = Int(dictionary["itemID"] as! String)
                            let name = dictionary["itemName"] as! String
                            let quantity = Int(dictionary["quantity"] as! String)
                            let company = dictionary["company"] as! String
                            let price = Int(dictionary["price"] as! String)
                            let boxQuantity = Int(dictionary["boxQuantity"] as! String)
                            let shelfLocation = Character(dictionary["shelfLocation"] as! String)
                            let minSupplies = Int(dictionary["minSupplies"] as! String)
                            let barcode = dictionary["barcode"] as! String
                            let item = ItemModel(Id: id!, Name: name, Quantity: quantity!, Company: company, Price: price!, BoxQuantity: boxQuantity!, ShelfLocation: shelfLocation, MinSupplies: minSupplies!, Barcode: barcode)
                            downloadedItems.append(item)
                                
                        } else {
                            
                            print("Problem with dictionary")
                            
                        }
                    }
                } else {
                    print("The array messed up")
                }
                    
            }
            semaphore2.signal()
        }
        task.resume()
        semaphore2.wait()
        semaphore.signal()
        return downloadedItems
    }

print(downloadItems())
