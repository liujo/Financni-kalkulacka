//
//  DetiTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 05.11.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import UIKit

class DetiTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var topNum = 1
    var bottomNum = 0
    var numberOfRowsNoKids = [1, 1, 2, 2, 1, 1]
    var numberOfRowsWithKids = [1, 1, 2, udajeKlienta.pocetDeti, 1, 1]
    
    var kidID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Děti"
        
        let backItem = UIBarButtonItem(title: "Zpět", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        let forwardButton = UIBarButtonItem(image: UIImage(named: "forward.png"), style: .Plain, target: self, action: #selector(DetiTableViewController.forward))
        let backwardButton = UIBarButtonItem(image: UIImage(named: "backward.png"), style: .Plain, target: self, action: #selector(DetiTableViewController.backward))
        navigationItem.setRightBarButtonItems([forwardButton, backwardButton], animated: true)
        
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage()
        imageView.image = image.background(UIScreen.mainScreen().bounds.height)
        tableView.backgroundView = imageView
        
        cellCalculation()
        
        if udajeKlienta.pocetDeti > 0 {
            
            topNum = 0
            bottomNum = 0
            
        } else {
            
            topNum = 1
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        endEditingNow()
        
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        if udajeKlienta.chceResitDeti == true {
            
            if udajeKlienta.pocetDeti > 0 || udajeKlienta.pocetPlanovanychDeti == nil || udajeKlienta.pocetPlanovanychDeti == 0 {
                
                return 6
                
            } else {
                
                return 7
                
            }
            
        }
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if udajeKlienta.chceResitDeti == true {
        
            if udajeKlienta.pocetDeti > 0 {
                
                return numberOfRowsWithKids[section]!
                
            } else {
                
                return numberOfRowsNoKids[section]
                
            }
        
        }
        
        return 1
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("chceResitDeti") as! ChceResitDeti
            
            cell.switcher.addTarget(self, action: #selector(DetiTableViewController.chceResitSwitch(_:)), forControlEvents: .ValueChanged)
            
            if udajeKlienta.chceResitDeti == true {
                
                cell.switcher.on = true
                
            } else {
                
                cell.switcher.on = false
                
            }
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("mateDeti") as! mateDeti
            
            var str = "Ne"
            
            if udajeKlienta.pocetDeti > 0 {
                
                str = "Ano, \(udajeKlienta.pocetDeti!) děti"
                
                if udajeKlienta.pocetDeti == 1 {
                    
                    str = "Ano, 1 dítě"
                    
                } else if udajeKlienta.pocetDeti > 4 {
                    
                    str = "Ano, \(udajeKlienta.pocetDeti!) dětí"
                    
                }
                
            }
            
            cell.mateDeti.text = str
            
            return cell
        
        } else if indexPath.section == 2 && (udajeKlienta.pocetDeti == 0 || udajeKlienta.pocetDeti == nil) {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("planujeteDeti") as! planujeteDeti
                
                cell.planujeteDeti.text = udajeKlienta.planujeteDeti
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("kolik") as! kolikDeti
                
                if udajeKlienta.pocetPlanovanychDeti > 0 {
                    
                    cell.kolikDeti.text = "\(udajeKlienta.pocetPlanovanychDeti!)"
                    
                }
                
                cell.kolikDeti.tag = 1
                cell.kolikDeti.delegate = self
                
                return cell
            }
        
        } else if indexPath.section == 2 + topNum {
          
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("otazka1") as! mateDeti
                
                var str = "Ano"
                
                if udajeKlienta.otazka1 == false {
                    
                    str = "Ne"
                }
                
                cell.otazka1.text = str
                
                return cell
            
            } else {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("otazka2") as! mateDeti
                
                var str = "Ano"
                
                if udajeKlienta.otazka2 == false {
                    
                    str = "Ne"
                }
                
                cell.otazka2.text = str
                
                return cell
            }
            
        } else if indexPath.section == 3 + topNum && (udajeKlienta.pocetDeti > 0 || udajeKlienta.pocetPlanovanychDeti > 0) {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("seznamDeti") as! diteSporeni
            
            var str = String()
            var num = String()
            
            if udajeKlienta.detiJmena[indexPath.row] != String() {
            
                str = udajeKlienta.detiJmena[indexPath.row]
            
            } else {
                
                str = "Dítě \(indexPath.row + 1)"
                
            }
            
            if udajeKlienta.detiMesicneSporeni[indexPath.row] != Int() {
            
                num = " - \(udajeKlienta.detiMesicneSporeni[indexPath.row]) Kč"
            
            }
            
            cell.diteLabel.text = str + num
            
            if udajeKlienta.detiJeVyplneno[indexPath.row] == true {
                
                cell.diteLabel.textColor = UIColor(red: 5/255, green: 128/255, blue: 0, alpha: 1)
            }
            
            return cell
        
        } else if indexPath.section == 4 + bottomNum {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("deti") as! DetiVynalozenaCastka
            
            if udajeKlienta.detiVynalozenaCastka == 0 && udajeKlienta.jeVyplnenoDeti {
                
                cell.detiVynalozenaCastka.text = "0"
                
            } else if udajeKlienta.detiVynalozenaCastka > 0 {
                
                cell.detiVynalozenaCastka.text = udajeKlienta.detiVynalozenaCastka!.currencyFormattingWithSymbol("Kč")
            }
            
            cell.detiVynalozenaCastka.tag = 2
            cell.detiVynalozenaCastka.delegate = self
            
            return cell

        } else if indexPath.section == 5 + bottomNum {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("detiPoznamky") as! DetiPoznamky
            
            cell.detiPoznamky.text = "\(udajeKlienta.detiPoznamky)"
            cell.detiPoznamky.delegate = self
            
            return cell

        } else {
            
            return UITableViewCell()
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 3 + topNum {
            
            kidID = indexPath.row
            self.performSegueWithIdentifier("diteSporeni", sender: self)
            
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let sctn = 5 + bottomNum
        
        if indexPath.section == sctn {
            
            return 44*3
            
        } else {
            
            return 44
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 3 + topNum && (udajeKlienta.pocetDeti > 0 || udajeKlienta.pocetPlanovanychDeti > 0) {
            
            return "Děti spoření"
        
        } else if section == 4 + bottomNum {
            
            return "Vynaložená částka na zajištění dětí"
            
        } else if section == 5 + bottomNum {
            
            return "Poznámky"
            
        }
        
        return nil

    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        if udajeKlienta.pocetDeti == 0 && section == 1 {
            
            return "Jedno dítě stojí první 2 roky 100 000 Kč. Jste připraveni?"
            
        }
        
        let sctn = 5 + bottomNum
        
        if section == sctn {
            
            return "Další bod: Důchod"
            
        }
        
        return nil
    }
    
    func cellCalculation() {
        
        if udajeKlienta.pocetPlanovanychDeti > 0 {
            
            bottomNum = 1
            
            if numberOfRowsNoKids.count == 8 {
                
                numberOfRowsNoKids[4] = udajeKlienta.pocetPlanovanychDeti!
                
            } else {
                
                numberOfRowsNoKids.insert(udajeKlienta.pocetPlanovanychDeti!, atIndex: 4)

            }
            
        } else if udajeKlienta.pocetPlanovanychDeti < 1 {
            
            bottomNum = 0
            
            if numberOfRowsNoKids.count == 8 {
                
                numberOfRowsNoKids.removeAtIndex(4)
                
            }
        }
        
        print(numberOfRowsNoKids)
    }
    
    
    //MARK: - textfield formatting
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var result = true
        let prospectiveText = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if string.characters.count > 0 {
            
            var disallowedCharacterSet = NSCharacterSet(charactersInString: "0123456789").invertedSet
            var resultingStringLengthIsLegal = Bool()
            
            if textField.tag == 1 {
                
                resultingStringLengthIsLegal = prospectiveText.characters.count <= 1
                disallowedCharacterSet = NSCharacterSet(charactersInString: "01234").invertedSet
                
            } else if textField.tag == 2 {
                
                resultingStringLengthIsLegal = prospectiveText.characters.count <= 7
                
            }
            
            let replacementStringIsLegal = string.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
            let scanner:NSScanner = NSScanner.localizedScannerWithString(prospectiveText) as! NSScanner
            let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.atEnd
            
            result = replacementStringIsLegal && resultingStringLengthIsLegal && resultingTextIsNumeric
            
        }
        
        return result
        
    }
    
    //MARK: - passing data to struct
    
    func textFieldDidBeginEditing(textField: UITextField) {
            
        if textField.text != "" {
        
            textField.text = textField.text?.chopSuffix(2)
            
        }
        
        textField.text = textField.text?.condenseWhitespace()

    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField.tag == 1 {
            
            udajeKlienta.pocetPlanovanychDeti = Int((textField.text! as NSString).intValue)
            
            cellCalculation()
            
            tableView.reloadData()
            
        } else if textField.tag == 2 {
            
            udajeKlienta.detiVynalozenaCastka = Int((textField.text! as NSString).intValue)
            
            if udajeKlienta.detiVynalozenaCastka > 0 {
                
                textField.text = udajeKlienta.detiVynalozenaCastka!.currencyFormattingWithSymbol("Kč")
                
            }
            
        }
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        udajeKlienta.detiPoznamky = textView.text
        
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
        
        let toolbar = UIToolbar()
        textField.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        let toolbar = UIToolbar()
        textView.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true

    }
    
    
    //MARK: - chceResitSwitch
    
    func chceResitSwitch(sender: UISwitch) {
        
        if sender.on == true {
            
            udajeKlienta.chceResitDeti = true
            
        } else {
            
            udajeKlienta.chceResitDeti = false
            udajeKlienta.detiVynalozenaCastka = nil
            
        }
        
        prioritiesUpdate("Děti", chceResit: sender.on)
        
        tableView.reloadData()
        
    }
    
    //MARK: - segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "planujeteDeti" {
            
            let destination = segue.destinationViewController as! PlanujeteDetiTableViewController
            
            destination.int = 0
            
        } else if segue.identifier == "otazka1" {
            
            let destination = segue.destinationViewController as! PlanujeteDetiTableViewController
            
            destination.int = 1
        
        } else if segue.identifier == "otazka2" {
            
            let destination = segue.destinationViewController as! PlanujeteDetiTableViewController
            
            destination.int = 2
        
        } else if segue.identifier == "diteSporeni" {
            
            let destination = segue.destinationViewController as! DiteSporeniTableViewController
            
            destination.kidID = kidID
            
        }
    }
    
    @IBAction func zpet(sender: AnyObject) {
        
        moveOn(0)
    }
    
    func backward() {
        
        moveOn(3)
    }
    
    func forward() {
    
        moveOn(5)
    
    }
    
    //MARK: - infoChecks
    
    func moveOn(moveID: Int) {
        
        endEditingNow()
        
        if hasProvidedAllInfo().0 == false && udajeKlienta.chceResitDeti {
            
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
            
            udajeKlienta.jeVyplnenoDeti = true
            
            if moveID > 0 {
                
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("\(moveID)")
                self.navigationController?.pushViewController(vc!, animated: false)
                
            } else {
                
                self.navigationController?.popToRootViewControllerAnimated(true)
                
            }
        }
        
    }
 
    func hasProvidedAllInfo() -> (Bool, String) {
        
        var values: [Bool] = []
        var labels: [String] = []
        
        if udajeKlienta.pocetDeti > 0 {
            
            labels.append("Vynaložená částka")
            
            if udajeKlienta.detiVynalozenaCastka != nil {
                
                values.append(true)
                
            } else {
                
                values.append(false)
                
            }
            
            for i in 0 ..< udajeKlienta.pocetDeti! {

                if udajeKlienta.detiJeVyplneno[i] == true {
                    
                    values.append(true)
                    labels.append(udajeKlienta.detiJmena[i])
                    
                } else {
                    
                    values.append(false)
                    labels.append("Dítě \(i + 1)")
                    
                }
            }
        
        } else if udajeKlienta.pocetDeti == 0 || udajeKlienta.pocetDeti == nil {
            
            labels = ["Počet plánovaných dětí", "Vynaložená částka"]
            
            if udajeKlienta.pocetPlanovanychDeti == nil {
                
                values.append(false)
                
            } else {
                
                values.append(true)
                
            }
            
            if udajeKlienta.detiVynalozenaCastka == nil {
                
                values.append(false)
                
            } else {
                
                values.append(true)
                
            }
            
            if udajeKlienta.pocetPlanovanychDeti >= 0 {
            
                for i in 0 ..< udajeKlienta.pocetPlanovanychDeti! {
                
                    if udajeKlienta.detiJeVyplneno[i] == true {
                    
                        values.append(true)
                        labels.append(udajeKlienta.detiJmena[i])
                    
                    } else {
                    
                        values.append(false)
                        labels.append("Dítě \(i + 1)")
                    
                    }
                }
            
            }
            
        }
        
        var arr: [String] = []
        
        for i in 0 ..< values.count {
            
            if values[i] == false {
                
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
            
            udajeKlienta.jeVyplnenoDeti = true
            
            return (true, str)
            
        } else {
            
            udajeKlienta.jeVyplnenoDeti = false
            
            return (false, str)
        }
        
        
    }
    
}
