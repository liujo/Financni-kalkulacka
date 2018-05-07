//
//  ZabezpeceniPrijmuTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 29.10.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import UIKit

class ZabezpeceniPrijmuTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var selectedRow = Int()
    var int = 0
    
    var isClientSegue = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backItem = UIBarButtonItem(title: "Zpět", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        let forwardButton = UIBarButtonItem(image: UIImage(named: "forward.png"), style: .Plain, target: self, action: #selector(ZabezpeceniPrijmuTableViewController.forward))
        let backwardButton = UIBarButtonItem(image: UIImage(named: "backward.png"), style: .Plain, target: self, action: #selector(ZabezpeceniPrijmuTableViewController.backward))
        navigationItem.setRightBarButtonItems([forwardButton, backwardButton], animated: true)
        
        self.title = "Zabezpečení příjmů"
        
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage()
        imageView.image = image.background(UIScreen.mainScreen().bounds.height)
        tableView.backgroundView = imageView
        
        if udajeKlienta.rodinnyStav != "Svobodný" {
            
            int = 1
            
        } else {
            
            int = 0
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if udajeKlienta.chceResitZajisteniPrijmu == true {
            
            vypocetZajisteni(true)
            
            if int == 1 {
                
                vypocetZajisteni(false)
            }
            
        }
        
        tableView.reloadData()

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        endEditingNow()
            
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        if udajeKlienta.chceResitZajisteniPrijmu == true {
        
            if int == 0 {
                
                return 5
                
            } else {
                
                return 6
            }
        
        } else {
            
            return 1
        
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if udajeKlienta.chceResitZajisteniPrijmu == true {
        
            if int == 0 {
                
                if section == 1 {
                    
                    return 5
                    
                } else {
                    
                    return 1
                    
                }
            
            } else {
                
                if section == 2 || section == 1 {
                    
                    return 5
                    
                } else {
                    
                    return 1
                    
                }
            }
        
        }
            
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("chceResit") as! ChceResitZabezpeceniPrijmu
            
            cell.switcher.addTarget(self, action: #selector(ZabezpeceniPrijmuTableViewController.chceResitSwitch(_:)), forControlEvents: .ValueChanged)
            
            if udajeKlienta.chceResitZajisteniPrijmu == true {
                
                cell.switcher.on = true
                
            } else {
                
                cell.switcher.on = false
            }
            
            return cell
            
        } else if indexPath.section == 1 {
            
           if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("pracovniPomer") as! PracovniPomer
            
                cell.pracovniPomer.text = udajeKlienta.pracovniPomer
                
                return cell
            
           } else if indexPath.row == 1 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("prijem") as! Prijmy
                
                cell.prijem.tag = 1
                cell.prijem.delegate = self
            
                if udajeKlienta.prijmy > 0 {
            
                    cell.prijem.text = udajeKlienta.prijmy!.currencyFormattingWithSymbol("Kč")
            
                }
            
                return cell
            
            } else if indexPath.row == 2 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("vydaje") as! Vydaje
                
                cell.vydaje.tag = 2
                cell.vydaje.delegate = self
            
                if udajeKlienta.vydaje > 0 {
                    
                    cell.vydaje.text = udajeKlienta.vydaje!.currencyFormattingWithSymbol("Kč")
                
                }
            
                return cell
            
            } else if indexPath.row == 3 {
            
                let cell = tableView.dequeueReusableCellWithIdentifier("denniPrijem") as! Prijmy
            
                if udajeKlienta.denniPrijmy > 0 {
                
                    cell.denniPrijem.textColor = UIColor.blackColor()
                    cell.denniPrijem.text = udajeKlienta.denniPrijmy!.currencyFormattingWithSymbol("Kč")
                
                } else {
                
                    cell.denniPrijem.textColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1)
                    cell.denniPrijem.text = "583 Kč"
                
                }
            
                return cell
            
            } else {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("denniVydaje") as! Vydaje
            
                if udajeKlienta.denniVydaje > 0 {
                
                    cell.denniVydaje.textColor = UIColor.blackColor()
                    cell.denniVydaje.text = udajeKlienta.denniVydaje!.currencyFormattingWithSymbol("Kč")
                
                } else {
                
                    cell.denniVydaje.textColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1)
                    cell.denniVydaje.text = "666 Kč"
                
                }
            
                return cell
            
            }
        
        } else if indexPath.section == 2 + int {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("uver") as! Uver
            
            if udajeKlienta.mesicniSplatkaUveru > 0 && udajeKlienta.maUver == true {
                
                let castka = udajeKlienta.mesicniSplatkaUveru!.currencyFormattingWithSymbol("Kč")
                
                cell.uver.text = "\(castka) měsíčně"
                
            } else {
                
                cell.uver.text = "Ne"
                
            }
            
            return cell
            
        } else if indexPath.section == 3 + int {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("zabezpeceniPrijmu") as! ZabezpeceniPrijmu
            
            cell.zabezpeceniPrijmu.tag = 3
            cell.zabezpeceniPrijmu.delegate = self
            
            if udajeKlienta.zajisteniPrijmuCastka > 0 {
                
                cell.zabezpeceniPrijmu.text = udajeKlienta.zajisteniPrijmuCastka!.currencyFormattingWithSymbol("Kč")
            }
            
            return cell
            
        } else if indexPath.section == 4 + int {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("poznamky") as! ZabezpeceniPrijmuPoznamky
            
            cell.zabezpeceniPrijmuPoznamky.tag = 7
            cell.zabezpeceniPrijmuPoznamky.delegate = self
            cell.zabezpeceniPrijmuPoznamky.text = udajeKlienta.zajisteniPrijmuPoznamky
            
            return cell
            
        } else {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("pracovniPomer") as! PracovniPomer
                
                cell.pracovniPomer.text = udajeKlienta.pracovniPomerPartner
                
                return cell
                
            } else if indexPath.row == 1 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("prijem") as! Prijmy
                
                cell.prijem.tag = 4
                cell.prijem.delegate = self
                
                if udajeKlienta.prijmyPartner > 0 {
                    
                    cell.prijem.text = udajeKlienta.prijmyPartner!.currencyFormattingWithSymbol("Kč")
                    
                }
                
                return cell
                
            } else if indexPath.row == 2 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("vydaje") as! Vydaje
                
                cell.vydaje.tag = 5
                cell.vydaje.delegate = self
                
                if udajeKlienta.vydajePartner > 0 {
                    
                    cell.vydaje.text = udajeKlienta.vydajePartner!.currencyFormattingWithSymbol("Kč")
                    
                }
                
                return cell
                
            } else if indexPath.row == 3 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("denniPrijem") as! Prijmy
                
                if udajeKlienta.denniPrijmyPartner > 0 {
                    
                    cell.denniPrijem.textColor = UIColor.blackColor()
                    cell.denniPrijem.text = udajeKlienta.denniPrijmyPartner!.currencyFormattingWithSymbol("Kč")
                    
                } else {
                    
                    cell.denniPrijem.textColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1)
                    cell.denniPrijem.text = "583 Kč"
                    
                }
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("denniVydaje") as! Vydaje
                
                if udajeKlienta.denniVydajePartner > 0 {
                    
                    cell.denniVydaje.textColor = UIColor.blackColor()
                    cell.denniVydaje.text = udajeKlienta.denniVydajePartner!.currencyFormattingWithSymbol("Kč")
                    
                } else {
                    
                    cell.denniVydaje.textColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1)
                    cell.denniVydaje.text = "666 Kč"
                    
                }
                
                return cell
                
            }
        }
    }
        
        
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 1 {
            
            return "Klient"
        
        } else if section == 2 + int {
            
            return "Úvěr"
        
        } else if section == 3 + int {
            
            return "Vynaložená částka na zajištění příjmů a rodiny"
        
        } else if section == 4 + int {
            
            return "Poznámky"
        
        } else if section == 2 {
            
            return "Partner(ka)"
            
        }
        
        return nil
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UITableViewHeaderFooterView()
        headerView.backgroundView?.backgroundColor = UIColor.clearColor()
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footView = UITableViewHeaderFooterView()
        footView.backgroundView?.backgroundColor = UIColor.clearColor()
        
        return footView
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        if section == 4 + int {
            
            return "Další bod: Bydlení"
        }
        
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 4 + int {
            
            return 3*44
            
        } else {
            
            return 44
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("didselect row")
        
        if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                isClientSegue = true
                
                self.performSegueWithIdentifier("pracovniPomerSegue", sender: self)

            }
        
        } else if indexPath.section == 2 && udajeKlienta.rodinnyStav == "Vdaná/Ženatý" {
            
            if indexPath.row == 0 {
                
                isClientSegue = false
                
                self.performSegueWithIdentifier("pracovniPomerSegue", sender: self)
            
            }
        }
        
    }
    
    
    //MARK: - passing data to global variable
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        selectedRow = textField.tag
        
        if textField.text != "" {
            
            textField.text = textField.text?.chopSuffix(2).condenseWhitespace()
        
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if selectedRow == 1 {
            
            if textField.text?.characters.count != 0 {
            
                udajeKlienta.prijmy = Int((textField.text! as NSString).intValue)
                textField.text = udajeKlienta.prijmy?.currencyFormattingWithSymbol("Kč")
            
            } else {
                
                udajeKlienta.prijmy = nil
                
            }
            
            isIncomeHigherThanExpenses()
            vypocetZajisteni(true)
            
        } else if selectedRow == 2 {
            
            if textField.text?.characters.count != 0 {
            
                udajeKlienta.vydaje = Int((textField.text! as NSString).intValue)
                textField.text = udajeKlienta.vydaje?.currencyFormattingWithSymbol("Kč")
            
            } else {
                
                udajeKlienta.vydaje = nil
                
            }
            
            isIncomeHigherThanExpenses()
            vypocetZajisteni(true)
        
        } else if selectedRow == 3 {
            
            if textField.text?.characters.count != 0 {
                
                udajeKlienta.zajisteniPrijmuCastka = Int((textField.text! as NSString).intValue)
                textField.text = udajeKlienta.zajisteniPrijmuCastka?.currencyFormattingWithSymbol("Kč")
                
            } else {
                
                udajeKlienta.zajisteniPrijmuCastka = nil
                
            }
        
        } else if selectedRow == 4 {
            
            if textField.text?.characters.count != 0 {
                
                udajeKlienta.prijmyPartner = Int((textField.text! as NSString).intValue)
                textField.text = udajeKlienta.prijmyPartner?.currencyFormattingWithSymbol("Kč")
                
            } else {
                
                udajeKlienta.prijmyPartner = nil
            
            }
            
            isIncomeHigherThanExpenses()
            vypocetZajisteni(false)
        
        } else {
            
            if textField.text?.characters.count != 0 {
                
                udajeKlienta.vydajePartner = Int((textField.text! as NSString).intValue)
                textField.text = udajeKlienta.vydajePartner?.currencyFormattingWithSymbol("Kč")
                
            } else {
                
                udajeKlienta.vydajePartner = nil
            
            }
            
            isIncomeHigherThanExpenses()
            vypocetZajisteni(false)
        }
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        udajeKlienta.zajisteniPrijmuPoznamky = textView.text
    }
    
    //MARK: - vypocet zabezpeceni prijmu a nakladu
    
    func vypocetZajisteni(isClient: Bool) {
        
        if isClient {
            
            if udajeKlienta.prijmy > 0 {
                
                udajeKlienta.denniPrijmy = (udajeKlienta.prijmy!/30)/2
                
            }
            
            if udajeKlienta.vydaje > 0 {
                
                udajeKlienta.denniVydaje = udajeKlienta.vydaje!/30
            }
            
            
            if udajeKlienta.pracovniPomer == "OSVČ" && udajeKlienta.denniPrijmy != nil {
                
                udajeKlienta.denniPrijmy = udajeKlienta.denniPrijmy!*2
                
            }
            
            tableView.reloadData()
        
        } else {
            
            if udajeKlienta.prijmyPartner > 0 {
                
                udajeKlienta.denniPrijmyPartner = (udajeKlienta.prijmyPartner!/30)/2
                
            }
            
            if udajeKlienta.vydajePartner > 0 {
                
                udajeKlienta.denniVydajePartner = udajeKlienta.vydajePartner!/30
            }
            
            
            if udajeKlienta.pracovniPomerPartner == "OSVČ" && udajeKlienta.denniPrijmyPartner != nil {
                
                udajeKlienta.denniPrijmyPartner = udajeKlienta.denniPrijmyPartner!*2
                
            }
            
            let cell1 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 2))
            let label1 = cell1?.contentView.viewWithTag(5) as! UILabel?
            
            if udajeKlienta.denniPrijmyPartner > 0 {
                
                label1?.textColor = UIColor.blackColor()
                label1?.text = udajeKlienta.denniPrijmyPartner!.currencyFormattingWithSymbol("Kč")
                
            } else {
                
                label1?.textColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1)
                label1?.text = "583 Kč"
                
            }
            
            let cell2 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 2))
            let label2 = cell2?.contentView.viewWithTag(6) as! UILabel?
            
            if udajeKlienta.denniVydajePartner > 0 {
                
                label2?.textColor = UIColor.blackColor()
                label2?.text = udajeKlienta.denniVydajePartner!.currencyFormattingWithSymbol("Kč")
                
            } else {
                
                label2?.textColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1)
                label2?.text = "666 Kč"
                
            }
        }

    }
    
    //MARK: - textField formatting
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var result = true
        let prospectiveText = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if textField.tag >= 2 {
            
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = NSCharacterSet(charactersInString: "0123456789").invertedSet
                let replacementStringIsLegal = string.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= 6
                
                let scanner:NSScanner = NSScanner.localizedScannerWithString(prospectiveText) as! NSScanner
                let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.atEnd
                
                result = replacementStringIsLegal && resultingStringLengthIsLegal && resultingTextIsNumeric
                
            }
        }
        
        return result
    
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
    
    //MARK: - hideKeyboardToolbar
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        let toolbar = UIToolbar()
        textField.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        let toolbar = UIToolbar()
        textView.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true
    }
    
    
    
    //MARK: - navigation bar buttons
    
    @IBAction func zpet(sender: AnyObject) {
        
        moveOn(0)
    }
    
    
    func forward() {
        
        moveOn(3)
    }
    
    func backward() {
        
        moveOn(1)
    }
    
    //MARK: - infoChecks
    
    func moveOn(moveID: Int) {
        
        endEditingNow()
        
        if hasProvidedAllInfo().0 == false && udajeKlienta.chceResitZajisteniPrijmu {
            
            let alert = UIAlertController(title: "Opravdu chcete pokračovat?", message: "Zbývá doplnit tyto údaje:\n\n\(hasProvidedAllInfo().1)" , preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Doplnit údaje", style: .Cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Pokračovat", style: .Default, handler: { (action) in
                
                if moveID > 0 {
                    
                    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("\(moveID)")
                    self.navigationController?.pushViewController(vc!, animated: false)
                    
                } else {
                    
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
                }
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        
        } else {
            
            udajeKlienta.jeVyplnenoZajisteniPrijmu = true
            
            if moveID > 0 {
                
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("\(moveID)")
                self.navigationController?.pushViewController(vc!, animated: false)
                
            } else {
                
                self.navigationController?.popToRootViewControllerAnimated(true)
                
            }
        }
        
    }
    
    func hasProvidedAllInfo() -> (Bool, String) {
        
        var index = Int()
        
        let prijmy = "Příjmy"
        let vydaje = "Výdaje"
        let vynalozenaCastka = "Vynaložená částka"
        let prijmyPartner = "Příjmy partnera"
        let vydajePartner = "Výdaje partnera"
        
        var values = [udajeKlienta.prijmy, udajeKlienta.vydaje, udajeKlienta.zajisteniPrijmuCastka, udajeKlienta.prijmyPartner, udajeKlienta.vydajePartner]
        var labels = [prijmy, vydaje, vynalozenaCastka, prijmyPartner, vydajePartner]
        
        if int == 1 {
            
            values = [udajeKlienta.prijmy, udajeKlienta.vydaje, udajeKlienta.zajisteniPrijmuCastka, udajeKlienta.prijmyPartner, udajeKlienta.vydajePartner]
            labels = [prijmy, vydaje, vynalozenaCastka, prijmyPartner, vydajePartner]
            
            index = 2
        }
        
        var arr: [String] = []
        
        for i in 0 ..< 3 + index {
            
            if values[i] == nil {
                
                arr.append(labels[i])
            }
        }
        
        var str = String()
        
        for i in 0 ..< arr.count {
            
            str = str + arr[i]
            
            if i != arr.count {
                
                str = str + "\n"
            }
        }
        
        if arr.isEmpty {
            
            udajeKlienta.jeVyplnenoZajisteniPrijmu = true
            
            return (true, str)
            
        } else {
            
            udajeKlienta.jeVyplnenoZajisteniPrijmu = false
            
            return (false, str)
        }

        
    }
    
    //MARK: - isIncomeHigherThanExpenses
    
    func isIncomeHigherThanExpenses() {
        
        if udajeKlienta.vydaje > udajeKlienta.prijmy {
            
            let alert = UIAlertController(title: "Výdaje jsou vyšší než příjmy", message: nil , preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        
        }
        
        if udajeKlienta.vydajePartner > udajeKlienta.prijmyPartner {
            
            let alert = UIAlertController(title: "Výdaje jsou vyšší než příjmy", message: nil , preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
    }
    
    
    //MARK: - chceResitSwitch
    
    func chceResitSwitch(sender: UISwitch) {
        
        if sender.on == true {
            
            udajeKlienta.chceResitZajisteniPrijmu = true

        } else {
            
            udajeKlienta.chceResitZajisteniPrijmu = false
            udajeKlienta.zajisteniPrijmuCastka = nil
            
        }
        
        prioritiesUpdate("Zabezpečení příjmů a rodiny", chceResit: sender.on)
        
        tableView.reloadData()
        
    }
    
    //MARK: - prepare for segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "pracovniPomerSegue" {
            
            let destination = segue.destinationViewController as! PracovniPomerTableViewController
            
            destination.isClient = isClientSegue
            
            
        }
        
    }

    
}