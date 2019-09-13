//
//  FilterByTagsViewController.swift
//  Zoznamy
//
//  Created by Martin Kostelej on 09/09/2019.
//  Copyright © 2019 Martin Kostelej. All rights reserved.
//

import UIKit

class FilterByTagsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var list: Lists?
    var nameOfList = ""
    let realmManager = RealmManager()
    var arrayOfChosenTags = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = "Filter by Tags"
        list = realmManager.getList(name: nameOfList)
    }
    
    // MARK: Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (list?.tags.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterTagCell", for: indexPath) as! FilterByTagCell
        //cell.tagLabel.text = "Labelik"
        let tag = list!.tags[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FilterByTagCell
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
}
