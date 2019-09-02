//
//  TagCell.swift
//  Zoznamy
//
//  Created by Martin Kostelej on 27/08/2019.
//  Copyright © 2019 Martin Kostelej. All rights reserved.
//

import UIKit

class TagCell: UITableViewCell {
    
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var buttonTagTicker: UIButton!
    //var selection = true
    
    @IBAction func tappedTicker(_ sender: Any) {
        buttonTagTicker.isSelected = !buttonTagTicker.isSelected
        if buttonTagTicker.isSelected{
            buttonTagTicker.tintColor = UIColor(red: 12.0/255.0, green: 230.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        }else{
            buttonTagTicker.tintColor = .gray
        }
    }
}
