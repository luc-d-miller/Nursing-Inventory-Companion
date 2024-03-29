//
//  ItemDetailViewController.swift
//  Nursing Inventory Companion
//
//  Created by Lucas Miller on 2/1/20.
//  Copyright © 2020 Lucas Miller. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var boxLabel: UILabel!
    @IBOutlet weak var shelfLabel: UILabel!
//    @IBOutlet weak var minLabel: UILabel! //Vance didn't want minimums listed any more, kept for posterity
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var checkInOutField: UITextField!
    
    
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
    var checkInOut = 1
    
    //ViewWillAppear so it updates immediately after editing.
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        //variable to pass into the function
        let id = self.itemID
        
        //create the request and send it through to the getItem service
        let request = NSMutableURLRequest(url: NSURL(string: "(database ip address)/getItem.php")! as URL)
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
                print(dictionary)
                self.nameString = dictionary["itemName"] as! String
                self.quantityString = dictionary["quantity"] as! String
                self.companyString = dictionary["company"] as! String
                self.priceString = dictionary["price"] as! String
                self.boxString = dictionary["boxQuantity"] as! String
                self.shelfString = dictionary["shelfLocation"] as! String
//                self.minString = dictionary["minSupplies"] as! String
                self.barcodeString = dictionary["barcode"] as! String
            } else {
                print("The array messed up")
            }
           semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        self.title = nameString
        self.quantityLabel.text = quantityString
        self.companyLabel.text = companyString
        self.priceLabel.text = priceString
        self.boxLabel.text = boxString
        self.shelfLabel.text = shelfString
//        self.minLabel.text = minString
        self.barcodeLabel.text = barcodeString
        
        checkInOut = 1
        checkInOutField.text! = String(checkInOut)
        self.checkInOutField.delegate = self
    }
    
    // MARK: - Navigation
    
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
//            destination.minSupplyText = self.minString
            destination.barcodeText = self.barcodeString
            destination.itemID = self.itemID
        }
    }
    
    //Button functions
    @IBAction func addOne(_ sender: Any) {
        checkInOut += 1
        checkInOutField.text = String(checkInOut)
    }
    
    @IBAction func subtractOne(_ sender: Any) {
        if (checkInOut > 1) {
            checkInOut -= 1
        }
        checkInOutField.text = String(checkInOut)
    }
    
    @IBAction func fieldChanged(_ sender: Any) {
        if let data = Int(self.checkInOutField.text!) {
            self.checkInOut = data
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
    }
    
    @IBAction func checkIn(_ sender: Any) {
        let newQuantity = self.checkInOut
        let id = self.itemID
        
        //create the request and send it through to the getItem service
        let request = NSMutableURLRequest(url: NSURL(string: "(database ip address)/updateQuantity.php")! as URL)
        request.httpMethod = "POST"

        //Semaphore to make sure I get the JSON before moving on
        let semaphore = DispatchSemaphore(value: 0)

        //This string posts each variable separately, then the php service gets them.
        let postString = "itemID=\(id)&quantity=\(newQuantity)"

        //Sets up the request
        request.httpBody = postString.data(using: String.Encoding.utf8)

        //Connection
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
           (data, response, error) in

           if error != nil {
               print("error=\(error!)")
               return
           }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        self.viewWillAppear(true)
    }
    
    @IBAction func checkOut(_ sender: Any) {
        let newQuantity = -self.checkInOut
        let check = Int(self.quantityLabel.text!)!
        let id = self.itemID
        
        if ((check + newQuantity) < 0) {
            let alert = UIAlertController(title: "Subtracted too many.", message: "You cannot check more items out than there are in storage.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        //create the request and send it through to the getItem service
        let request = NSMutableURLRequest(url: NSURL(string: "(database ip address)/updateQuantity.php")! as URL)
        request.httpMethod = "POST"

        //Semaphore to make sure I get the JSON before moving on
        let semaphore = DispatchSemaphore(value: 0)

        //This string posts each variable separately, then the php service gets them.
        let postString = "itemID=\(id)&quantity=\(newQuantity)"

        //Sets up the request
        request.httpBody = postString.data(using: String.Encoding.utf8)

        //Connection
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
           (data, response, error) in

           if error != nil {
               print("error=\(error!)")
               return
           }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        self.viewWillAppear(true)
    }
    
    //Close keyboard on edit end
    @IBAction func editingEnd(_ sender: Any) {
        self.checkInOutField.resignFirstResponder()
    }
    
    //Close keyboard on touch anywhere
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        [self.checkInOutField.endEditing(true)]
    }
}
