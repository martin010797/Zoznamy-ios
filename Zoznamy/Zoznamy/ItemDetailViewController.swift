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
    @IBOutlet weak var viewFromScrollViewDetail: UIView!
    @IBOutlet weak var imageOfItem: UIImageView!
    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var textViewTags: UITextView!
    
    var itemText = ""
    var itemDescription = ""
    var nameOfList = ""
    let realmManager = RealmManager()
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        item = realmManager.getItem(name: itemText)!
        itemLabel.text = itemText
        textViewDescription.text = itemDescription
        
        textViewDescription.isEditable = false
        textViewTags.isEditable = false
        
        let editedItem = realmManager.getItem(name: itemText)
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
            nameOfTag = (list?.tags[index!].nameOfTag)!
            if i == 0{
                textViewTags.text = "#" + nameOfTag
            }else{
                textViewTags.text = textViewTags.text + " #" + nameOfTag
            }
            
        }
        
        //nastavovanie farby pozadia
        if UserDefaults.standard.object(forKey: "darkMode") != nil{
            if UserDefaults.standard.bool(forKey: "darkMode") {
                self.view.backgroundColor = .black
                viewFromScrollViewDetail.backgroundColor = .black
                let str = item!.pathForImage
                if item!.pathForImage == ""{
                    imageOfItem.image = UIImage(named: "noImageDark")
                }else{
                    let imageUrl: URL = URL(fileURLWithPath: item!.pathForImage)
                    guard FileManager.default.fileExists(atPath: item!.pathForImage),
                        let imageData: Data = try? Data(contentsOf: imageUrl),
                        let image = UIImage(data: imageData) else {
                            return // No image found!
                    }
                    imageOfItem.image = image
                }
                textViewDescription.tintColor = .black
                
                textViewDescription.backgroundColor = .black
                textViewDescription.textColor = .white
                textViewTags.backgroundColor = .black
                textViewTags.textColor = .white
            }else{
                self.view.backgroundColor = .white
                viewFromScrollViewDetail.backgroundColor = .white
                if item!.pathForImage == ""{
                    imageOfItem.image = UIImage(named: "noImageLight")
                }else{
                    let imageUrl: URL = URL(fileURLWithPath: item!.pathForImage)
                    guard FileManager.default.fileExists(atPath: item!.pathForImage),
                        let imageData: Data = try? Data(contentsOf: imageUrl),
                        let image = UIImage(data: imageData) else {
                            return // No image found!
                    }
                    imageOfItem.image = image
                }
                
                textViewDescription.tintColor = .white
                    
                textViewDescription.backgroundColor = .white
                textViewDescription.textColor = .black
                textViewTags.backgroundColor = .white
                textViewTags.textColor = .black
            }
            
        }else{
            self.view.backgroundColor = .black
            viewFromScrollViewDetail.backgroundColor = .black
            if item!.pathForImage == ""{
                imageOfItem.image = UIImage(named: "noImageDark")
            }else{
                let imageUrl: URL = URL(fileURLWithPath: item!.pathForImage)
                guard FileManager.default.fileExists(atPath: item!.pathForImage),
                    let imageData: Data = try? Data(contentsOf: imageUrl),
                    let image = UIImage(data: imageData) else {
                        return // No image found!
                }
                imageOfItem.image = image
            }
            textViewDescription.tintColor = .black
            
            textViewDescription.backgroundColor = .black
            textViewDescription.textColor = .white
            textViewTags.backgroundColor = .black
            textViewTags.textColor = .white
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //nastavovanie farby pozadia
        if UserDefaults.standard.object(forKey: "darkMode") != nil{
            if UserDefaults.standard.bool(forKey: "darkMode") {
                self.view.backgroundColor = .black
                viewFromScrollViewDetail.backgroundColor = .black
                if item!.pathForImage == ""{
                    imageOfItem.image = UIImage(named: "noImageDark")
                }else{
                    let imageUrl: URL = URL(fileURLWithPath: item!.pathForImage)
                    guard FileManager.default.fileExists(atPath: item!.pathForImage),
                        let imageData: Data = try? Data(contentsOf: imageUrl),
                        let image = UIImage(data: imageData) else {
                            return // No image found!
                    }
                    imageOfItem.image = image
                }
                textViewDescription.backgroundColor = .black
                textViewDescription.textColor = .white
                textViewTags.backgroundColor = .black
                textViewTags.textColor = .white
            }else{
                self.view.backgroundColor = .white
                viewFromScrollViewDetail.backgroundColor = .white
                if item!.pathForImage == ""{
                    imageOfItem.image = UIImage(named: "noImageLight")
                }else{
                    let imageUrl: URL = URL(fileURLWithPath: item!.pathForImage)
                    guard FileManager.default.fileExists(atPath: item!.pathForImage),
                        let imageData: Data = try? Data(contentsOf: imageUrl),
                        let image = UIImage(data: imageData) else {
                            return // No image found!
                    }
                    imageOfItem.image = image
                }
                textViewDescription.backgroundColor = .white
                textViewDescription.textColor = .black
                textViewTags.backgroundColor = .white
                textViewTags.textColor = .black
            }
            
        }else{
            self.view.backgroundColor = .black
            viewFromScrollViewDetail.backgroundColor = .black
            if item!.pathForImage == ""{
                imageOfItem.image = UIImage(named: "noImageDark")
            }else{
                let imageUrl: URL = URL(fileURLWithPath: item!.pathForImage)
                guard FileManager.default.fileExists(atPath: item!.pathForImage),
                    let imageData: Data = try? Data(contentsOf: imageUrl),
                    let image = UIImage(data: imageData) else {
                        return // No image found!
                }
                imageOfItem.image = image
            }
            textViewDescription.backgroundColor = .black
            
            textViewDescription.textColor = .white
            textViewTags.backgroundColor = .black
            textViewTags.textColor = .white
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
            editItemViewController.itemDescription = itemDescription
            editItemViewController.editItem = true
            editItemViewController.nameOfList = nameOfList
        }
    }
}
