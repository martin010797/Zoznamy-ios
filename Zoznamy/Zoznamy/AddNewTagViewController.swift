//
//  AddNewTagViewController.swift
//  Zoznamy
//
//  Created by Martin Kostelej on 28/08/2019.
//  Copyright © 2019 Martin Kostelej. All rights reserved.
//

import UIKit

class AddNewTagViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textFieldNewTag: UITextField!
    
    //var tagName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldNewTag.delegate = self
        
        self.title = "Add New Tag"
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}
