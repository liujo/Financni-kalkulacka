
//
//  UverTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 29.10.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import UIKit

class UverTableViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let cellLabels = ["Ano", "Ne"]
    
    let numberOfChoices = 85
    var choices: [Int] = []
    
    var checkedCell = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if udajeKlienta.maUver {
            
            checkedCell = cellLabels.index(of: "Ano")!
        
        } else {
            
            checkedCell = cellLabels.index(of: "Ne")!
        }

        self.title = "Úvěr"
        
        for i in 0 ..< numberOfChoices {
            
            choices.append(2015 + i)
            
        }
        
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

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        if udajeKlienta.maUver == false {
            
            return 1
        
        } else {
            
            return 3
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0 {
            
            return 2
        
        } else if section == 1 {
            
            return 3
        
        }
        
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
            
            cell.textLabel?.text = cellLabels[indexPath.row]
            
            if checkedCell == indexPath.row {
            
                cell.accessoryType = .checkmark
            
            }
            
            return cell
        
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "dluznaCastka") as! Uver
                
                if let castka = udajeKlienta.dluznaCastka, castka > 0 {
                    
                    cell.dluznaCastka.text = udajeKlienta.dluznaCastka!.currencyFormattingWithSymbol(currencySymbol: "Kč")
                    
                }
                
                cell.dluznaCastka.delegate = self
                cell.dluznaCastka.tag = 1
                
                return cell
                
            } else if indexPath.row == 1 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "rokFixace") as! Uver
                
                cell.pickerView.dataSource = self
                cell.pickerView.delegate = self
                cell.pickerView.selectRow(choices.index(of: udajeKlienta.rokFixace)!, inComponent: 0, animated: true)
                return cell
                
            } else if indexPath.row == 2 {
            
                let cell = tableView.dequeueReusableCell(withIdentifier: "uver") as! Uver
                
                if udajeKlienta.mesicniSplatkaUveru! > 0 {
                    
                    cell.uverCastka.text = udajeKlienta.mesicniSplatkaUveru!.currencyFormattingWithSymbol(currencySymbol: "Kč")
                    
                }
                
                cell.uverCastka.delegate = self
                cell.uverCastka.tag = 2
                
                return cell
            
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "slovnicekPojmu") as! Uver
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            
            if indexPath.row != checkedCell {
                
                let tappedCell = tableView.cellForRow(at: indexPath as IndexPath)
                tappedCell?.accessoryType = .checkmark
                tableView.cellForRow(at: IndexPath(row: checkedCell, section: 0))?.accessoryType = .none
                
                checkedCell = indexPath.row
            }
            
            if cellLabels[checkedCell] == "Ano" {
                
                udajeKlienta.maUver = true
                
                tableView.reloadData()
                
            } else {
                
                udajeKlienta.maUver = false
                
                udajeKlienta.mesicniSplatkaUveru = Int()
                
                tableView.reloadData()
            }
        }
        
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
       
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            
            if indexPath.row == 0 || indexPath.row == 2 {
                
                return 44
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        

        return UITableViewAutomaticDimension
    
    }
    
    
    //MARK: - pickerView methods
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return choices.count
    
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(choices[row])"
    
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        udajeKlienta.rokFixace = choices[row]
        
    }
    
    //MARK: - textField formatting
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField.text != "" {
        
            textField.text = textField.text?.chopSuffix(count: 2).condenseWhitespace()
            
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField.tag == 2 {
        
            udajeKlienta.mesicniSplatkaUveru = Int((textField.text! as NSString).intValue)
            
            if let splatka = udajeKlienta.mesicniSplatkaUveru, splatka > 0 {
            
                textField.text = udajeKlienta.mesicniSplatkaUveru!.currencyFormattingWithSymbol(currencySymbol: "Kč")
            
            }
        
        } else {
            
            udajeKlienta.dluznaCastka = Int((textField.text! as NSString).intValue)
            
            if let castka = udajeKlienta.dluznaCastka, castka > 0 {

                textField.text = udajeKlienta.dluznaCastka!.currencyFormattingWithSymbol(currencySymbol: "Kč")
                
            }
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var result = true
        let prospectiveText = (textField.text! as NSString).replacingCharacters(in: range, with: string)

            
        if string.count > 0 {
                
            let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789").inverted
            let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil

            let resultingStringLengthIsLegal = prospectiveText.count <= 10
                
            let scanner = Scanner.localizedScanner(with: prospectiveText) as! Scanner
            let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.isAtEnd
                
            result = replacementStringIsLegal && resultingStringLengthIsLegal && resultingTextIsNumeric
                
        }

        return result
        
    }
    
    //MARK: - hideKeyboardToolbar
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        let toolbar = UIToolbar()
        textField.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true
    }
    
    

}
