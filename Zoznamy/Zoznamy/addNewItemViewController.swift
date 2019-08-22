//
//  addNewItemViewController.swift
//  Zoznamy
//
//  Created by Martin Kostelej on 15/07/2019.
//  Copyright © 2019 Martin Kostelej. All rights reserved.
//

import UIKit

class addNewItemViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var editItem = false
    var itemText = ""
    
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
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
                imageView.image = UIImage(named: "noImageDark")
                self.view.backgroundColor = .black
            }else{
                self.view.backgroundColor = .white
                imageView.image = UIImage(named: "noImageLight")
            }
            
        }else{
            imageView.image = UIImage(named: "noImageDark")
            self.view.backgroundColor = .black
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
    
    func changeItem(){
        if editItem {
            self.title = "Edit Item"
        }else{
            self.title = "Add New Item"
        }
    }
}
