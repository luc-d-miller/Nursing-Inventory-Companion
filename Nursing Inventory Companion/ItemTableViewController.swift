//
//  ItemTableViewController.swift
//  Nursing Inventory Companion
//
//  Created by Lucas Miller on 2/1/20.
//  Copyright © 2020 Lucas Miller. All rights reserved.
//

import UIKit

class ItemTableViewController: UITableViewController {
    private var items = [ItemModel]()
    var semaphore = DispatchSemaphore(value: 0)
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        let output = downloadItems().sorted()
        semaphore.wait()
        self.items = output
        tableView.reloadSections(IndexSet(integersIn: 0...0), with: UITableView.RowAnimation.automatic)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.REUSE_ID, for: indexPath) as! ItemTableViewCell
        // Configure the cell...
        cell.id = items[indexPath.row].id!
        cell.NameLabel.text = items[indexPath.row].name!
        cell.CountLabel.text = String(items[indexPath.row].quantity!)
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
     I tried to make swipe-to-delete and destroyed the database
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //create the request and send it through to the updateName service
            let request = NSMutableURLRequest(url: NSURL(string: "http://192.168.56.101/CSCI3100/deleteItem.php")! as URL)
            request.httpMethod = "POST"
            let semaphore = DispatchSemaphore(value: 0)

            //This string posts the ID to the php service.
            let postString = "id=\(indexPath.row)"
            
            request.httpBody = postString.data(using: String.Encoding.utf8)

            //Connection
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in

                if error != nil {
                    print("error=\(error!)")
                    return
                }

                //debugging
                print("response = \(response!)")

                //Idk why this outputs blank, it didn't three days ago. Function works anyway.
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("responseString = \(responseString!)")
                semaphore.signal()
            }
            task.resume()
            semaphore.wait()
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
 */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? ItemDetailViewController {
            //does things
            if let cell = sender as? ItemTableViewCell {
                //rewrite this into selecting the ItemModel from the array
                destination.title = cell.NameLabel.text ?? "None found"
//                var i = 0
//                for item in items {
//                    if (item.id! == cell.id!) {
//                        i = item.id! - 1
//                        break
//                    }
//                }
                
                //passes id into ItemDetailViewController
                destination.itemID = cell.id!
            }
        }
    }


    
    
//What we're actually storing the JSON data in for now.
    var data = Data()
    
    
    
    //Right now, service.php just requests a SELECT statement. That'll be changed to a few options.
    //This URL will be replaced by the formal database once we have it running.
    let urlPath = "http://192.168.56.101/CSCI3100/service.php"
    
    //This should download the results of the hardcoded SELECT statement and store the variables with parseJSON().
    func downloadItems() -> [ItemModel] {
            
        //ItemModel array to access in the ItemTableViewController
        var downloadedItems = [ItemModel]()
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        print("Using URL \(url)")
        
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
}
