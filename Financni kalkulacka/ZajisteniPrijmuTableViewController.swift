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
        
        let b = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "sendEmail")
        self.navigationItem.rightBarButtonItem = b
        
        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage()
        imageView.image = image.background(UIScreen.mainScreen().bounds.height)
        tableView.backgroundView = imageView
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0 {
            
            return 1
            
        } else if section == 1 {
            
            return 2
        
        } else {
            
            return 3
            
        }
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("pracovniPomer") as! ZajisteniPrijmuCell
            
            cell.pracovniPomer.text = ZajisteniPrijmuStruct.pracovniPomer
            
            return cell
        
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("mesicniPrijem") as! ZajisteniPrijmuCell
                
                cell.mesicniPrijemTextField.delegate = self
                cell.mesicniPrijemTextField.tag = 0
                
                return cell

            } else {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("mesicniNaklady") as! ZajisteniPrijmuCell
                
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
                
                let cell = tableView.dequeueReusableCellWithIdentifier("zajisteniPrijmuNaMesic") as! ZajisteniPrijmuCell
                
                if mesicniPrijem > 0 {
                    
                    cell.zajisteniPrijmuNaMesic.text = vysledek.currencyFormattingWithSymbol("Kč")
                    cell.zajisteniPrijmuNaMesic.textColor = UIColor.blackColor()
                
                } else {
                    
                    cell.zajisteniPrijmuNaMesic.text = "15 000 Kč"
                    cell.zajisteniPrijmuNaMesic.textColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
                }
                
                return cell
                
            } else if indexPath.row == 1 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("denniZajisteniPrijmu") as! ZajisteniPrijmuCell
                
                if mesicniPrijem > 0 {
                    
                    vysledek = vysledek/30
                    cell.denniZajisteniPrijmu.text = vysledek.currencyFormattingWithSymbol("Kč")
                    cell.denniZajisteniPrijmu.textColor = UIColor.blackColor()
                
                } else {
                    
                    cell.denniZajisteniPrijmu.text = "300 Kč"
                    cell.denniZajisteniPrijmu.textColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
                }
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("denniZajisteniNakladu") as! ZajisteniPrijmuCell
                
                if mesicniNaklady > 0 {
                    
                    let vysledek1 = mesicniNaklady/30
                    cell.denniZajisteniNakladu.text = vysledek1.currencyFormattingWithSymbol("Kč")
                    cell.denniZajisteniNakladu.textColor = UIColor.blackColor()
                
                } else {
                    
                    cell.denniZajisteniNakladu.text = "666 Kč"
                    cell.denniZajisteniNakladu.textColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
                }
                
                return cell
            }
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 2 {
            
            return "Výstupy"
            
        }
        
        return nil
    }
        
    //MARK: - textfield formatting
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var result = true
        let prospectiveText = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if string.characters.count > 0 {
            
            let disallowedCharacterSet = NSCharacterSet(charactersInString: "0123456789").invertedSet
            let replacementStringIsLegal = string.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
            var resultingStringLengthIsLegal = Bool()
            
            resultingStringLengthIsLegal = prospectiveText.characters.count <= 7
            
            let scanner:NSScanner = NSScanner.localizedScannerWithString(prospectiveText) as! NSScanner
            let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.atEnd
            
            result = replacementStringIsLegal && resultingStringLengthIsLegal && resultingTextIsNumeric
            
        }
        
        
        return result
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        textField.text = textField.text?.stringByReplacingOccurrencesOfString("Kč", withString: "")
        textField.text = textField.text?.condenseWhitespace()
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField.tag == 0 {
            
            mesicniPrijem = Int((textField.text! as NSString).intValue)
            
            if mesicniPrijem > 0 {
                
                textField.text = mesicniPrijem.currencyFormattingWithSymbol("Kč")
            
            }
        
        } else {
            
            mesicniNaklady = Int((textField.text! as NSString).intValue)
            
            if mesicniNaklady > 0 {
                
                textField.text = mesicniNaklady.currencyFormattingWithSymbol("Kč")
            }
        }
    
        tableView.reloadData()
    }
    
    //MARK: - press return key to go to other textfield
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let nextTage=textField.tag+1;
        // Try to find next responder
        let nextResponder=textField.superview?.superview?.superview?.viewWithTag(nextTage) as UIResponder!
        
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
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        
        // Create a button bar for the number pad
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        
        // Setup the buttons to be put in the system.
        let item1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let item2 = UIBarButtonItem(image: UIImage(named: "down.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("endEditingNow"))
        let toolbarButtons = [item1, item2]
        
        //Put the buttons into the ToolBar and display the tool bar
        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
        textField.inputAccessoryView = keyboardDoneButtonView
        
        return true
    }

    
    //MARK: - share graph via email
    
    func sendEmail() {
        
        if mesicniNaklady != 0 && mesicniPrijem != 0 {
            
            let mailComposeViewController = configuredMailComposeViewController()
            
            if MFMailComposeViewController.canSendMail() {
            
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            
            } else {
            
                self.showSendMailErrorAlert()
            
            }
        
        } else {
            
            let warning = UIAlertController(title: "Chybějící údaje", message: "Prosím vyplňte chybějící údaje.", preferredStyle: UIAlertControllerStyle.Alert)
            
            warning.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(warning, animated: true, completion: nil)
            
        }
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setSubject("Zajištění příjmů")
        
        let a = mesicniPrijem.currencyFormattingWithSymbol("Kč")
        let b = mesicniNaklady.currencyFormattingWithSymbol("Kč")
        
        let c = (mesicniPrijem/2).currencyFormattingWithSymbol("Kč")
        let d = (mesicniPrijem/30/2).currencyFormattingWithSymbol("Kč")
        let e = (mesicniNaklady/30).currencyFormattingWithSymbol("Kč")
        
        mailComposerVC.setMessageBody("<h2>Zajištění příjmů</h2><p><b>Měsíční příjmy:</b> \(a) </p><p><b>Měsíční náklady:</b> \(b) </p><p><b>Zajištění příjmů na měsíc:</b>\(c)</p><p><b>Denní zajištění příjmů:</b> \(d) </p><p><b>Děnní zajištěnní nákladů:</b> \(e) </p>", isHTML: true)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Nelze poslat email", message: "Email se nepodařilo odeslat! Zkontrolujte nastavení svého telefonu a zkuste to znovu.", delegate: self, cancelButtonTitle: "Ok")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    


}
