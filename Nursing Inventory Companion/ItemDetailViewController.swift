//
//  ItemDetailViewController.swift
//  Nursing Inventory Companion
//
//  Created by Lucas Miller on 2/1/20.
//  Copyright © 2020 Lucas Miller. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {

    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var boxLabel: UILabel!
    @IBOutlet weak var shelfLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var barcodeLabel: UILabel!
    
    var nameString = ""
    var quantityString = ""
    var companyString = ""
    var priceString = ""
    var boxString = ""
    var shelfString = ""
    var minString = ""
    var fieldString = ""
    var barcodeString = ""
    var itemID = -1
    
    //ViewWillAppear so it updates immediately after editing.
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        //variable to pass into the function
        let id = self.itemID
        
        //create the request and send it through to the getItem service
        let request = NSMutableURLRequest(url: NSURL(string: "http://192.168.56.101/CSCI3100/getItem.php")! as URL)
        request.httpMethod = "POST"

        //Semaphore to make sure I get the JSON before moving on
        let semaphore = DispatchSemaphore(value: 0)

        //This string posts each variable separately, then the php service gets them.
        let postString = "itemID=\(id)"

        //Sets up the request
        request.httpBody = postString.data(using: String.Encoding.utf8)

        //Connection
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
           (data, response, error) in

           if error != nil {
               print("error=\(error!)")
               return
           }
            
           //get the JSON from the service
           let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            if let dictionary = json as? [String: Any] {
                self.nameString = dictionary["itemName"] as! String
                self.quantityString = dictionary["quantity"] as! String
                self.companyString = dictionary["company"] as! String
                self.priceString = dictionary["price"] as! String
                self.boxString = dictionary["boxQuantity"] as! String
                self.shelfString = dictionary["shelfLocation"] as! String
                self.minString = dictionary["minSupplies"] as! String
                self.barcodeString = dictionary["barcode"] as! String
            } else {
                print("The array messed up")
            }
           semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        self.title = nameString
        quantityLabel.text = quantityString
        companyLabel.text = companyString
        priceLabel.text = priceString
        boxLabel.text = boxString
        shelfLabel.text = shelfString
        minLabel.text = minString
        barcodeLabel.text = barcodeString
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? EditDetailViewController {
            destination.nameText = self.title!
            destination.quantityText = self.quantityString
            destination.companyText = self.companyString
            destination.priceText = self.priceString
            destination.boxQuantityText = self.boxString
            destination.shelfLocationText = self.shelfString
            destination.minSupplyText = self.minString
            destination.barcodeText = self.barcodeString
            destination.itemID = self.itemID
        }
    }
}
