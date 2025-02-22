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
    @IBOutlet weak var filterByTagsButton: UIButton!
    @IBOutlet weak var cancelFilteringButton: UIButton!
    @IBOutlet weak var goUpButton: UIButton!
    
    //premenna pre index kvoli zobrazovaniu nahodneho prvku
    var randomItemNumberVar: Int = 0
    
    //premenna na uchovavanie prvkov ktore zobrazujeme v tabulke
    var items: Results<Item>?
    let realmManager = RealmManager()
    var filteredItems: Results<Item>?
    
    var listOfItems: Lists?
    var listText = ""
    
    var arrayOfChosenTagsForFiltering = [Int]()
    var filteringIsActive = false
    var filteredItemsByTags: Results<Item>?
    var allFilteredItemsByChosenTags: Results<Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //cancelFilteringButton.isHidden = true
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
        tableView.reloadData()
        if UserDefaults.standard.object(forKey: "darkMode") != nil{
            if UserDefaults.standard.bool(forKey: "darkMode") {
                let cancelFilterImage = UIImage(named: "cancelFilterDarkMode")
                let tintedCancelFilterImage = cancelFilterImage?.withRenderingMode(.alwaysOriginal)
                cancelFilteringButton.setTitle("", for: .normal)
                cancelFilteringButton.setImage(tintedCancelFilterImage, for: .normal)
                let goUpImage = UIImage(named: "goUpDarkMode")
                let tintedeGoUpImgae = goUpImage?.withRenderingMode(.alwaysOriginal)
                goUpButton.setTitle("", for: .normal)
                goUpButton.setImage(tintedeGoUpImgae, for: .normal)
                let filterImage = UIImage(named: "filterByTagsDarkMode")
                let tintedFilterImaged = filterImage?.withRenderingMode(.alwaysOriginal)
                filterByTagsButton.setTitle("", for: .normal)
                filterByTagsButton.setImage(tintedFilterImaged, for: .normal)
                //farba random buttonu
                //randomButton.tintColor = .white
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
                let cancelFilterImage = UIImage(named: "cancelFilterLightMode")
                let tintedCancelFilterImage = cancelFilterImage?.withRenderingMode(.alwaysOriginal)
                cancelFilteringButton.setTitle("", for: .normal)
                cancelFilteringButton.setImage(tintedCancelFilterImage, for: .normal)
                let goUpImage = UIImage(named: "goUpLightMode")
                let tintedeGoUpImgae = goUpImage?.withRenderingMode(.alwaysOriginal)
                goUpButton.setTitle("", for: .normal)
                goUpButton.setImage(tintedeGoUpImgae, for: .normal)
                let filterImage = UIImage(named: "filterByTagsLightMode")
                let tintedFilterImaged = filterImage?.withRenderingMode(.alwaysOriginal)
                filterByTagsButton.setTitle("", for: .normal)
                filterByTagsButton.setImage(tintedFilterImaged, for: .normal)
                //random button
                //randomButton.tintColor = .black
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
            let cancelFilterImage = UIImage(named: "cancelFilterDarkMode")
            let tintedCancelFilterImage = cancelFilterImage?.withRenderingMode(.alwaysOriginal)
            cancelFilteringButton.setTitle("", for: .normal)
            cancelFilteringButton.setImage(tintedCancelFilterImage, for: .normal)
            let goUpImage = UIImage(named: "goUpDarkMode")
            let tintedeGoUpImgae = goUpImage?.withRenderingMode(.alwaysOriginal)
            goUpButton.setTitle("", for: .normal)
            goUpButton.setImage(tintedeGoUpImgae, for: .normal)
            let filterImage = UIImage(named: "filterByTagsDarkMode")
            let tintedFilterImaged = filterImage?.withRenderingMode(.alwaysOriginal)
            filterByTagsButton.setTitle("", for: .normal)
            filterByTagsButton.setImage(tintedFilterImaged, for: .normal)
            //randomButton.tintColor = .white
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
            if filteringIsActive{
                filteredItemsByTags = filteredItemsByTags?.sorted(byKeyPath: "name", ascending: true)
            }else{
                filteredItems = filteredItems?.sorted(byKeyPath: "name", ascending: true)
            }
        case 1:
            if filteringIsActive{
                filteredItemsByTags = filteredItemsByTags?.sorted(byKeyPath: "date", ascending: false)
            }else{
                filteredItems = filteredItems?.sorted(byKeyPath: "date", ascending: false)
            }
            //filteredItems = filteredItems?.sorted(byKeyPath: "date", ascending: false)
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
            filteredItemsByTags = allFilteredItemsByChosenTags
            sortItems()
            return
        }
        if filteringIsActive{
            filteredItemsByTags = allFilteredItemsByChosenTags?.filter("name contains[c] %@", searchBar.text?.lowercased())
        }else{
            //[c] sa dava aby aj z databazy boli udaje lowercased
            filteredItems = items?.filter("name contains[c] %@", searchBar.text?.lowercased())
        }
        sortItems()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            if filteringIsActive{
                filteredItemsByTags = filteredItemsByTags?.sorted(byKeyPath: "name", ascending: true)
            }else{
                filteredItems = filteredItems?.sorted(byKeyPath: "name", ascending: true)
            }
            //filteredItems = filteredItems?.sorted(byKeyPath: "name", ascending: true)
        case 1:
            if filteringIsActive{
                filteredItemsByTags = filteredItemsByTags?.sorted(byKeyPath: "date", ascending: false)
            }else{
                filteredItems = filteredItems?.sorted(byKeyPath: "date", ascending: false)
            }
            //filteredItems = filteredItems?.sorted(byKeyPath: "date", ascending: false)
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
            /*
             if Maťko.loves.Lucka == true
             do (boztek.na.licko)
             */
        if filteringIsActive{
            if (filteredItemsByTags?.count)! > 0{
                let randomNumber = Int.random(in: 0..<(filteredItemsByTags?.count)!)
                randomItemNumberVar = randomNumber
                performSegue(withIdentifier: "showItem", sender: filteredItemsByTags![0] as Item)
            }
        }else{
            if (filteredItems?.count)! > 0{
                let randomNumber = Int.random(in: 0..<(filteredItems?.count)!)
                randomItemNumberVar = randomNumber
                performSegue(withIdentifier: "showItem", sender: filteredItems![0] as Item)
            }
        }
        
    }
    
    //MARK: Table View Data Source
    
    //kolko riadkov bude v tabulke resp. v sekcii tabulky
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return (items?.count)!
        if filteringIsActive{
            return (filteredItemsByTags?.count)!
        }else{
            return (filteredItems?.count)!
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        //let item = items![indexPath.row]
        let item: Item
        if filteringIsActive{
            item = filteredItemsByTags![indexPath.row]
        }else{
            item = filteredItems![indexPath.row]
        }
        
        //cell.itemLabel.text = item.name
        cell.itemTitle.text = item.name
        
        if (item.text == "") || (item.text == " "){
            cell.itemSubtitle.text = "No description"
        }else{
            cell.itemSubtitle.text = item.text
        }
        
        if UserDefaults.standard.object(forKey: "darkMode") != nil{
            if UserDefaults.standard.bool(forKey: "darkMode") {
                cell.itemImage.image = UIImage(named: "noImageDark")
            }else{
                cell.itemImage.image = UIImage(named: "noImageLight")
            }
        }else{
            cell.itemImage.image = UIImage(named: "noImageDark")
        }
        /*
        cell.itemImage.layer.borderWidth = 1
        cell.itemImage.layer.masksToBounds = false
        cell.itemImage.layer.borderColor = UIColor.black.cgColor
        cell.itemImage.layer.cornerRadius = cell.itemImage.frame.height/2
        cell.itemImage.clipsToBounds = true*/
        return cell
    }
    
    //mazanie prvku
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            //let item = items![indexPath.row]
            let item: Item
            if filteringIsActive{
                item = filteredItemsByTags![indexPath.row]
            }else{
                item = filteredItems![indexPath.row]
            }
            //let item = filteredItems![indexPath.row]
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
        
        if segue.identifier == "chooseTagsForFilterSegue"{
            let navViewController = segue.destination as! UINavigationController
            let chooseTagsViewController = navViewController.viewControllers[0] as! FilterByTagsViewController
            chooseTagsViewController.nameOfList = listText
            chooseTagsViewController.arrayOfChosenTags = arrayOfChosenTagsForFiltering
        }
        if segue.identifier == "addNewItem"{
            let navViewController = segue.destination as! UINavigationController
            let addNewItemViewController = navViewController.viewControllers[0] as! addNewItemViewController
            addNewItemViewController.nameOfList = listText
        }
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
                //let item = filteredItems![indexPath!.row]
                let item: Item
                if filteringIsActive{
                    item = filteredItemsByTags![indexPath!.row]
                }else{
                    item = filteredItems![indexPath!.row]
                }
                detailViewController.itemText = item.name
                detailViewController.nameOfList = listText
                if (item.text == "") || (item.text == " "){
                    detailViewController.itemDescription = "No description"
                }else{
                    detailViewController.itemDescription = item.text
                }
                
                
            }
        }
        //vyuziva sa na posielanie dat pokial vyberame nahodny prvok
        if sender is Item{
            let detailViewController = segue.destination as! ItemDetailViewController
            //let item = items![randomItemNumberVar]
            let item: Item
            if filteringIsActive{
                item = filteredItemsByTags![randomItemNumberVar]
            }else{
                item = filteredItems![randomItemNumberVar]
            }
            //let item = filteredItems![randomItemNumberVar]
            detailViewController.itemText = item.name
            detailViewController.nameOfList = listText
            if (item.text == "") || (item.text == " "){
                detailViewController.itemDescription = "No description"
            }else{
                detailViewController.itemDescription = item.text
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
            //kontrola ci nazov nie je prazdny retazec
            if addNewItem.itemTextField.text! == ""{
                return
            }
            let item = Item()
            item.name = addNewItem.itemTextField.text!
            item.text = addNewItem.descriptionForItem.text!
            //nove odkomentovat a DOKONCIT
            item.pathForImage = addNewItem.pathOfImage
            
            if addNewItem.editItem{
                let oldItem = addNewItem.item
                let itemsFiltered = items!.filter("name = %@", oldItem.name)
                let vysledok: Item
                if itemsFiltered.count > 0{
                    vysledok = itemsFiltered[0]
                }else{
                    vysledok = oldItem
                }
                
                //rozdelovanie na to ci sa meni meno kvoli tomu aby som nezmenil na prvok ktory uz existuje
                //a aby som v opacnom pripade mohol editovat prvok
                //vytvorene dve jemne pozmenene funkcie v realm manageri
                if oldItem.name == item.name{
                    if realmManager.itemDoesExistsInListSameName(item: item, list: listOfItems!, oldItem: oldItem) == nil{
                        if addNewItem.chosenImage{
                            if vysledok.pathForImage != ""{
                                let urlEditedImage: URL = URL(fileURLWithPath: vysledok.pathForImage)
                                try? FileManager.default.removeItem(at: urlEditedImage)
                            }
                            let imageUrl: URL = URL(fileURLWithPath: addNewItem.pathOfImage)
                            try? addNewItem.imageView.image!.pngData()?.write(to: imageUrl)
                        }
                        realmManager.updateItem(oldItem: vysledok, toItem: item)
                        //rozrobene ukladanie obrazka odkomentovat a DOKONCIT
                        //ak by bolo v poriadku tak by sa dalo ku kazdemu updatu alebo ukladaniu v tejto fkcii
                        /*if addNewItem.chosenImage{
                         zmazat povodny obrazok
                         let imageUrl: URL = URL(fileURLWithPath: addNewItem.pathOfImage)
                         try? addNewItem.imageView.image!.pngData()?.write(to: imageUrl)
                         }*/
                        realmManager.removeIndexTagsForItem(item: vysledok)
                        for i in 0..<addNewItem.arrayOfChosenTags.count{
                            let intObj = IntegerObject()
                            intObj.value = addNewItem.arrayOfChosenTags[i]
                            //let arrayValues = addNewItem.arrayOfChosenTags
                            realmManager.addIndexTagForItem(item: vysledok, index: intObj)
                        }
                        
                    }else{
                        print("Prvok v zozname uz existuje")
                    }
                }else{
                    if realmManager.itemDoesExistsInList(item: item, list: listOfItems!) == nil{
                        if addNewItem.chosenImage{
                            if vysledok.pathForImage != ""{
                                let urlEditedImage: URL = URL(fileURLWithPath: vysledok.pathForImage)
                                try? FileManager.default.removeItem(at: urlEditedImage)
                            }
                            let imageUrl: URL = URL(fileURLWithPath: addNewItem.pathOfImage)
                            try? addNewItem.imageView.image!.pngData()?.write(to: imageUrl)
                        }
                        //zavola funkciu na update zo stareho na novy
                        realmManager.updateItem(oldItem: vysledok, toItem: item)
                        realmManager.removeIndexTagsForItem(item: vysledok)
                        for i in 0..<addNewItem.arrayOfChosenTags.count{
                            
                            let intObj = IntegerObject()
                            intObj.value = addNewItem.arrayOfChosenTags[i]
                            //let arrayValues = addNewItem.arrayOfChosenTags
                            realmManager.addIndexTagForItem(item: vysledok, index: intObj)
                        }
                    }else{
                        print("Prvok v zozname uz existuje")
                    }
                }

            }else{
                if realmManager.itemDoesExistsInList(item: item, list: listOfItems!) == nil{
                    //ak prvok este v zozname neexistuje tak ho prida
                    realmManager.appendItem(item: item, forList: listOfItems!)
                    for i in 0..<addNewItem.arrayOfChosenTags.count{
                        let intObj = IntegerObject()
                        intObj.value = addNewItem.arrayOfChosenTags[i]
                        realmManager.addIndexTagForItem(item: item, index: intObj)
                    }
                    //rozrobene ukladanie obrazka odkomentovat a DOKONCIT
                    //ak by bolo v poriadku tak by sa dalo ku kazdemu updatu alebo ukladaniu v tejto fkcii
                    if addNewItem.chosenImage{
                        let imageUrl: URL = URL(fileURLWithPath: addNewItem.pathOfImage)
                        try? addNewItem.imageView.image!.pngData()?.write(to: imageUrl)
                     }
                    
                }
            }
            
            tableView.reloadData()
        }
    }
    
    @IBAction func scrollToTop(_ sender: Any) {
        if items?.count != 0{
            let indPath = NSIndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: indPath as IndexPath, at: .middle, animated: true)
        }
        
    }
    
    @IBAction func cancelChoosingTagsForFilter(segue: UIStoryboardSegue){
        if segue.identifier == "cancelFilteringSegue"{
            print("Cancel filtering")
            arrayOfChosenTagsForFiltering.removeAll()
            filteringIsActive = false
            tableView.reloadData()
        }
    }
    
    @IBAction func filterByChosenTags(segue: UIStoryboardSegue){
        if segue.identifier == "filterByTagsSegue"{
            let filterByTagsController = segue.source as! FilterByTagsViewController
            //ak nie je zvoleny ziadny tag
            if filterByTagsController.arrayOfChosenTags.count == 0 || items?.count == 0 || items == nil{
                //nie je co filtrovat
                filteringIsActive = false
                arrayOfChosenTagsForFiltering = filterByTagsController.arrayOfChosenTags
                return
            }else{
                filteringIsActive = true
                arrayOfChosenTagsForFiltering = filterByTagsController.arrayOfChosenTags
                filteredItemsByTags = realmManager.filterByTag(arrayOfItems: items!, arrayOfIndexes: arrayOfChosenTagsForFiltering)
                allFilteredItemsByChosenTags = filteredItemsByTags
                searchBar.text = ""
                searchBar.endEditing(true)
                sortItems()
                tableView.reloadData()
                if filteredItemsByTags?.count != 0 && filteredItemsByTags != nil{
                    scrollToTop(self)
                }
            }
            
        }
    }
    
    @IBAction func chooseTagsForFilter(_ sender: Any) {
        performSegue(withIdentifier: "chooseTagsForFilterSegue", sender: self)
    }
    
    
    @IBAction func cancelFilteringByTags(_ sender: Any) {
        //premazanie pola na pamätania filtrovanych tagov
        arrayOfChosenTagsForFiltering.removeAll()
        //realmManager.setFalseForFilteringInItems(arrayOfItems: items!)
        filteringIsActive = false
        sortItems()
        tableView.reloadData()
    }
    
}
