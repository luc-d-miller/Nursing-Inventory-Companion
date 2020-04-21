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
     //Don't use this. I tried to support swipe-to-delete and then realized I didn't hate myself. -Lucas. Of course this comment is from Lucas. Lucas wrote everything in this entire project except half of ScannerViewController. All while having just bought his first Mac and without knowing a lick of Swift when he started.
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Do deleting stuff here
            }
            
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
            if let cell = sender as? ItemTableViewCell {
                //Send name and id into ItemDetailViewController.
                destination.title = cell.NameLabel.text ?? "None found"
                destination.itemID = cell.id!
            }
        }
    }
    
    
    //This should download the results of the hardcoded SELECT statement and store the variables with parseJSON().
    func downloadItems() -> [ItemModel] {
        let id = 1
        
        //create the request and send it through to the getItem service
        let request = NSMutableURLRequest(url: NSURL(string: "http://www.nursinginventorycompanion.com/service.php")! as URL)
        request.httpMethod = "POST"
        
        //This string posts each variable separately, then the php service gets them.
        let postString = "id=\(id)"

        //Sets up the request
        request.httpBody = postString.data(using: String.Encoding.utf8)

        var downloadedItems = [ItemModel]()
        let semaphore2 = DispatchSemaphore(value: 0)
        
        //Connection
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
           (data, response, error) in

           if error != nil {
               print("error=\(error!)")
               return
           }
            
           //get the JSON from the service
           let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            //punch the JSON into an array of dictionaries
            if let array = json as? [Any] {
                //iterate through each dictionary and append to downloadedItems
                for object in array {
                    if let dictionary = object as? [String: Any] {
                    let id = Int(dictionary["itemID"] as! String)
                    let name = dictionary["itemName"] as! String
                    let quantity = Int(dictionary["quantity"] as! String)
                    let company = dictionary["company"] as! String
                    let price = Int(dictionary["price"] as! String)
                    let boxQuantity = Int(dictionary["boxQuantity"] as! String)
                    let shelfLocation = dictionary["shelfLocation"] as! String
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
           semaphore2.signal()
        }
        task.resume()
        semaphore2.wait()
        semaphore.signal()
        return downloadedItems
    }
}
