//
//  BydleniTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 02.11.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import UIKit

class BydleniTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var num = Int()

    let sectionsVlastni = [1, 2, 2, 1, 1, 1]
    let sectionsNajem = [1, 2, 2, 3, 1, 1, 1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Bydlení"
        
        let backItem = UIBarButtonItem(title: "Zpět", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        let forwardButton = UIBarButtonItem(image: UIImage(named: "forward.png"), style: .Plain, target: self, action: #selector(BydleniTableViewController.forward))
        let backwardButton = UIBarButtonItem(image: UIImage(named: "backward.png"), style: .Plain, target: self, action: #selector(BydleniTableViewController.backward))
        navigationItem.setRightBarButtonItems([forwardButton, backwardButton], animated: true)
        
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage()
        imageView.image = image.background(UIScreen.mainScreen().bounds.height)
        tableView.backgroundView = imageView
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if udajeKlienta.vlastniCiNajemnni == "Nájemní" {
            
            num = 1
            
        } else {
            
            num = 0
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
        
        if udajeKlienta.chceResitBydleni == true {
        
            if udajeKlienta.vlastniCiNajemnni == "Nájemní" {
        
                return 7
        
            } else {
            
                return 6
            }
        
        } else {
            
            return 1
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if udajeKlienta.chceResitBydleni == true {
        
            if udajeKlienta.vlastniCiNajemnni == "Nájemní" {
        
                return sectionsNajem[section]
            
            } else {
                
                return sectionsVlastni[section]
                
            }
        
        } else {
            
            return 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->
        UITableViewCell {
            
        if indexPath.section == 0 {
                
            let cell = tableView.dequeueReusableCellWithIdentifier("chceResitBydleni") as! ChceResitBydleni
            
            cell.switcher.addTarget(self, action: #selector(BydleniTableViewController.chceResitSwitch(_:)), forControlEvents: .ValueChanged)
            
            if udajeKlienta.chceResitBydleni == true {
                
                cell.switcher.on = true
                
            } else {
                
                cell.switcher.on = false
            
            }
            
            return cell
        
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("bytCiDum") as! BytCiDum
                
                cell.bytCiDum.text = udajeKlienta.bytCiDum
                
                return cell
            
            } else {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("vlastniCiNajemni") as! VlastniCiNajemni
                
                if udajeKlienta.vlastniCiNajemnni == "Nájemní" {
                    
                    let najemne = udajeKlienta.najemne.currencyFormattingWithSymbol("Kč") + " nájemné"
                    
                    if udajeKlienta.najemne == 0 {
                    
                        cell.vlastniCiNajemni.text = "Nájemní"
                    
                    }
                    
                    cell.vlastniCiNajemni.text = najemne
                
                } else {
                    
                    cell.vlastniCiNajemni.text = "Vlastní"
                    
                }
                
                return cell
                
            }
        
        } else if indexPath.section == 2 {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("spokojenostSNemovitosti") as! SpokojenostSNemovitosti
                
                cell.spokojenostSBydlenim.text = udajeKlienta.spokojenostSBydlenim
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("planujeVetsi") as! PlanujeVetsi
                
                cell.planujeVetsi.text = udajeKlienta.planujeVetsi
                
                return cell
                
            }
            
        } else if indexPath.section == 3 + num {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("programPredcasnehoSplaceni") as! ProgramPredcasnehoSplaceni
            
            return cell
            
        } else if indexPath.section == 4 + num {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("zajisteniBydleni") as! ZajisteniBydleni
            
            cell.zajisteniBydleni.delegate = self
            cell.zajisteniBydleni.tag = 1
            
            if udajeKlienta.zajisteniBydleniCastka > 0 {
                
                cell.zajisteniBydleni.text = udajeKlienta.zajisteniBydleniCastka!.currencyFormattingWithSymbol("Kč")
            
            }
            
            return cell
            
        } else if indexPath.section == 5 + num {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("zajisteniBydleniPoznamky") as! ZajisteniBydleniPoznamky
            
            cell.zajisteniBydleniPoznamky.delegate = self
            cell.zajisteniBydleniPoznamky.text = udajeKlienta.zajisteniBydleniPoznamky
            
            return cell
            
        } else if num == 1 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("propocetNajmu") as! PropocetNajmu
            
            if indexPath.row == 2 {
                
                cell.propocetNajmuPopisek.text = "20 let"
                let najemne = udajeKlienta.najemne*20*12
                cell.propocetNajmuVysledek.text = najemne.currencyFormattingWithSymbol("Kč")
                
            } else {
                
                let nasobitel = 5*indexPath.row
                cell.propocetNajmuPopisek.text = "\(5+nasobitel) let"
                
                let najemne = (5+nasobitel)*12*udajeKlienta.najemne
                cell.propocetNajmuVysledek.text = najemne.currencyFormattingWithSymbol("Kč")
                
            }
            
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
    
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 1 {
            
            return "Vaše bydlení"
        
        } else if section == 2 {
            
            return "Spokojenost s bydlením"
        
        } else if section == 3 + num {
            
            return "Měl(a) byste zájem o úvěr?"
            
        } else if section == 4 + num {
            
            return "Vynaložená částka na zajištění bydlení"
        
        } else if section == 5 + num {
            
            return "Poznámky"
        
        } else if num == 1 && section == 3 {
            
            return "Propočet nájmů"
        }
        
        return nil
        
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        var sctn = 5
        
        if udajeKlienta.vlastniCiNajemnni == "Nájemní" {
            
            sctn = 6
            
        }
        
        if section == sctn {
            
            return "Další bod: Děti"
            
        }
        
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var int = Int()
        
        if udajeKlienta.vlastniCiNajemnni == "Nájemní" {
            
            int = 6
        
        } else {
            
            int = 5
        }
        
        if indexPath.section == int {
            
            return 3*44
            
        } else {
            
            return 44
        }
    }
    
    //MARK: - textField formatting
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        textField.text = textField.text?.chopSuffix(2).condenseWhitespace()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField.text?.characters.count != 0 {
        
            udajeKlienta.zajisteniBydleniCastka = Int((textField.text! as NSString).intValue)
            textField.text = udajeKlienta.zajisteniBydleniCastka!.currencyFormattingWithSymbol("Kč")
        
        } else {
            
            udajeKlienta.zajisteniBydleniCastka = nil
            
        }
        
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        let toolbar = UIToolbar()
        textView.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true

    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        udajeKlienta.zajisteniBydleniPoznamky = textView.text
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
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        
        let toolbar = UIToolbar()
        textField.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true
    }
    
    
    //MARK: - navigation bar items
    
    @IBAction func zpet(sender: AnyObject) {

        moveOn(0)
    }
    
    func backward() {
        
        moveOn(2)
    }
    
        
    func forward() {
        
        moveOn(4)
    }
    
    //MARK: - segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "spokojenostSegue" {
            
            let destination = segue.destinationViewController as! SpokojenostBydleniTableViewController
            
            destination.cellLabels = ["Ano", "Mám výhrady"]
            destination.parametr = 0
            destination.headerTitle = "Spokojenost s bydlením"
            
        }
        
        if segue.identifier == "planujeVetsiSegue" {
            
            let destination = segue.destinationViewController as! SpokojenostBydleniTableViewController
            
            destination.cellLabels = ["Ano", "Ne"]
            destination.parametr = 1
            destination.headerTitle = "Plánuje větší?"
            
        }
        
        if segue.identifier == "PPSsegue" {
            
            let destination = segue.destinationViewController as! PPSTableViewController
            
            destination.isSegueFromKartaKlienta = true
        }
        
    }
    
    //MARK: - info check
    
    func moveOn(moveID: Int) {
        
        endEditingNow()
        
        if hasProvidedInfo().0 == false && udajeKlienta.chceResitBydleni {
            
            let alert = UIAlertController(title: "Opravdu chcete pokračovat?", message: "Zbývá doplnit tyto údaje:\n\n\(hasProvidedInfo().1)" , preferredStyle: .Alert)
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
            
            udajeKlienta.jeVyplnenoBydleni = true
            
            if moveID > 0 {
                
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("\(moveID)")
                self.navigationController?.pushViewController(vc!, animated: false)
                
            } else {
                
                self.navigationController?.popToRootViewControllerAnimated(true)
                
            }
        }
    }
    
    func hasProvidedInfo() -> (Bool, String) {
        
        if udajeKlienta.zajisteniBydleniCastka == nil && udajeKlienta.chceResitBydleni {
            
            udajeKlienta.jeVyplnenoBydleni = false
            
            return (false, "Vynaložená částka")
            
        }
        
        udajeKlienta.jeVyplnenoBydleni = true
        return (true, String())
        
    }
    
    //MARK: - chceResitSwitch
    
    func chceResitSwitch(sender: UISwitch) {
        
        if sender.on == true {
            
            udajeKlienta.chceResitBydleni = true
            
        } else {
            
            udajeKlienta.chceResitBydleni = false
            udajeKlienta.zajisteniBydleniCastka = nil
            
        }
        
        prioritiesUpdate("Bydlení", chceResit: sender.on)
        
        tableView.reloadData()
        
    }
    
    
}
