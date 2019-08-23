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
    
    var itemText = ""
    var itemDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemLabel.text = itemText
        textViewDescription.text = itemDescription
        
        textViewDescription.isEditable = false
        
        //nastavovanie farby pozadia
        if UserDefaults.standard.object(forKey: "darkMode") != nil{
            if UserDefaults.standard.bool(forKey: "darkMode") {
                self.view.backgroundColor = .black
                viewFromScrollViewDetail.backgroundColor = .black
                imageOfItem.image = UIImage(named: "noImageDark")
                textViewDescription.backgroundColor = .black
                textViewDescription.textColor = .white
            }else{
                self.view.backgroundColor = .white
                viewFromScrollViewDetail.backgroundColor = .white
                imageOfItem.image = UIImage(named: "noImageLight")
                textViewDescription.backgroundColor = .white
                textViewDescription.textColor = .black
            }
            
        }else{
            self.view.backgroundColor = .black
            viewFromScrollViewDetail.backgroundColor = .black
            imageOfItem.image = UIImage(named: "noImageDark")
            textViewDescription.backgroundColor = .black
            textViewDescription.textColor = .white
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //nastavovanie farby pozadia
        if UserDefaults.standard.object(forKey: "darkMode") != nil{
            if UserDefaults.standard.bool(forKey: "darkMode") {
                self.view.backgroundColor = .black
                viewFromScrollViewDetail.backgroundColor = .black
                imageOfItem.image = UIImage(named: "noImageDark")
                textViewDescription.backgroundColor = .black
                textViewDescription.textColor = .white
            }else{
                self.view.backgroundColor = .white
                viewFromScrollViewDetail.backgroundColor = .white
                imageOfItem.image = UIImage(named: "noImageLight")
                textViewDescription.backgroundColor = .white
                textViewDescription.textColor = .black
            }
            
        }else{
            self.view.backgroundColor = .black
            viewFromScrollViewDetail.backgroundColor = .black
            imageOfItem.image = UIImage(named: "noImageDark")
            textViewDescription.backgroundColor = .black
            textViewDescription.textColor = .white
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
        }
    }
}
