import UIKit

var str = "Hello, playground"

//
//  ItemModel.swift
//  Nursing Inventory Companion
//
//  Created by Lucas Miller on 2/3/20.
//  Copyright © 2020 Lucas Miller. All rights reserved.
//

class ItemModel: NSObject {
    var id: Int?
    var name: String?
    var quantity: Int?
    
    init(Id: Int, Name: String, Quantity: Int) {
        id = Id
        name = Name
        quantity = Quantity
    }
    
    init?(_ json: [String: Any]) {
        id = json["itemID"] as? Int
        name = json["itemName"] as? String
        quantity = json["quantity"] as? Int
    }
    
    override var description: String {
        return "ID: \(id!) Name: \(name!) Quantity: \(quantity!)"
    }
}


//
//  ItemListModel.swift
//  Nursing Inventory Companion
//
//  Created by Lucas Miller on 2/3/20.
//  Copyright © 2020 Lucas Miller. All rights reserved.
//

import UIKit
import Foundation

protocol ItemListModelProtocol: class {
    func downloadItems(items: NSArray)
}

class ItemListModel: NSObject, URLSessionDelegate {
    //this makes all other users of this model have to follow the same protocol.
    weak var delegate: ItemListModelProtocol!
    
    //What we're actually storing the JSON data in for now.
    var data = Data()
    
    //ItemModel array to access in the ItemTableViewController
    var items = [ItemModel]()
    
    //Right now, service.php just requests a SELECT statement. That'll be changed to a few options.
    //This URL will be replaced by the formal database once we have it running.
    let urlPath = "http://192.168.56.101/CSCI3100/service.php"
    
    //This should download the results of the hardcoded SELECT statement and store the variables with parseJSON().
    func downloadItems () {
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        print("Using URL \(url)")
        
//        var returnedItems = [ItemModel]()
        
        
        //sample item
        let item = ItemModel(Id: 1, Name: "Nice Item", Quantity: 69)
        self.items.append(item)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Failed to download data \(error)")
                } else {
                    
                    //print that the data has been downloaded, parse it into json, and print it to screen
                    print("Data downloaded")
                    print(data!)
                    
                    //get the JSON from the service
                    let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                    
                    //get everything from the json as an array
                    if let array = json as? [Any] {
                        
                        //append each item in the array into the item list
                        for object in array {
                            
                            if let dictionary = object as? [String: Any] {
                                let id = Int(dictionary["itemID"] as! String)
                                let name = dictionary["itemName"] as! String
                                let quantity = Int(dictionary["quantity"] as! String)
                                let item = ItemModel(Id: id!, Name: name, Quantity: quantity!)
                                self.items.append(item)
//                                returnedItems.append(item)
                                
                            } else {
                            
                                print("Problem with dictionary")
                            
                            }
                        }
                    } else {
                        print("The array messed up")
                    }
                }
            }
        task.resume()
//        return returnedItems
    }
    
//    func getArray() -> [ItemModel] {
//        return self.downloadItems()
//    }
}



let model = ItemListModel()
model.downloadItems()
let items = model.items

for i in items {
    print(i)
}
