//
//  ItemsOfListViewController.swift
//  Zoznamy
//
//  Created by Martin Kostelej on 14/07/2019.
//  Copyright © 2019 Martin Kostelej. All rights reserved.
//

import UIKit
import RealmSwift

class ItemsOfListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var randomButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //premenna pre index kvoli zobrazovaniu nahodneho prvku
    var randomItemNumberVar: Int = 0
    
    //premenna na uchovavanie prvkov ktore zobrazujeme v tabulke
    var items: Results<Item>?
    let realmManager = RealmManager()
    var filteredItems: Results<Item>?
    
    var listOfItems: Lists?
    var listText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = listText
        
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableView.automaticDimension
        
        listOfItems = realmManager.getList(name: listText)
        items = realmManager.allItemsOfList(list: listOfItems!)
        
        setUpSearchBar()
        filteredItems = items
        
        sortItems()
        searchBar.placeholder = "Search Item by Name"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: "darkMode") != nil{
            if UserDefaults.standard.bool(forKey: "darkMode") {
                //farba random buttonu
                randomButton.tintColor = .white
                randomButton.backgroundColor = .black
                randomButton.setTitle("", for: .normal)
                let origImage = UIImage(named: "random")
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                randomButton.setImage(tintedImage, for: .normal)
                randomButton.tintColor = .white
                //farba search baru
                searchBar.backgroundColor = .gray
                searchBar.barTintColor = .black
                searchBar.tintColor = .white
                
                self.view.backgroundColor = .black
            }else{
                //random button
                randomButton.tintColor = .black
                randomButton.backgroundColor = .white
                randomButton.setTitle("", for: .normal)
                let origImage = UIImage(named: "random")
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                randomButton.setImage(tintedImage, for: .normal)
                randomButton.tintColor = .black
                
                //farba search baru
                searchBar.backgroundColor = .gray
                searchBar.barTintColor = .white
                searchBar.tintColor = UIColor(red: 62.0/255.0, green: 158.0/255.0, blue: 242.0/255.0, alpha: 1.0)
                
                self.view.backgroundColor = .white
            }
            
        }else{
            randomButton.tintColor = .white
            randomButton.backgroundColor = .black
            randomButton.setTitle("", for: .normal)
            let origImage = UIImage(named: "random")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            randomButton.setImage(tintedImage, for: .normal)
            randomButton.tintColor = .white
            
            //farba search baru
            searchBar.backgroundColor = .gray
            searchBar.barTintColor = .black
            searchBar.tintColor = .white
            
            self.view.backgroundColor = .black
        }
    }
    
    func sortItems(){
        switch searchBar.selectedScopeButtonIndex {
        case 0:
            filteredItems = filteredItems?.sorted(byKeyPath: "name", ascending: true)
        case 1:
            filteredItems = filteredItems?.sorted(byKeyPath: "date", ascending: false)
        default:
            break
        }
        tableView.reloadData()
    }
    
    @IBAction func editItem(_ sender: Any) {
        performSegue(withIdentifier: "editListSegue", sender: self)
    }
    
    // MARK: Search Bar Delegate
    private func setUpSearchBar(){
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            filteredItems = items
            sortItems()
            return
        }
        //[c] sa dava aby aj z databazy boli udaje lowercased
        filteredItems = items?.filter("name contains[c] %@", searchBar.text?.lowercased())
        sortItems()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            filteredItems = filteredItems?.sorted(byKeyPath: "name", ascending: true)
        case 1:
            filteredItems = filteredItems?.sorted(byKeyPath: "date", ascending: false)
        default:
            break
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //ked sa stlaci vyhladavanie skrije sa klavesnica
        searchBar.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //pri zascrollovani sa skryje klavesnica
        searchBar.endEditing(true)
    }
    
    @IBAction func randomItemOfList(_ sender: Any) {
        
        /*if (items?.count)! > 0{
            /*
             if Maťko.loves.Lucka == true
             do (boztek.na.licko)
             */
            let randomNumber = Int.random(in: 0..<(items?.count)!)
            randomItemNumberVar = randomNumber
            performSegue(withIdentifier: "showItem", sender: items![0] as Item)
        }*/
        if (filteredItems?.count)! > 0{
            let randomNumber = Int.random(in: 0..<(filteredItems?.count)!)
            randomItemNumberVar = randomNumber
            performSegue(withIdentifier: "showItem", sender: filteredItems![0] as Item)
        }
    }
    
    //MARK: Table View Data Source
    
    //kolko riadkov bude v tabulke resp. v sekcii tabulky
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return (items?.count)!
        return (filteredItems?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        //let item = items![indexPath.row]
        let item = filteredItems![indexPath.row]
        cell.itemLabel.text = item.name
        return cell
    }
    
    //mazanie prvku
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            //let item = items![indexPath.row]
            let item = filteredItems![indexPath.row]
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
        searchBar.endEditing(true)
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
                //let item = items![indexPath!.row]
                let item = filteredItems![indexPath!.row]
                detailViewController.itemText = item.name
                
                
            }
        }
        //vyuziva sa na posielanie dat pokial vyberame nahodny prvok
        if sender is Item{
            let detailViewController = segue.destination as! ItemDetailViewController
            //let item = items![randomItemNumberVar]
            let item = filteredItems![randomItemNumberVar]
            detailViewController.itemText = item.name
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
