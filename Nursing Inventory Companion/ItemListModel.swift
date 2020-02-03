//
//  ItemListModel.swift
//  Nursing Inventory Companion
//
//  Created by Lucas Miller on 2/3/20.
//  Copyright © 2020 Lucas Miller. All rights reserved.
//

import UIKit

protocol ItemListModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class ItemListModel: NSObject, URLSessionDelegate {
    //this makes all other users of this model have to follow the same protocol.
    weak var delegate: ItemListModelProtocol!
    
    //What we're actually storing the JSON data in.
    var data = Data()
    
    //Right now, service.php just requests a SELECT statement. That'll be changed to a few options.
    let urlPath: String = "192.168.56.101/CSCI3100/service.php"
    
    //This should download the results of the hardcoded SELECT statement. Right now it does not. >_>
    //It looks like the sample I've been following was made for a version of Xcode that liked JSON and this one doesn't so yay. 
    func downloadItems () {
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Failed to download data")
                }else {
                    print("Data downloaded")
                    self.parseJSON(data!)
                }
            }
            task.resume()
        }
    }
}
