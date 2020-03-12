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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = nameText
        // Do any additional setup after loading the view.
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
