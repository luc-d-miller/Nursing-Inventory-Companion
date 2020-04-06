//
//  AddNewItemViewController.swift
//  Nursing Inventory Companion
//
//  Created by Lucas Miller on 4/6/20.
//  Copyright © 2020 Lucas Miller. All rights reserved.
//

import UIKit

class AddNewItemViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveNewItem(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
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
