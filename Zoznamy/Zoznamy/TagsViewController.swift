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
        
        tableView.delegate = self
        tableView.dataSource = self
        item = realmManager.getItem(name: nameOfItem)
        listOfItems = realmManager.getList(name: nameOfList)
        
        //pridavanie tacidla Done pre vratenie
        //self.navigationItem.hidesBackButton = true
        //let newBackButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TagsViewController.back(sender:)))
        //self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    
    //kvoli pridaniu tlacidla pre Done
    /*@objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        
        //nemozem lebo dany prvok sa este ani nemusi vytvorit
        //realmManager.removeIndexTagsForItem(item: item!)
        for i in 0...((listOfItems?.tags.count)!)-1 {
            let tagCellIndexPath = NSIndexPath(row: i, section: 0)
            let cell = tableView.cellForRow(at: tagCellIndexPath as IndexPath)! as! TagCell
            if cell.buttonTagTicker.isSelected{
                //ak je zaciarknute v danej bunke tak jej index ulozi do pola
                //asi aj nepotrebne
                arrayOfChosenTags.append(i)
                //let intObj = IntegerObject()
                //intObj.value = i
                //realmManager.addIndexTagForItem(item: item!, index: intObj)
            }
        }
        
        _ = navigationController?.popViewController(animated: true)
    }*/
    
    //MARK: Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (listOfItems?.tags.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath) as! TagCell
        
        let tag = listOfItems!.tags[indexPath.row]
        cell.tagLabel.text = tag.nameOfTag
        if arrayOfChosenTags.contains(indexPath.row){
            cell.buttonTagTicker.isSelected = true
        }
        //cell.buttonTagTicker.
        
        let origImage = UIImage(named: "Image")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        cell.buttonTagTicker.setTitle("", for: .selected)
        cell.buttonTagTicker.setTitle("", for: .normal)
        cell.buttonTagTicker.setImage(tintedImage, for: .selected)
        
        let origImage2 = UIImage(named: "Image-1")
        let tintedImage2 = origImage2?.withRenderingMode(.alwaysTemplate)
        cell.buttonTagTicker.setImage(tintedImage2, for: .normal)
        if cell.buttonTagTicker.isSelected{
            cell.buttonTagTicker.tintColor = UIColor(red: 12.0/255.0, green: 230.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        }else{
            cell.buttonTagTicker.tintColor = .gray
        }
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewTagSegue"{
            let navViewController = segue.destination as! UINavigationController
            let addNewTagViewController = navViewController.viewControllers[0] as! AddNewTagViewController
            addNewTagViewController.tagName = 
        }
    }*/
    
    
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
    
    //
    @IBAction func donePressed(_ sender: Any) {
        arrayOfChosenTags.removeAll()
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
        }
    }
}
