//
//  addNewItemViewController.swift
//  Zoznamy
//
//  Created by Martin Kostelej on 15/07/2019.
//  Copyright © 2019 Martin Kostelej. All rights reserved.
//

import UIKit

class addNewItemViewController: UIViewController, UITextFieldDelegate {
    
    var editItem = false
    var itemText = ""
    
    @IBOutlet weak var itemTextField: UITextField!
    
    //var list = Lists()
    var item = Item()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemTextField.delegate = self
        
        if editItem == true{
            itemTextField.text = itemText
            
            item.name = itemText
        }
        self.changeItem()
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
    
    
    //schovanie klavesnice pri stlaceni enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func changeItem(){
        if editItem {
            self.title = "Edit Item"
        }else{
            self.title = "Add New Item"
        }
    }
}
