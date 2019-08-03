//
//  SecondViewController.swift
//  Zoznamy
//
//  Created by Martin Kostelej on 14/07/2019.
//  Copyright © 2019 Martin Kostelej. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    let onOffCellIdentifier = "onOffDarkModeCell"
    
    var darkModeOn = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getDarkModeStatus() -> Bool{
        return darkModeOn
    }

    //MARK: Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //ak nulty riadok tak zobrazi bunku pre dany identifikator
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "onOffDarkModeCell", for: indexPath)
            return cell
        }
        
        return UITableViewCell()
    }
    
    //aby neostavalo vysvetlene ked na nejaku moznost klikne
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func toggleDarkMode(_ sender: Any) {
        let toggleSwitch = sender as! UISwitch
        
        //ak je vypinac zapnuty
        
        if toggleSwitch.isOn{
            //nastavenie farby status barstyle pismen(cas, bateria...)
            //UIApplication().statusBarStyle = .lightContent
            //UIViewController preferredStatusBarStyle
            
            //nastavovanie navigacneho baru
            UINavigationBar.appearance().barTintColor = UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0)
            //nadpisy na navigacnych baroch
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)]
            //navratova sipka
            UINavigationBar.appearance().tintColor = .white
            //tlacidla na navigacnom bare
            UIBarButtonItem.appearance().tintColor = .white
            
            //spodny bar pre vyberanie obrazoviek
            UITabBar.appearance().barTintColor = UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0)
            //aktivny prvok
            UITabBar.appearance().tintColor = .white
            
            //pozadie text fieldu pri pridavani alebo upravovani zoznamov a prvkov
            UITextField.appearance().backgroundColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.0)
            //farba textu v text fielde
            UITextField.appearance().textColor = .white
            
            //tabulky
            UITableView.appearance().backgroundColor = .black
            //medzery medzi cells v tabulke
            UITableView.appearance().separatorColor = .black
            UITableViewCell.appearance().backgroundColor = .black
            
            //popisky
            UILabel.appearance().textColor = .white
            
            
            /*let cellForDarkModeIndex = NSIndexPath(row: 0, section: 0)
            self.tableView.cellForRow(at: cellForDarkModeIndex as IndexPath)?.backgroundColor = .black
            self.tableView.cellForRow(at: cellForDarkModeIndex as IndexPath)?.textLabel!.textColor = .white
            self.tableView.backgroundColor = .black
            self.tableView.separatorColor = .black*/
            
        }else{
            //nastavenie farby status barstyle pismen(cas, bateria...)
            //UIApplication().statusBarStyle = .default
            //UIViewController preferredStatusBarStyle
            
            //nastavovanie navigacneho baru
            UINavigationBar.appearance().barTintColor = UIColor(red: 62.0/255.0, green: 158.0/255.0, blue: 242.0/255.0, alpha: 1.0)
            //nadpisy na navigacnych baroch
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)]
            //navratova sipka
            UINavigationBar.appearance().tintColor = .black
            //tlacidla na navigacnom bare
            UIBarButtonItem.appearance().tintColor = .black
            
            //spodny bar pre vyberanie obrazoviek
            UITabBar.appearance().barTintColor = UIColor(red: 63.0/255.0, green: 158.0/255.0, blue: 242.0/255.0, alpha: 1.0)
            //aktivny prvok
            UITabBar.appearance().tintColor = .white
            //UITabBar.appearance().backgroundColor = .black
            
            //pozadie text fieldu pri pridavani alebo upravovani zoznamov a prvkov
            UITextField.appearance().backgroundColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.0)
            //farba textu v text fielde
            UITextField.appearance().textColor = .black
            
            //tabulky
            UITableView.appearance().backgroundColor = .white
            //medzery medzi cells v tabulke
            UITableView.appearance().separatorColor = .white
            UITableViewCell.appearance().backgroundColor = .white
            
            //popisky
            UILabel.appearance().textColor = .black
            
            /*let cellForDarkModeIndex = NSIndexPath(row: 0, section: 0)
            self.tableView.cellForRow(at: cellForDarkModeIndex as IndexPath)?.backgroundColor = .white
            self.tableView.cellForRow(at: cellForDarkModeIndex as IndexPath)?.textLabel!.textColor = .black
            self.tableView.backgroundColor = .white
            self.tableView.separatorColor = .white*/
        }
    }
}

