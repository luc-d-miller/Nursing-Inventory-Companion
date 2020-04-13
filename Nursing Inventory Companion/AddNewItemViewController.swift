//
//  AddNewItemViewController.swift
//  Nursing Inventory Companion
//
//  Created by Lucas Miller on 4/6/20.
//  Copyright © 2020 Lucas Miller. All rights reserved.
//

import UIKit

class AddNewItemViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var companyField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var numberPerBoxField: UITextField!
    @IBOutlet weak var shelfLocationField: UITextField!
    @IBOutlet weak var minSupplyField: UITextField!
    @IBOutlet weak var barcodeField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveNewItem(_ sender: Any) {
        if (self.nameField.text! == "" || self.quantityField.text! == "" || self.companyField.text! == "" || self.priceField.text! == "" || self.numberPerBoxField.text! == "" || self.shelfLocationField.text! == "" || self.minSupplyField.text! == "") {
            print("Something went wrong with the if statement.")
            let alert = UIAlertController(title: "Fields still empty", message: "There can be no empty fields when submitting a new item.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else {
            //variables to pass into the database
            let itemName = nameField.text!
            let itemQuantity = Int(quantityField.text!)
            let company = companyField.text!
            let price = Int(priceField.text!)
            let boxQuantity = numberPerBoxField.text!
            let shelfLocation = shelfLocationField.text!
            let minSupply = minSupplyField.text!
            var barcode = ""
            if (barcodeField.text! == "") {
                barcode = barcodeField.placeholder!
            } else {
                barcode = barcodeField.text!
            }
            
            //create the request and send it through to the updateName service
            let request = NSMutableURLRequest(url: NSURL(string: "http://192.168.56.101/CSCI3100/addItem.php")! as URL)
            request.httpMethod = "POST"
            let semaphore = DispatchSemaphore(value: 0)
            
            //This string posts each variable separately, then the php service gets them.
            let postString = "itemName=\(itemName)&quantity=\(itemQuantity!)&company=\(company)&price=\(price!)&boxQuantity=\(boxQuantity)&shelfLocation=\(shelfLocation)&minSupplies\(minSupply)&barcode=\(barcode)"
            
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
                semaphore.signal()
            }
            task.resume()
            semaphore.wait()
            
            //Return to previous ViewController
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
