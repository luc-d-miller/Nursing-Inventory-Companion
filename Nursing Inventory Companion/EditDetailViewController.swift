//
//  EditDetailViewController.swift
//  Nursing Inventory Companion
//
//  Created by Lucas Miller on 3/11/20.
//  Copyright © 2020 Lucas Miller. All rights reserved.
//

import UIKit

class EditDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UITextField! //Edits the name of the Item
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var companyField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var boxQuantityField: UITextField!
    @IBOutlet weak var shelfLocationField: UITextField!
    @IBOutlet weak var minSupplyField: UITextField!
    
    var nameText = "" //Default name text is from the database
    var quantityText = "" //Default quantity amount is from database
    var companyText = "" //Default company name is from database
    var priceText = "" //Default price is from database
    var boxQuantityText = "" //Default box quantity is from database
    var shelfLocationText = "" //Default shelf location is from database
    var minSupplyText = "" //Default minimum supply is from database
    var itemID = -1 //relevant for save button
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = nameText
        quantityField.text = quantityText
        companyField.text = companyText
        priceField.text = priceText
        boxQuantityField.text = boxQuantityText
        shelfLocationField.text = shelfLocationText
        minSupplyField.text = minSupplyText
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveToDatabase(_ sender: Any) {
        //variables to pass into the database
        let itemName = nameLabel.text!
        let itemQuantity = Int(quantityField.text!)
        let company = companyField.text!
        let price = Int(priceField.text!)
        let boxQuantity = boxQuantityField.text!
        let shelfLocation = shelfLocationField.text!
        let minSupply = minSupplyField.text!
        
        let id = self.itemID
        
        //create the request and send it through to the updateName service
        let request = NSMutableURLRequest(url: NSURL(string: "http://192.168.56.101/CSCI3100/updateItem.php")! as URL)
        request.httpMethod = "POST"
        let semaphore = DispatchSemaphore(value: 0)
        
        //This string posts each variable separately, then the php service gets them.
        let postString = "itemName=\(itemName)&itemQuantity=\(itemQuantity!)&company=\(company)&price=\(price!)&boxQuantity=\(boxQuantity)&shelfLocation=\(shelfLocation)&minSupply\(minSupply)&itemID=\(id)"
        
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
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func deleteFromDatabase(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Item", message: "Are you sure you want to permanently delete \(self.nameLabel.text!)?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            let id = self.itemID
                    
            //create the request and send it through to the updateName service
            let request = NSMutableURLRequest(url: NSURL(string: "http://192.168.56.101/CSCI3100/deleteItem.php")! as URL)
            request.httpMethod = "POST"
            let semaphore = DispatchSemaphore(value: 0)
            
            //This string posts each variable separately, then the php service gets them.
            let postString = "itemID=\(id)"
            
            request.httpBody = postString.data(using: String.Encoding.utf8)

            //Connection
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in

                if error != nil {
                    print("error=\(error!)")
                    return
                }

                //debugging
    //            print("response = \(response!)")

                //Idk why this outputs blank, it didn't three days ago. Function works anyway.
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("responseString = \(responseString!)")
                semaphore.signal()
            }
            task.resume()
            semaphore.wait()
            
            //Pop back to ItemTableViewController
            _ = self.navigationController?.popViewController(animated: true)
            _ = self.navigationController?.popViewController(animated: true)
//            let viewControllers: [UIViewController] = self.navigationController?.viewControllers as! [UIViewController]
//            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if let destination = segue.destination as? ItemDetailViewController {
            destination.nameString = self.nameLabel.text!
            destination.itemID = self.itemID
            destination.quantityString = self.quantityField.text!
            destination.companyString = self.companyField.text!
            destination.priceString = self.priceField.text!
            destination.boxString = self.boxQuantityField.text!
            destination.shelfString = self.shelfLocationField.text!
            destination.minString = self.minSupplyField.text!
        )
        // Pass the selected object to the new view controller.
    }
    */
}
