//
//  TagsViewController.swift
//  Zoznamy
//
//  Created by Martin Kostelej on 27/08/2019.
//  Copyright © 2019 Martin Kostelej. All rights reserved.
//

import UIKit

class TagsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    
    var listOfItems: Lists?
    var item: Item?
    var nameOfItem = ""
    var nameOfList = ""
    let realmManager = RealmManager()
    
    var arrayOfChosenTags = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.object(forKey: "darkMode") != nil{
            if UserDefaults.standard.bool(forKey: "darkMode") {
                self.view.backgroundColor = .black
            }else{
                self.view.backgroundColor = .white
            }
        }else{
            self.view.backgroundColor = .black
        }
        
        self.title = "My tags"
        tableView.delegate = self
        tableView.dataSource = self
        item = realmManager.getItem(name: nameOfItem)
        listOfItems = realmManager.getList(name: nameOfList)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    //MARK: Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (listOfItems?.tags.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath) as! TagCell
        
        let tag = listOfItems!.tags[indexPath.row]
        cell.tagLabel.text = tag.nameOfTag
        if arrayOfChosenTags.contains(indexPath.row){
            let origImage = UIImage(named: "Image")
            let imageView = UIImageView(image: origImage)
            cell.accessoryView = imageView
            cell.tagIsSelected = true
        }else{
            if UserDefaults.standard.object(forKey: "darkMode") != nil{
                if UserDefaults.standard.bool(forKey: "darkMode") {
                    let origImage = UIImage(named: "tagNotSelectedDarkMode")
                    let imageView = UIImageView(image: origImage)
                    cell.accessoryView = imageView
                }else{
                    let origImage = UIImage(named: "Image-1")
                    let imageView = UIImageView(image: origImage)
                    cell.accessoryView = imageView
                }
            }else{
                let origImage = UIImage(named: "tagNotSelectedDarkMode")
                let imageView = UIImageView(image: origImage)
                cell.accessoryView = imageView
            }
            cell.tagIsSelected = false
        }
        
        return cell
    }
    
    //mazanie prvku
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            //let item = filteredItems![indexPath.row]
            let list = realmManager.getList(name: nameOfList)
            let index = indexPath.row
            realmManager.deleteTag(list: list!, indexOfTag: indexPath.row)
            //items = realmManager.allItemsOfList(list: listOfItems!)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            var removedIndex = -1
            for i in 0..<arrayOfChosenTags.count{
                if arrayOfChosenTags[i] == indexPath.row{
                    removedIndex = i
                }
                if arrayOfChosenTags[i] > indexPath.row{
                    arrayOfChosenTags[i] -= 1
                }
            }
            if removedIndex != -1{
                arrayOfChosenTags.remove(at: removedIndex)
            }
        }
    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! TagCell
        //cell?.accessoryType = .checkmark
        tableView.deselectRow(at: indexPath, animated: true)
        cell.tagIsSelected.toggle()
        if cell.tagIsSelected{
            let origImage = UIImage(named: "Image")
            let imageView = UIImageView(image: origImage)
            cell.accessoryView = imageView
            if arrayOfChosenTags.contains(indexPath.row) == false{
                arrayOfChosenTags.append(indexPath.row)
            }
        }else{
            if UserDefaults.standard.object(forKey: "darkMode") != nil{
                if UserDefaults.standard.bool(forKey: "darkMode") {
                    let origImage = UIImage(named: "tagNotSelectedDarkMode")
                    let imageView = UIImageView(image: origImage)
                    cell.accessoryView = imageView
                }else{
                    let origImage = UIImage(named: "Image-1")
                    let imageView = UIImageView(image: origImage)
                    cell.accessoryView = imageView
                }
            }else{
                let origImage = UIImage(named: "tagNotSelectedDarkMode")
                let imageView = UIImageView(image: origImage)
                cell.accessoryView = imageView
            }
            if arrayOfChosenTags.contains(indexPath.row){
                var indexRemovedTag = -1
                for i in 0..<arrayOfChosenTags.count{
                    let value = arrayOfChosenTags[i]
                    if value == indexPath.row{
                        indexRemovedTag = i
                    }
                }
                if indexRemovedTag != -1{
                    arrayOfChosenTags.remove(at: indexRemovedTag)
                }
            }
        }
    }
    
    @IBAction func addNewTag(_ sender: Any) {
        performSegue(withIdentifier: "addNewTagSegue", sender: self)
    }
    
    @IBAction func cancelAddingNewTag(segue: UIStoryboardSegue){
        print("Cancel")
    }
    
    @IBAction func saveNewTag(segue: UIStoryboardSegue){
        print("Save")
        if segue.identifier == "saveNewTagSegue"{
            let addNewTag = segue.source as! AddNewTagViewController
            //kontrola ci nazov nie je prazdny retazec
            if addNewTag.textFieldNewTag.text! == ""{
                return
            }
            let tag = Tag()
            tag.nameOfTag = addNewTag.textFieldNewTag.text!
            if realmManager.tagDoesExistsInList(tag: tag, list: listOfItems!) == nil{
                realmManager.addNewTag(list: listOfItems!, tag: tag)
            }
        }
    }
    
    //pada ked je viac tagov ako na jednej obrazovke
    @IBAction func donePressed(_ sender: Any) {
        /*arrayOfChosenTags.removeAll()
        for i in 0..<(listOfItems?.tags.count)! {
            let tagCellIndexPath = NSIndexPath(row: i, section: 0)
            let cell = tableView.cellForRow(at: tagCellIndexPath as IndexPath)! as! TagCell
            if cell.buttonTagTicker.isSelected{
                //ak je zaciarknute v danej bunke tak jej index ulozi do pola
                arrayOfChosenTags.append(i)
                //let intObj = IntegerObject()
                //intObj.value = i
                //realmManager.addIndexTagForItem(item: item!, index: intObj)
            }
        }*/
        //let array = arrayOfChosenTags
        //print("aa")
    }
}
