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
    var nameText = "" //Default name text is from the database
    var itemID = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = nameText
        // Do any additional setup after loading the view.
    }
    
    @IBAction func updateName(_ sender: Any) {
        //variables to pass into the database
        let itemName = nameLabel.text!
        let id = self.itemID
        
        //create the request and send it through to the updateName service
        let request = NSMutableURLRequest(url: NSURL(string: "http://192.168.56.101/CSCI3100/updateName.php")! as URL)
        request.httpMethod = "POST"
        
        //This string posts each variable separately, then the php service gets them.
        let postString = "itemName=\(itemName)&itemID=\(id)"
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
        }
        task.resume()
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
