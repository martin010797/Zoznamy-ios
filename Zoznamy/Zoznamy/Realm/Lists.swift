//
//  List.swift
//  Zoznamy
//
//  Created by Martin Kostelej on 20/07/2019.
//  Copyright © 2019 Martin Kostelej. All rights reserved.
//

import RealmSwift

class Lists: Object{
    
    @objc dynamic var name = ""
    //datum pridania
    @objc dynamic var date = NSDate()
    let items = List<Item>()
    let tags = List<Tag>()
}
