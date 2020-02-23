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
    func itemsDownloaded(items: NSArray)
}

class ItemListModel: NSObject, URLSessionDelegate {
    //this makes all other users of this model have to follow the same protocol.
    weak var delegate: ItemListModelProtocol!
    
    //What we're actually storing the JSON data in for now.
    var data = Data()
    
    //Right now, service.php just requests a SELECT statement. That'll be changed to a few options.
    //This URL will be replaced by the formal database once we have it running. 
    let urlPath: String = "192.168.56.101/CSCI3100/service.php"
    
    //This should download the results of the hardcoded SELECT statement and store the variables with parseJSON().
    func downloadItems () {
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Failed to download data")
                }else {
                    //print that the data has been downloaded, parse it into json, and print it to screen
                    print("Data downloaded")
                    print(data!)
//                    let json = try? JSONSerialization.jsonObject(with: data!, options: [])
//                    print(json)
                    self.parseJSON(data!)
                }
            }
        task.resume()
    }
    
    //sets up a dictionary of 
    func parseJSON(_ data: Data) {
        
    }
}
