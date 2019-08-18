//
//  FirstViewController.swift
//  Zoznamy
//
//  Created by Martin Kostelej on 14/07/2019.
//  Copyright © 2019 Martin Kostelej. All rights reserved.
//

import UIKit
import RealmSwift

class ListsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
    //premenna na uchovavanie zoznamov ktore zobrazujeme v tabulke
    var lists: Results<Lists>?
    let realmManager = RealmManager()
    var filteredLists: Results<Lists>?
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableView.automaticDimension
        
        //nacitanie dat do lists
        lists = realmManager.allLists()
        
        setUpSearchBar()
        //filtered lists pouzivam na zobrazovanie do table view aj kvoli filtrovaniu cez vyhladavanie
        filteredLists = lists
        sortLists()
        
        searchBar.placeholder = "Search List by Name"
        //navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //nejaky bug pri nastavovani searchbaru na vrchu obrazovky a pristupovanie k nemu vo viewwillappear
        if UserDefaults.standard.object(forKey: "darkMode") != nil{
            if UserDefaults.standard.bool(forKey: "darkMode") {
                searchBar.backgroundColor = .gray
                searchBar.barTintColor = .black
                searchBar.tintColor = .white
            }else{
                searchBar.backgroundColor = .gray
                searchBar.barTintColor = .white
                searchBar.tintColor = UIColor(red: 62.0/255.0, green: 158.0/255.0, blue: 242.0/255.0, alpha: 1.0)
            }
        }else{
            searchBar.backgroundColor = .gray
            searchBar.barTintColor = .black
            searchBar.tintColor = .white
        }
    }
    
    private func sortLists(){
        switch searchBar.selectedScopeButtonIndex {
        case 0:
            filteredLists = filteredLists?.sorted(byKeyPath: "name", ascending: true)
        case 1:
            filteredLists = filteredLists?.sorted(byKeyPath: "date", ascending: false)
        default:
            break
        }
        tableView.reloadData()
    }
    
    // MARK: Search Bar Delegate
    private func setUpSearchBar(){
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            filteredLists = lists
            sortLists()
            return
        }
        //[c] sa dava aby aj z databazy boli udaje lowercased
        filteredLists = lists?.filter("name contains[c] %@", searchBar.text?.lowercased())
        sortLists()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            filteredLists = filteredLists?.sorted(byKeyPath: "name", ascending: true)
        case 1:
            filteredLists = filteredLists?.sorted(byKeyPath: "date", ascending: false)
        default:
            break
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    //MARK: Table View Data Source
    
    //kolko riadkov bude v tabulke resp. v sekcii tabulky
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //vracia pre pocet zoznamov
        //return (lists?.count)!
        return (filteredLists?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListCell
        //let list = lists![indexPath.row]
        let list = filteredLists![indexPath.row]
        cell.listLabel.text = list.name
        return cell
    }
    
    //mazanie prvku
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            //let list = lists![indexPath.row]
            let list = filteredLists![indexPath.row]
            realmManager.deleteList(list: list)
            lists = realmManager.allLists()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //aby sme mohli upravovat prvky(mazat)
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK: Table View Delegate
    
    //vykona sa ked klikneme na zoznam
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ListCell
        performSegue(withIdentifier: "showListItems", sender: cell)
        tableView.deselectRow(at: indexPath, animated: true)
        searchBar.endEditing(true)
    }
    
    //MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? ListCell{
            let indexPath = tableView.indexPath(for: cell)
            
            if segue.identifier == "showListItems" {
                let listViewController = segue.destination as! ItemsOfListViewController
                //let list = lists![indexPath!.row]
                let list = filteredLists![indexPath!.row]
                listViewController.listText = list.name
            }
        }
        
    }

    //funkcia pre pridavanie noveho zoznamu
    @IBAction func showAddNewListViewController(_ sender: Any) {
        performSegue(withIdentifier: "addNewList", sender: self)
    }
    
    //funkcia pre zrusenie pridavania
    @IBAction func cancelAddingNewList(segue: UIStoryboardSegue){
        print("Cancel")
    }
    
    //funkcia pre pridanie zoznamu
    @IBAction func saveNewList(segue: UIStoryboardSegue){
        //overime identifikator pre segue kde stlacame Save na pridavani zoznamu
        if segue.identifier == "saveNewListSegue" {
            //vytvorenie instanice z kade chceme data preniest
            let addNewListViewController = segue.source as! AddNewListViewController
            let list = Lists()
            list.name = addNewListViewController.listTextView.text!
            if addNewListViewController.editList{
                let oldList = addNewListViewController.list
                let listsFiltered = lists!.filter("name = %@", oldList.name)
                let finalOldList: Lists
                if listsFiltered.count > 0{
                    finalOldList = listsFiltered[0]
                }else{
                    finalOldList = oldList
                }
                if realmManager.listDoesExists(list: list) == nil{
                    realmManager.updateList(oldList: finalOldList, toList: list)
                }else{
                    print("Zoznam uz existuje")
                }
            }else{
                if realmManager.addList(list: list){
                    print("Zoznam vytvoreny")
                }else{
                    print("Zoznam uz existuje")
                }
            }
            
            tableView.reloadData()
        }
    }
    
    
    
}

