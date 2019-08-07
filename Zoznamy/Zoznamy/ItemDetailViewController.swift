//
//  ItemDetailViewController.swift
//  Zoznamy
//
//  Created by Martin Kostelej on 15/07/2019.
//  Copyright © 2019 Martin Kostelej. All rights reserved.
//

import UIKit

class ItemDetailViewController:  UIViewController{
    
    @IBOutlet weak var itemLabel: UILabel!
    
    var itemText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemLabel.text = itemText
        //nastavovanie farby pozadia
        if UserDefaults.standard.object(forKey: "darkMode") != nil{
            if UserDefaults.standard.bool(forKey: "darkMode") {
                self.view.backgroundColor = .black
            }else{
                self.view.backgroundColor = .white
            }
            
        }else{
            self.view.backgroundColor = .black
        }
    }
    @IBAction func editItem(_ sender: Any) {
        performSegue(withIdentifier: "editItemSegue", sender: self)
    }
    
    //MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editItemSegue"{
            let navViewController = segue.destination as! UINavigationController
            let editItemViewController = navViewController.viewControllers[0] as! addNewItemViewController
            
            editItemViewController.itemText = itemText
            editItemViewController.editItem = true
        }
    }
}
