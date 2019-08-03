//
//  FirstViewController.swift
//  Zoznamy
//
//  Created by Martin Kostelej on 14/07/2019.
//  Copyright © 2019 Martin Kostelej. All rights reserved.
//

import UIKit
import RealmSwift

class ListsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //premenna na uchovavanie zoznamov ktore zobrazujeme v tabulke
    var lists: Results<Lists>?
    let realmManager = RealmManager()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableView.automaticDimension
        
        //nacitanie dat do lists
        lists = realmManager.allLists()
    }
    
/*override var preferredStatusBarStyle: UIStatusBarStyle {
 return .lightContent
 }
 
 override func viewDidAppear(_ animated: Bool) {
 navigationController?.navigationBar.barStyle = .black
 }*/
    
    //MARK: Table View Data Source
    
    //kolko riadkov bude v tabulke resp. v sekcii tabulky
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //vracia pre pocet zoznamov
        return (lists?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListCell
        let list = lists![indexPath.row]
        cell.listLabel.text = list.name
        //ked by som chcel pristupit k prvku zo zoznamu tak
        //list.items[0].name
        //tieto dve mozno ani nie je treba
        //cell.setNeedsUpdateConstraints()
        //cell.updateConstraintsIfNeeded()
        return cell
    }
    
    //mazanie prvku
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let list = lists![indexPath.row]
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
    }
    
    //MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? ListCell{
            let indexPath = tableView.indexPath(for: cell)
            
            if segue.identifier == "showListItems" {
                let listViewController = segue.destination as! ItemsOfListViewController
                let list = lists![indexPath!.row]
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

