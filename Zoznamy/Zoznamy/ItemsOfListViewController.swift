//
//  ItemsOfListViewController.swift
//  Zoznamy
//
//  Created by Martin Kostelej on 14/07/2019.
//  Copyright © 2019 Martin Kostelej. All rights reserved.
//

import UIKit
import RealmSwift

class ItemsOfListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //premenna na uchovavanie prvkov ktore zobrazujeme v tabulke
    var items: Results<Item>?
    let realmManager = RealmManager()
    
    var listOfItems: Lists?
    var listText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = listText
        
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableView.automaticDimension
        
        //hadam v poriadku
        listOfItems = realmManager.getList(name: listText)
        items = realmManager.allItemsOfList(list: listOfItems!)
    }
    
    @IBAction func editItem(_ sender: Any) {
        performSegue(withIdentifier: "editListSegue", sender: self)
    }
    
    //MARK: Table View Data Source
    
    //kolko riadkov bude v tabulke resp. v sekcii tabulky
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (items?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        let item = items![indexPath.row]
        cell.itemLabel.text = item.name
        return cell
    }
    
    //mazanie prvku
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let item = items![indexPath.row]
            realmManager.deleteItem(item: item)
            items = realmManager.allItemsOfList(list: listOfItems!)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //aby sme mohli upravovat prvky(mazat)
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK: Table View Delegate
    
    //vykona sa ked klikneme na prvok v zozname
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ItemCell
        performSegue(withIdentifier: "showItem", sender: cell)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editListSegue"{
            let navViewController = segue.destination as! UINavigationController
            let editListViewController = navViewController.viewControllers[0] as! AddNewListViewController
            
            editListViewController.listText = listText
            editListViewController.editList = true
        }
        if let cell = sender as? ItemCell{
            let indexPath = tableView.indexPath(for: cell)
            
            if segue.identifier == "showItem" {
                let detailViewController = segue.destination as! ItemDetailViewController
                let item = items![indexPath!.row]
                detailViewController.itemText = item.name
            }
        }
        
    }
    
    //pridavanie noveho prvku do zoznamu
    @IBAction func addNewItem(_ sender: Any) {
        performSegue(withIdentifier: "addNewItem", sender: self)
    }
    
    //zrusenie
    @IBAction func cancelAddingNewItem(segue: UIStoryboardSegue){
        print("cancel")
    }
    
    //ulozenie
    @IBAction func saveNewItem(segue: UIStoryboardSegue){
        if segue.identifier == "saveNewItemSegue"{
            let addNewItem = segue.source as! addNewItemViewController
            let item = Item()
            item.name = addNewItem.itemTextField.text!
            
            if addNewItem.editItem{
                let oldItem = addNewItem.item
                let itemsFiltered = items!.filter("name = %@", oldItem.name)
                let vysledok: Item
                if itemsFiltered.count > 0{
                    vysledok = itemsFiltered[0]
                }else{
                    vysledok = oldItem
                }
                if realmManager.itemDoesExistsInList(item: item, list: listOfItems!) == nil{
                    //zavola funkciu na update zo stareho na novy
                    realmManager.updateItem(oldItem: vysledok, toItem: item)
                }else{
                    print("Prvok v zozname uz existuje")
                }
            }else{
                if realmManager.itemDoesExistsInList(item: item, list: listOfItems!) == nil{
                    //ak prvok este v zozname neexistuje tak ho prida
                    realmManager.appendItem(item: item, forList: listOfItems!)
                }
            }
            
            tableView.reloadData()
        }
    }
    
  
}
