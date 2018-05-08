//
//  VlastniCiNajemTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 02.11.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import UIKit

class VlastniCiNajemTableViewController: UITableViewController, UITextFieldDelegate {
    
    var cellLabels = ["Vlastní", "Nájemní"]
    var checkedCell = Int()
    var udaj = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Bydlení"
        checkedCell = cellLabels.index(of: udajeKlienta.vlastniCiNajemnni)!
        
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage()
        imageView.image = image.background(height: UIScreen.main.bounds.height)
        tableView.backgroundView = imageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        if udajeKlienta.vlastniCiNajemnni == "Vlastní" {
            
            return 1
            
        } else {
        
            return 2
        
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0 {
            
            return 2
        
        } else {
            
            return 1
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
            
            cell.textLabel?.text = cellLabels[indexPath.row]
            
            if checkedCell == indexPath.row {
                
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            
            return cell
        
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "najemne") as! VlastniCiNajemni
            
            if udajeKlienta.najemne > 0 {
                
                cell.najemne.text = udajeKlienta.najemne.currencyFormattingWithSymbol(currencySymbol: "Kč")
                
            }
            
            cell.najemne.delegate = self
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            
            if indexPath.row != checkedCell {
                
                let tappedCell = tableView.cellForRow(at: indexPath as IndexPath)
                
                tappedCell?.accessoryType = .checkmark
                tableView.cellForRow(at: IndexPath(row: checkedCell, section: 0))?.accessoryType = .none
                checkedCell = indexPath.row
            }
            
            if cellLabels[checkedCell] == "Vlastní" {
                
                udajeKlienta.vlastniCiNajemnni = "Vlastní"
                udajeKlienta.najemne = Int()
                
            } else {
                
                udajeKlienta.vlastniCiNajemnni = "Nájemní"
                
            }
            
            tableView.reloadData()
            
            tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    
        }
        
        
    }
    
    //MARK: - textField formatting
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField.text != "" {
        
            textField.text = textField.text?.chopSuffix(2).condenseWhitespace()
            
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        udajeKlienta.najemne = Int((textField.text! as NSString).intValue)
        
        if udajeKlienta.najemne > 0 {
            
            textField.text = udajeKlienta.najemne.currencyFormattingWithSymbol("Kč")
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var result = true
        let prospectiveText = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        
        if string.characters.count > 0 {
            
            let disallowedCharacterSet = NSCharacterSet(charactersInString: "0123456789").invertedSet
            let replacementStringIsLegal = string.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
            
            let resultingStringLengthIsLegal = prospectiveText.characters.count <= 6
            
            let scanner:NSScanner = NSScanner.localizedScannerWithString(prospectiveText) as! NSScanner
            let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.atEnd
            
            result = replacementStringIsLegal && resultingStringLengthIsLegal && resultingTextIsNumeric
            
        }
        
        return result
        
    }
    
    //MARK: - schovat klavesnici
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        let toolbar = UIToolbar()
        textField.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true
    }
    
    

    
}
