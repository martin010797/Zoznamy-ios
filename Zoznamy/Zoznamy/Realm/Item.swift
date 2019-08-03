//
//  Item.swift
//  Zoznamy
//
//  Created by Martin Kostelej on 20/07/2019.
//  Copyright © 2019 Martin Kostelej. All rights reserved.
//

import RealmSwift

class Item: Object {
    
    
    @objc dynamic var name = ""
    @objc dynamic var date = NSDate()
    /*var list: [Lists]{
        return LinkingObjects(fromType: Lists.self, property: "items")
    }*/
    var list = LinkingObjects(fromType: Lists.self, property: "items")
}
