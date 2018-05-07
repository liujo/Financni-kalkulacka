//
//  NavratnostInvesticeTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 13.05.16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import UIKit

class NavratnostInvesticeTableViewController: UITableViewController, UITextFieldDelegate {
    
    //MARK: - local variables
    
    var textField1Value = "20 000 000 Kč"
    var textField2Value = "100 000 Kč"
    var textField3Value = "30 000 Kč"
    
    var label1Value = "616 550 Kč"
    var label2Value = "256 550 Kč"
    
    var slider1Value: Float = 200
    var slider2Value: Float = 100
    var slider3Value: Float = 30
    
    var stepper1Value: Double = 20000000
    var stepper2Value: Double = 100000
    var stepper3Value: Double = 30000

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Návratnost investice"
        pocitani()
    }
    
    //MARK: - rovnice vypoctu
    
    func pocitani() {
        
        //udaje z UI elementu na variables
        
        //vymazani mezer
        let kupniCenaBezMezer = textField1Value.condenseWhitespace()
        let vyseNajmuBezMezer = textField2Value.condenseWhitespace()
        let zalohyBezMezer = textField3Value.condenseWhitespace()
        
        //prevedeni na integery
        let kupniCena = Float((kupniCenaBezMezer as NSString).floatValue)
        let vyseNajmu = Float((vyseNajmuBezMezer as NSString).floatValue)
        let zalohy = Float((zalohyBezMezer as NSString).floatValue)
        
        // 1)
        // tady spocitam zhodnoceni
        ///rovnice: [(hruby najem - zalohy) * mesice]/kupni cena = zhodnoceni v procentech/100
        
        var zhodnoceni = (vyseNajmu - zalohy) * 12
        zhodnoceni = zhodnoceni/kupniCena
        zhodnoceni = zhodnoceni*100
        
        zhodnoceni = round(zhodnoceni*10)/10
        
        label1Value = "\(zhodnoceni) % ročně"
        label1Value = label1Value.stringByReplacingOccurrencesOfString(".", withString: ",")
        
        print(zhodnoceni)
        
        // 2)
        //tady spocitam navratnost
        //rovnice: kupni cena/[(hruby najem - zalohy) * mesice] = doba navratnosti v letech
        
        var navratnost = (vyseNajmu - zalohy) * 12
        navratnost = kupniCena/navratnost
        
        navratnost = round(navratnost * 12)
        
        let navratnostInt = Int(navratnost)
        
        if navratnost % 12 == 0 {
            
            print(navratnost/12)
            label2Value = "\(navratnostInt/12) let"
            
        } else {
            
            print("roky: \(round(navratnost/12)), mesice: \(navratnost%12)")
            label2Value = "\(navratnostInt/12) let a \(navratnostInt%12) měsíců"
        }
        
        tableView.reloadData()
        
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cena") as! NavratnostCell
            
            cell.cenaTextField.delegate = self
            cell.cenaTextField.tag = 1
            cell.cenaTextField.text = textField1Value
            
            cell.cenaSlider.addTarget(self, action: #selector(NavratnostInvesticeTableViewController.cenaSliderAction(_:)), forControlEvents: .ValueChanged)
            cell.cenaSlider.value = slider1Value
            
            cell.cenaStepper.addTarget(self, action: #selector(NavratnostInvesticeTableViewController.cenaStepperAction(_:)), forControlEvents: .ValueChanged)
            cell.cenaStepper.value = stepper1Value
            
            return cell
            
        } else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("mesicniPrijem") as! NavratnostCell
            
            cell.mesicniPrijemTextField.delegate = self
            cell.mesicniPrijemTextField.tag = 2
            cell.mesicniPrijemTextField.text = textField2Value
            
            cell.mesicniPrijemSlider.addTarget(self, action: #selector(NavratnostInvesticeTableViewController.mesicniPrijemSliderAction(_:)), forControlEvents: .ValueChanged)
            cell.mesicniPrijemSlider.value = slider2Value
            
            cell.mesicniPrijemStepper.addTarget(self, action: #selector(NavratnostInvesticeTableViewController.mesicniPrijemStepperAction(_:)), forControlEvents: .ValueChanged)
            cell.mesicniPrijemStepper.value = stepper2Value
            
            return cell
            
        } else if indexPath.row == 2 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("naklady") as! NavratnostCell
            
            cell.nakladyTextField.delegate = self
            cell.nakladyTextField.tag = 3
            cell.nakladyTextField.text = textField3Value
            
            cell.nakladySlider.addTarget(self, action: #selector(NavratnostInvesticeTableViewController.nakladySliderAction(_:)), forControlEvents: .ValueChanged)
            cell.nakladySlider.value = slider3Value
            
            cell.nakladyStepper.addTarget(self, action: #selector(NavratnostInvesticeTableViewController.nakladyStepperAction(_:)), forControlEvents: .ValueChanged)
            cell.nakladyStepper.value = stepper3Value
            
            return cell
            
        } else if indexPath.row == 3 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("zhodnoceni") as! NavratnostCell
            
            cell.zhodnoceniLabel.text = label1Value
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("navratnost") as! NavratnostCell
            
            cell.navratnostLabel.text = label2Value
            
            return cell
            
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row < 3 {
            
            return 75
            
        }
        
        return 30
    }
    
    //MARK: - slider IBAction
    
    func cenaSliderAction(sender: UISlider) {
        
        let a = Int(sender.value) * 100000
        
        textField1Value = a.currencyFormattingWithSymbol("Kč")
        stepper1Value = Double(a)
        slider1Value = sender.value
        
        pocitani()
    }
    
    func mesicniPrijemSliderAction(sender: UISlider) {
        
        let a = Int(sender.value) * 1000
        
        textField2Value = a.currencyFormattingWithSymbol("Kč")
        stepper2Value = Double(a)
        slider2Value = sender.value
        
        pocitani()
    }
    
    func nakladySliderAction(sender: UISlider) {
        
        let a = Int(sender.value) * 1000
        
        textField3Value = a.currencyFormattingWithSymbol("Kč")
        stepper3Value = Double(a)
        slider3Value = sender.value
        
        pocitani()
    }
    
    //MARK: - stepper actions
    
    func cenaStepperAction(sender: UIStepper) {
        
        let a = Int(sender.value)
        
        textField1Value = a.currencyFormattingWithSymbol("Kč")
        slider1Value = Float(a)/100000
        stepper1Value = sender.value
        
        pocitani()
        
    }
    
    func mesicniPrijemStepperAction(sender: UIStepper) {
        
        let b = Int(sender.value)
        
        textField2Value = b.currencyFormattingWithSymbol("Kč")
        slider2Value = Float(b)/1000
        stepper2Value = sender.value
        
        pocitani()
    }
    
    func nakladyStepperAction(sender: UIStepper) {
        
        let c = Int(sender.value)
        
        textField3Value = c.currencyFormattingWithSymbol("Kč")
        slider3Value = Float(c)/1000
        stepper3Value = sender.value
        
        pocitani()
        
    }
    
    //MARK: - text field actions
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField.text != "" {
            
            textField.text = textField.text?.chopSuffix(2).condenseWhitespace()
            
        }
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField.tag == 1 {
            
            var num = Int((textField.text! as NSString).intValue)
            
            if num > 200000000 {
                
                num = 200000000
            }
            
            if num < 100000 || textField.text == "" {
                
                num = 100000
            }
            
            slider1Value = Float(num)/100000
            stepper1Value = Double(num)
            textField1Value = num.currencyFormattingWithSymbol("Kč")
            
            pocitani()
            
        } else if textField.tag == 2 {
            
            var num = Int((textField.text! as NSString).intValue)
            
            if num > 3000000 {
                
                num = 3000000
            }
            
            if num < 3000 || textField.text == "" {
                
                num = 3000
                
            }
            
            slider2Value = Float(num)/1000
            stepper2Value = Double(num)
            textField2Value = num.currencyFormattingWithSymbol("Kč")
            
            pocitani()
            
        } else if textField.tag == 3 {
            
            var num = Float((textField.text! as NSString).floatValue)
            
            if num > 200000 {
                
                num = 200000
            }
            
            if num < 1000 || textField.text == "" {
                
                num = 1000
            }
            
            slider3Value = num/1000
            stepper3Value = Double(num)
            textField3Value = num.currencyFormattingWithSymbol("Kč")
            
            pocitani()
            
        }
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var result = true
        let prospectiveText = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if string.characters.count > 0 {
            
            let disallowedCharacterSet = NSCharacterSet(charactersInString: "0123456789").invertedSet
            let replacementStringIsLegal = string.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
            
            let resultingStringLengthIsLegal = prospectiveText.characters.count <= 10
            
            let scanner = NSScanner(string: prospectiveText)
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
