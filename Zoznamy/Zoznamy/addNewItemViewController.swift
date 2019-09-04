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
    var nameOfList = ""
    var arrayOfChosenTags = [Int]()
    let realmManager = RealmManager()
    
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewFromScrollView: UIView!
    @IBOutlet weak var descriptionForItem: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textViewTags: UITextView!
    
    //var descriptionTextBottomConstraint: CGFloat!
    
    //var list = Lists()
    var item = Item()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //kvoli skryvaniu klavesnice pri dotyku mimo textview
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addNewItemViewController.keyboardDismiss))
        viewFromScrollView.addGestureRecognizer(tap)
        
        itemTextField.delegate = self
        descriptionForItem.delegate = self
        textViewTags.delegate = self
        
        if editItem == true{
            itemTextField.text = itemText
            descriptionForItem.text = itemDescription
            //povodne
            //item.name = itemText
            //item.text = itemDescription
            //nove
            let editedItem = realmManager.getItem(name: itemText)
            item = editedItem!
            let count = editedItem!.IndexOfTags.count
            if count == 0{
                textViewTags.text = "No tags"
            }else{
                textViewTags.text = ""
            }
            for i in 0..<count{
                var nameOfTag = ""
                //let editedItem = realmManager.getItem(name: itemText)
                let list = realmManager.getList(name: nameOfList)
                let index = editedItem?.IndexOfTags[i].value
                arrayOfChosenTags.append(index!)
                nameOfTag = (list?.tags[index!].nameOfTag)!
                if i == 0{
                    textViewTags.text = "#" + nameOfTag
                }else{
                    textViewTags.text = textViewTags.text + " #" + nameOfTag
                }
                
            }
        }else{
            descriptionForItem.text = "No description"
            textViewTags.text = "No Tags"
        }
        self.changeItem()
        descriptionForItem.backgroundColor = UIColor(red: 190.0/255.0, green: 190.0/255.0, blue: 190.0/255.0, alpha: 1.0)
        textViewTags.backgroundColor = UIColor(red: 190.0/255.0, green: 190.0/255.0, blue: 190.0/255.0, alpha: 1.0)
        //nastavovanie farby pozadia
        if UserDefaults.standard.object(forKey: "darkMode") != nil{
            if UserDefaults.standard.bool(forKey: "darkMode") {
                imageView.image = UIImage(named: "noImageDark")
                self.view.backgroundColor = .black
                viewFromScrollView.backgroundColor = .black
                descriptionForItem.textColor = .white
                textViewTags.textColor = .white
                textViewTags.backgroundColor = .black
                //descriptionForItem.backgroundColor = .gray
            }else{
                self.view.backgroundColor = .white
                imageView.image = UIImage(named: "noImageLight")
                viewFromScrollView.backgroundColor = .white
                //descriptionForItem.backgroundColor = .gray
                textViewTags.backgroundColor = .white
            }
            
        }else{
            imageView.image = UIImage(named: "noImageDark")
            self.view.backgroundColor = .black
            viewFromScrollView.backgroundColor = .black
            descriptionForItem.textColor = .white
            textViewTags.textColor = .white
            textViewTags.backgroundColor = .black
            //descriptionForItem.backgroundColor = .gray
        }
        itemTextField.inputAccessoryView = self.doneButtonTextField()
        descriptionForItem.inputAccessoryView = self.doneButtonTextView()
        textViewTags.isEditable = false
        
        
    }

    //tlacidlo done pre skryvanie klavesnice
    func doneButtonTextView() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self,
                                         action: #selector(textViewDonePressed))
        
        if UserDefaults.standard.object(forKey: "darkMode") != nil{
            if UserDefaults.standard.bool(forKey: "darkMode") {
                doneButton.tintColor = .black
            }
        }else{
            doneButton.tintColor = .black
        }
        
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        return toolBar
    }
    
    @objc func textViewDonePressed(sender: UIDatePicker) {
        self.descriptionForItem.endEditing(true)
    }
    
    func doneButtonTextField() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self,
                                         action: #selector(textFieldDonePressed))
        if UserDefaults.standard.object(forKey: "darkMode") != nil{
            if UserDefaults.standard.bool(forKey: "darkMode") {
                doneButton.tintColor = .black
            }
        }else{
            doneButton.tintColor = .black
        }
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        return toolBar
    }
    
    @objc func textFieldDonePressed(sender: UIDatePicker) {
        self.itemTextField.endEditing(true)
    }
    
    //posuvaju obrazovku nižšie kvôli zobrazovnaiu klavesnice cez textview
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 400), animated: true)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
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
    /*
    //pokusy s ukladanim obrazku
    func saveImage(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            let nameOfImage = item.name + ".png"
            try data.write(to: directory.appendingPathComponent(nameOfImage)!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }*/
    
    
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
    
    @IBAction func changeTags(_ sender: Any) {
        performSegue(withIdentifier: "changeTagsSegue", sender: self)
    }
    
    //MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeTagsSegue"{
            let tagsViewController = segue.destination as! TagsViewController
            
            tagsViewController.nameOfItem = itemText
            tagsViewController.nameOfList = nameOfList
            tagsViewController.arrayOfChosenTags = arrayOfChosenTags
        }
    }
    
    @IBAction func changeIndexTags(segue: UIStoryboardSegue){
        //var arrayOfChosenTags = [Int]()
        let changeIndexTags = segue.source as! TagsViewController
        arrayOfChosenTags = changeIndexTags.arrayOfChosenTags
        textViewTags.text = ""
        if arrayOfChosenTags.count == 0{
            textViewTags.text = "No tags"
        }
        for i in 0..<arrayOfChosenTags.count{
            var nameOfTag = ""
            //let editedItem = realmManager.getItem(name: itemText)
            let list = realmManager.getList(name: nameOfList)
            //let index = editedItem?.IndexOfTags[i].value
            //arrayOfChosenTags.append(index!)
            nameOfTag = (list?.tags[arrayOfChosenTags[i]].nameOfTag)!
            if i == 0{
                textViewTags.text = "#" + nameOfTag
            }else{
                textViewTags.text = textViewTags.text + " #" + nameOfTag
            }
        }
    }
    
}
