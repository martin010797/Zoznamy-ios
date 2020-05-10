//
//  RealmManager.swift
//  Zoznamy
//
//  Created by Martin Kostelej on 20/07/2019.
//  Copyright © 2019 Martin Kostelej. All rights reserved.
//


//pre pracu s datami
//napriklad pridaj zoznam, pridaj prvok do zoznamu, uprav zoznam, uprav prvok, zmaz zoznam...
import RealmSwift

class RealmManager {
    
    func allLists() ->Results<Lists>{
        //inicializacia realmu
        let realm = try! Realm()
        
        let lists = realm.objects(Lists.self).sorted(byKeyPath: "date", ascending: false)
        return lists
    }
    
    //skusobne
    func getList(name: String) ->Lists?{
        let realm = try! Realm()
        //let lists = realm.objects(Lists.self)
        //let pocet = lists.count
        let lists = realm.objects(Lists.self).filter("name = %@", name)
        if lists.count > 0{
            return lists[0]
        }
        return nil
    }
    func getItem(name: String) ->Item?{
        let realm = try! Realm()
        
        let items = realm.objects(Item.self).filter("name = %@", name)
        let count = items.count
        if items.count > 0{
            //let name = items[0].name
            //let desc = items[0].text
            //let tags = items[0].IndexOfTags
            return items[0]
        }
        return nil
    }
    
    //skusobne
    func allItemsOfList(list: Lists) ->Results<Item>{
        let items = list.items.sorted(byKeyPath: "date", ascending: false)
        return items
    }
    
    //overovanie ci uz zoznam existuje
    //ak existuje tak ho vrati inak vrati nil
    func listDoesExists(list: Lists) -> Lists? {
        let realm = try! Realm()
        let lists = realm.objects(Lists.self).filter("name = %@", list.name)
        if lists.count > 0{
            return lists[0]
        }
        return nil
    }
    
    //skusobne
    //overuje ci existuje prvok v zozname
    func itemDoesExistsInList(item: Item, list: Lists) -> Item?{
        let realm = try! Realm()
        let lists = realm.objects(Lists.self).filter("name = %@", list.name)
        if lists.count == 0{
            //ak zoznam neexistuje
            return nil
        }else{
            let items = lists[0].items.filter("name = %@", item.name)
            //items = lists[0].items.filter("text = %@", item.text)
            //items = items.filter("text = %@", item.text)
            //let items = realm.objects(Item.self).filter("name = %@", item.name)
            if items.count > 0{
                //ak existuje uz prvok v zozname
                return items[0]
            }
            //ak prvok neexistuje v zozname
            return nil
        }
        
    }
    //overuje ci existuje prvok v zozname pokial sa nemenilo meno v editovani
    func itemDoesExistsInListSameName(item: Item, list: Lists, oldItem: Item) -> Item?{
        let realm = try! Realm()
        let lists = realm.objects(Lists.self).filter("name = %@", list.name)
        if lists.count == 0{
            //ak zoznam neexistuje
            return nil
        }else{
            var items = lists[0].items.filter("name = %@", item.name)
            //items = lists[0].items.filter("text = %@", item.text)
            items = items.filter("text = %@", item.text)
            //items = items.filter("date = %@", item.date)
            //let items = realm.objects(Item.self).filter("name = %@", item.name)
            if items.count > 0{
                //ak existuje uz prvok v zozname
                if items[0].date == oldItem.date{
                    return nil
                }else{
                    return items[0]
                }
            }
            //ak prvok neexistuje v zozname
            return nil
        }
        
    }
    
    
    
    //pridanie prvku do existujuceho zoznamu
    func appendItem(item: Item, forList list: Lists) {
        let realm = try! Realm()
        
        try! realm.write{
            //do pola items pridame prvok
            list.items.append(item)
        }
    }
    
    //priadnie zoznamu
    //ak uz zoznam existuje tak false
    //vyuzivam predchadzajucu funkciu na overovanie ci zoznam existuje
    func addList(list: Lists) ->Bool{
        let realm = try! Realm()
        if self.listDoesExists(list: list) != nil{
            return false
        }else{
            //ak neexistuje dany zoznam tak pridavame do databazy novy zoznam
            try! realm.write {
                realm.add(list)
            }
            return true
        }
    }
    
    func removeItem(item: Item, fromList list: Lists) -> Item?{
        let realm = try! Realm()
        
        var index = 0
        //overujeme ci dany zoznam vlastne existuje
        let listToUpdate = self.listDoesExists(list: list)
        if let itemToRemove = self.itemDoesExistsInList(item: item, list: list){
            index = listToUpdate!.items.index(of: itemToRemove)!
            
            try! realm.write {
                //vymazanie prvku zo zoznamu
                listToUpdate!.items.remove(at: index)
            }
            
            return itemToRemove
        }
        return nil
    }
    
    func updateItem(oldItem item: Item, toItem newItem: Item){
        let realm = try! Realm()
        
        //let meno = newItem.name
        //let meno2 = item.name
        try! realm.write {
            item.name = newItem.name
            item.text = newItem.text
            //nove odkomentovat a DOKONCIT
            item.pathForImage = newItem.pathForImage
        }
    }
    
    func updateList(oldList list: Lists, toList newList: Lists){
        let realm = try! Realm()
        
        try! realm.write {
            list.name = newList.name
        }
    }
    
    func deleteItem(item: Item) {
        let realm = try! Realm()
        
        try! realm.write {
            item.IndexOfTags.removeAll()
            realm.delete(item)
        }
    }
    
    func deleteList(list: Lists){
        let realm = try! Realm()
        
        if list.items.count == 0 {
            try! realm.write {
                realm.delete(list)
            }
        }else{
            while list.items.count > 0 {
                //let deletedItem = removeItem(item: list.items[0], fromList: list)!
                //deleteItem(item: deletedItem)
                let del = list.items[0]
                let meno = del.name
                deleteItem(item: list.items[0])
            }
            try! realm.write {
                list.tags.removeAll()
                realm.delete(list)
            }
        }
    }
    
    
    /*func itemDoesExistsInListSameName(item: Item, list: Lists) -> Item?{
     let realm = try! Realm()
     let lists = realm.objects(Lists.self).filter("name = %@", list.name)
     if lists.count == 0{
     //ak zoznam neexistuje
     return nil
     }else{
     var items = lists[0].items.filter("name = %@", item.name)
     //items = lists[0].items.filter("text = %@", item.text)
     items = items.filter("text = %@", item.text)
     //let items = realm.objects(Item.self).filter("name = %@", item.name)
     if items.count > 0{
     //ak existuje uz prvok v zozname
     return items[0]
     }
     //ak prvok neexistuje v zozname
     return nil
     }
     
     }*/
    func tagDoesExistsInList(tag: Tag, list: Lists) -> Tag?{
        let realm = try! Realm()
        let lists = realm.objects(Lists.self).filter("name = %@", list.name)
        if lists.count == 0{
            //ak neexistuje dany zoznam
            return nil
        }else{
            var tags = lists[0].tags.filter("nameOfTag = %@", tag.nameOfTag)
            if tags.count > 0{
                //ak existuje tag v zozname tak ho vrati
                return tags[0]
            }
            //ak tag neexistuje v zozname
            return nil
        }
    }
    func addNewTag(list: Lists, tag: Tag){
        let realm = try! Realm()
        
        try! realm.write {
            list.tags.append(tag)
        }
    }
    
    func removeIndexTagsForItem(item: Item){
        let realm = try! Realm()
        
        try! realm.write {
            item.IndexOfTags.removeAll()
        }
    }
    
    func addIndexTagForItem(item: Item, index: IntegerObject){
        let realm = try! Realm()
        
        try! realm.write {
            item.IndexOfTags.append(index)
        }
    }
    
    func deleteTag(list: Lists, indexOfTag: Int){
        let realm = try! Realm()
        try! realm.write {
            //vymazanie tagu zo zoznamu
            list.tags.remove(at: indexOfTag)
        }
        for i in 0..<list.items.count {
            let itemWithChangingIndexTags = list.items[i]
            let count = itemWithChangingIndexTags.IndexOfTags.count
            var deleteTag = false
            var indexOfDeletedTag = 0
            for j in 0..<count{
                if itemWithChangingIndexTags.IndexOfTags[j].value == indexOfTag{
                    deleteTag = true
                    indexOfDeletedTag = j
                }
                if itemWithChangingIndexTags.IndexOfTags[j].value > indexOfTag{
                    try! realm.write {
                        itemWithChangingIndexTags.IndexOfTags[j].value -= 1
                    }
                }
            }
            if deleteTag{
                try! realm.write {
                    itemWithChangingIndexTags.IndexOfTags.remove(at: indexOfDeletedTag)
                }
            }
        }
    }
    
    func filterByTag(arrayOfItems: Results<Item>, arrayOfIndexes: [Int]) -> Results<Item>{
        var query: String = ""
        var array: [String] = []
        arrayOfIndexes.forEach {
            array.append("ANY IndexOfTags.value = \($0)")
        }
        query = array.joined(separator: " OR ")
        
        let array1 = arrayOfItems.filter(query)
        
        return array1
    }
}
