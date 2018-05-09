//
//  ZajisteniPrijmuTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 09.11.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class ZajisteniPrijmuTableViewController: UITableViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {
    
    var mesicniPrijem = Int()
    var mesicniNaklady = Int()
    
    var koeficient = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Zajištění příjmů"
        
        let b = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(self.sendEmail))
        self.navigationItem.rightBarButtonItem = b
        
        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage()
        imageView.image = image.background(height: UIScreen.main.bounds.height)
        tableView.backgroundView = imageView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
        
    }
    
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0 {
            
            return 1
            
        } else if section == 1 {
            
            return 2
        
        } else {
            
            return 3
            
        }
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "pracovniPomer") as! ZajisteniPrijmuCell
            
            cell.pracovniPomer.text = ZajisteniPrijmuStruct.pracovniPomer
            
            return cell
        
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "mesicniPrijem") as! ZajisteniPrijmuCell
                
                cell.mesicniPrijemTextField.delegate = self
                cell.mesicniPrijemTextField.tag = 0
                
                return cell

            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "mesicniNaklady") as! ZajisteniPrijmuCell
                
                cell.mesicniNakladyTextField.delegate = self
                cell.mesicniNakladyTextField.tag = 1
                
                return cell
            }
        
        } else {
            
            var vysledek = Int()
            
            if ZajisteniPrijmuStruct.pracovniPomer == "Zaměstnanec" {
                
                koeficient = 2
                vysledek = mesicniPrijem/koeficient
                
            } else {
                
                koeficient = 1
                vysledek = mesicniPrijem/koeficient
            }
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "zajisteniPrijmuNaMesic") as! ZajisteniPrijmuCell
                
                if mesicniPrijem > 0 {
                    
                    cell.zajisteniPrijmuNaMesic.text = vysledek.currencyFormattingWithSymbol(currencySymbol: "Kč")
                    cell.zajisteniPrijmuNaMesic.textColor = UIColor.black
                
                } else {
                    
                    cell.zajisteniPrijmuNaMesic.text = "15 000 Kč"
                    cell.zajisteniPrijmuNaMesic.textColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
                }
                
                return cell
                
            } else if indexPath.row == 1 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "denniZajisteniPrijmu") as! ZajisteniPrijmuCell
                
                if mesicniPrijem > 0 {
                    
                    vysledek = vysledek/30
                    cell.denniZajisteniPrijmu.text = vysledek.currencyFormattingWithSymbol(currencySymbol: "Kč")
                    cell.denniZajisteniPrijmu.textColor = UIColor.black
                
                } else {
                    
                    cell.denniZajisteniPrijmu.text = "300 Kč"
                    cell.denniZajisteniPrijmu.textColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
                }
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "denniZajisteniNakladu") as! ZajisteniPrijmuCell
                
                if mesicniNaklady > 0 {
                    
                    let vysledek1 = mesicniNaklady/30
                    cell.denniZajisteniNakladu.text = vysledek1.currencyFormattingWithSymbol(currencySymbol: "Kč")
                    cell.denniZajisteniNakladu.textColor = UIColor.black
                
                } else {
                    
                    cell.denniZajisteniNakladu.text = "666 Kč"
                    cell.denniZajisteniNakladu.textColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
                }
                
                return cell
            }
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 2 {
            
            return "Výstupy"
            
        }
        
        return nil
    }
        
    //MARK: - textfield formatting
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var result = true
        let prospectiveText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if string.count > 0 {
            
            let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789").inverted
            let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
            var resultingStringLengthIsLegal = Bool()
            
            resultingStringLengthIsLegal = prospectiveText.count <= 7
            
            let scanner = Scanner.localizedScanner(with: prospectiveText) as! Scanner
            let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.isAtEnd
            
            result = replacementStringIsLegal && resultingStringLengthIsLegal && resultingTextIsNumeric
            
        }
        
        
        return result
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.text = textField.text?.replacingOccurrences(of: "Kč", with: "")//stringByReplacingOccurrencesOfString("Kč", withString: "")
        textField.text = textField.text?.condenseWhitespace()
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 0 {
            
            mesicniPrijem = Int((textField.text! as NSString).intValue)
            
            if mesicniPrijem > 0 {
                
                textField.text = mesicniPrijem.currencyFormattingWithSymbol(currencySymbol: "Kč")
            
            }
        
        } else {
            
            mesicniNaklady = Int((textField.text! as NSString).intValue)
            
            if mesicniNaklady > 0 {
                
                textField.text = mesicniNaklady.currencyFormattingWithSymbol(currencySymbol: "Kč")
            }
        }
    
        tableView.reloadData()
    }
    
    //MARK: - press return key to go to other textfield
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTage=textField.tag+1;
        // Try to find next responder
        let nextResponder=textField.superview?.superview?.superview?.viewWithTag(nextTage) as UIResponder?
        
        if (nextResponder != nil){
            // Found next responder, so set it.
            nextResponder?.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        return false // We do not want UITextField to insert line-breaks.
    }

    
    //MARK: - toolbar & button to hide keyboard
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        // Create a button bar for the number pad
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        
        // Setup the buttons to be put in the system.
        let item1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let item2 = UIBarButtonItem(image: UIImage(named: "down.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.endEditingNow))
        let toolbarButtons = [item1, item2]
        
        //Put the buttons into the ToolBar and display the tool bar
        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
        textField.inputAccessoryView = keyboardDoneButtonView
        
        return true
    }

    
    //MARK: - share graph via email
    
    @objc func sendEmail() {
        
        if mesicniNaklady != 0 && mesicniPrijem != 0 {
            
            let mailComposeViewController = configuredMailComposeViewController()
            
            if MFMailComposeViewController.canSendMail() {
            
                self.present(mailComposeViewController, animated: true, completion: nil)
            
            } else {
            
                self.showSendMailErrorAlert()
            
            }
        
        } else {
            
            let warning = UIAlertController(title: "Chybějící údaje", message: "Prosím vyplňte chybějící údaje.", preferredStyle: UIAlertControllerStyle.alert)
            
            warning.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(warning, animated: true, completion: nil)
            
        }
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setSubject("Zajištění příjmů")
        
        let a = mesicniPrijem.currencyFormattingWithSymbol(currencySymbol: "Kč")
        let b = mesicniNaklady.currencyFormattingWithSymbol(currencySymbol: "Kč")
        
        let c = (mesicniPrijem/2).currencyFormattingWithSymbol(currencySymbol: "Kč")
        let d = (mesicniPrijem/30/2).currencyFormattingWithSymbol(currencySymbol: "Kč")
        let e = (mesicniNaklady/30).currencyFormattingWithSymbol(currencySymbol: "Kč")
        
        mailComposerVC.setMessageBody("<h2>Zajištění příjmů</h2><p><b>Měsíční příjmy:</b> \(a) </p><p><b>Měsíční náklady:</b> \(b) </p><p><b>Zajištění příjmů na měsíc:</b>\(c)</p><p><b>Denní zajištění příjmů:</b> \(d) </p><p><b>Děnní zajištěnní nákladů:</b> \(e) </p>", isHTML: true)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Nelze poslat email", message: "Email se nepodařilo odeslat! Zkontrolujte nastavení svého telefonu a zkuste to znovu.", delegate: self, cancelButtonTitle: "Ok")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismiss(animated: true, completion: nil)
    }

    


}
