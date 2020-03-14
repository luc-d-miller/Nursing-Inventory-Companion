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
    @IBOutlet weak var quantityField: UITextField!
    var quantityString = ""
    var companyString = ""
    var priceString = ""
    var boxString = ""
    var shelfString = ""
    var minString = ""
    var fieldString = ""
    var itemID = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        quantityLabel.text = quantityString
        companyLabel.text = companyString
        priceLabel.text = priceString
        boxLabel.text = boxString
        shelfLabel.text = shelfString
        minLabel.text = minString
        quantityField.placeholder = quantityString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? EditDetailViewController {
            destination.nameText = self.title!
            destination.itemID = self.itemID
        }
    }
}
