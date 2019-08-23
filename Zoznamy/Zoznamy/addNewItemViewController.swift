//
//  addNewItemViewController.swift
//  Zoznamy
//
//  Created by Martin Kostelej on 15/07/2019.
//  Copyright © 2019 Martin Kostelej. All rights reserved.
//

import UIKit
//import IQKeyboardManager

class addNewItemViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate{
    
    var editItem = false
    var itemText = ""
    var itemDescription = ""
    
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewFromScrollView: UIView!
    @IBOutlet weak var descriptionForItem: UITextView!
    //var list = Lists()
    var item = Item()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //kvoli skryvaniu klavesnice pri dotyku mimo textview
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addNewItemViewController.keyboardDismiss))
        viewFromScrollView.addGestureRecognizer(tap)
        
        itemTextField.delegate = self
        descriptionForItem.delegate = self
        
        if editItem == true{
            itemTextField.text = itemText
            descriptionForItem.text = itemDescription
            
            item.name = itemText
            item.text = itemDescription
        }else{
            descriptionForItem.text = "No description"
        }
        self.changeItem()
        descriptionForItem.backgroundColor = UIColor(red: 190.0/255.0, green: 190.0/255.0, blue: 190.0/255.0, alpha: 1.0)
        //nastavovanie farby pozadia
        if UserDefaults.standard.object(forKey: "darkMode") != nil{
            if UserDefaults.standard.bool(forKey: "darkMode") {
                imageView.image = UIImage(named: "noImageDark")
                self.view.backgroundColor = .black
                viewFromScrollView.backgroundColor = .black
                descriptionForItem.textColor = .white
                //descriptionForItem.backgroundColor = .gray
            }else{
                self.view.backgroundColor = .white
                imageView.image = UIImage(named: "noImageLight")
                viewFromScrollView.backgroundColor = .white
                //descriptionForItem.backgroundColor = .gray
            }
            
        }else{
            imageView.image = UIImage(named: "noImageDark")
            self.view.backgroundColor = .black
            viewFromScrollView.backgroundColor = .black
            descriptionForItem.textColor = .white
            //descriptionForItem.backgroundColor = .gray
        }
    }
    
    @IBAction func changeImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Image Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                print("Camera not availible")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //vyberanie obrazka
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        imageView.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //schovanie klavesnice pri stlaceni enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    //schovavanie klavesnice pri tuknuti mimo
    @objc func keyboardDismiss(){
        viewFromScrollView.endEditing(true)
    }

    
    func changeItem(){
        if editItem {
            self.title = "Edit Item"
        }else{
            self.title = "Add New Item"
        }
    }
}
