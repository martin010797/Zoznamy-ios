//
//  AddNewListViewController.swift
//  Zoznamy
//
//  Created by Martin Kostelej on 15/07/2019.
//  Copyright © 2019 Martin Kostelej. All rights reserved.
//

import UIKit

class AddNewListViewController: UIViewController, UITextFieldDelegate {
    
    var editList = false
    var listText = ""
    
    @IBOutlet weak var listTextView: UITextField!
    
    var list = Lists()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTextView.delegate = self
        
        if  editList == true {
            listTextView.text = listText
            
            list.name = listText
        }
        self.changeTitle()
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
    /*
    //skryvanie klavesnice pre textview
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            //tato funkcia zarucuje ze bude obrazovka vyzerat tak ako ked sme na nu prisli
            textView.resignFirstResponder()
            return false
        }
        return true
    }*/
    //skryvanie klavesnice pre textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func changeTitle(){
        if editList {
            self.title = "Edit List"
        }else{
            self.title = "Add New List"
        }
    }
}
