
//
//  SavingsTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 13.05.16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import UIKit

class SavingsTableViewController: UITableViewController, UITextFieldDelegate {
    
    //MARK: - Global variables for segue
    
    var celkovaUlozkaGlobal = Int()
    var arrayOfInterestGlobal:[Int] = []
    var arrayOfInterestSegue:[Int] = []
    var dobaGlobal = Int()
    
    var isSegueFromKartaKlienta = Bool()
    var num = Int()
    var sections = [3, 3, 2]
    
    //MARK: - local variables
    
    var textField1Value = "1 500 Kč"
    var textField2Value = "20 let"
    var textField3Value = "5 %"
    
    var label1Value = "616 550 Kč"
    var label2Value = "256 550 Kč"
    
    var slider1Value: Float = 15
    var slider2Value: Float = 20
    var slider3Value: Float = 50
    
    var stepper1Value: Double = 1500
    var stepper2Value: Double = 20
    var stepper3Value: Double = 50
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Spoření"
        
        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Graf", style: .Plain, target: self, action: "segueToGraph")
        
        if isSegueFromKartaKlienta {
            
            num = 1
            sections.insert(1, atIndex: 0)
            
        } else {
            
            num = 0
        }
        
        let value1 = udajeKlienta.grafDuchodMesicniPlatba
        
        if value1 != Int() {
            
            textField1Value = value1.currencyFormattingWithSymbol("Kč")
            slider1Value = Float(value1)/100
            stepper1Value = Double(value1)
            
        }
        
        let value2 = udajeKlienta.grafDuchodDoba
        
        if value2 != Int() {
            
            textField2Value = value2.currencyFormattingWithSymbol("let")
            slider2Value = Float(value2)
            stepper2Value = Double(value2)
            
        }
        
        let value3 = udajeKlienta.grafDuchodRocniUrok
        
        if value3 != Float() {
            
            textField3Value = value3.currencyFormattingWithSymbol("%")
            slider3Value = Float(value3)*10
            stepper3Value = Double(value3)*10
            
        }
        
        pocitani()

    }
    
    //MARK: - pocitani
    
    func pocitani() {
        
        let num = textField1Value.condenseWhitespace() //formatovani mesicni platby
        let urokCarka = textField3Value.stringByReplacingOccurrencesOfString(",", withString: ".", options: [], range: nil)//vymena carky za tecku
        
        let mesicniUlozka:Float = Float((num as NSString).floatValue)
        let doba:Float = Float((textField2Value as NSString).floatValue)
        let urok:Float = Float((urokCarka as NSString).floatValue) //roky
        
        
        let urokRozdelen = urok/12*0.01 //rozdeleno na mesicni urok a vynasobeno 0.01
        let dobaNaMesice = doba*12
        
        var nasporenaCastka = Float()
        
        var d = Int()
        
        for var i:Float = Float(1); i <= dobaNaMesice; i++ {
            
            nasporenaCastka = nasporenaCastka + mesicniUlozka + nasporenaCastka*urokRozdelen
            
            if i % 12 == 0 {
                
                //storeNumber += Int(round(nasporenaCastka)) - i*12*mesicniUlozka
                let a = round(nasporenaCastka)
                let b = i*mesicniUlozka
                var c = a - b
                c = round(c)
                d = Int(c)
                
                arrayOfInterestGlobal.append(d)
            }
            
            
        }
        
        arrayOfInterestSegue = arrayOfInterestGlobal
        arrayOfInterestGlobal = []
        
        let penizeBezUroku = dobaNaMesice*mesicniUlozka //penize, ktere tam klient zaslal. Tato hodnota nezapocitava uroky
        var celkemUrok = nasporenaCastka - penizeBezUroku
        
        nasporenaCastka = round(nasporenaCastka)
        celkemUrok = round(celkemUrok)
        
        let nasporenaCastkaInt:Int = Int(nasporenaCastka)
        let celkemUrokInt:Int = Int(celkemUrok)
        
        label1Value = nasporenaCastkaInt.currencyFormattingWithSymbol("Kč")
        label2Value = celkemUrokInt.currencyFormattingWithSymbol("Kč")
        
        //user defaults values
        udajeKlienta.grafDuchodMesicniPlatba = Int(mesicniUlozka)
        udajeKlienta.grafDuchodDoba = Int(doba)
        udajeKlienta.grafDuchodRocniUrok = urok
        
        //values for segue - graph view
        celkovaUlozkaGlobal = Int(penizeBezUroku)
        dobaGlobal = Int(doba)
        
        udajeKlienta.grafDuchodDobaSporeni = dobaGlobal
        udajeKlienta.grafDuchodCelkovaUlozka = celkovaUlozkaGlobal
        udajeKlienta.grafDuchodUroky = arrayOfInterestSegue
        
        tableView.reloadData()
        
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5 + num
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 + num {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("mesicniPlatba") as! SavingsCell
            
            cell.mesicniPlatbaTextField.delegate = self
            cell.mesicniPlatbaTextField.tag = 1
            cell.mesicniPlatbaTextField.text = textField1Value
            
            cell.mesicniPlatbaSlider.addTarget(self, action: #selector(SavingsTableViewController.mesicniPlatbaSliderAction(_:)), forControlEvents: .ValueChanged)
            cell.mesicniPlatbaSlider.value = slider1Value
            
            cell.mesicniPlatbaStepper.addTarget(self, action: #selector(SavingsTableViewController.mesicniPlatbaStepperAction(_:)), forControlEvents: .ValueChanged)
            cell.mesicniPlatbaStepper.value = stepper1Value
            
            return cell
        
        } else if indexPath.row == 1 + num {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("doba") as! SavingsCell
            
            cell.dobaTextField.delegate = self
            cell.dobaTextField.tag = 2
            cell.dobaTextField.text = textField2Value
            
            cell.dobaSlider.addTarget(self, action: #selector(SavingsTableViewController.dobaSliderAction(_:)), forControlEvents: .ValueChanged)
            cell.dobaSlider.value = slider2Value
            
            cell.dobaStepper.addTarget(self, action: #selector(SavingsTableViewController.dobaStepperAction(_:)), forControlEvents: .ValueChanged)
            cell.dobaStepper.value = stepper2Value
            
            return cell
            
        } else if indexPath.row == 2 + num {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("rocniUrok") as! SavingsCell
            
            cell.urokTextField.delegate = self
            cell.urokTextField.tag = 3
            cell.urokTextField.text = textField3Value
            
            cell.urokSlider.addTarget(self, action: #selector(SavingsTableViewController.urokSliderAction(_:)), forControlEvents: .ValueChanged)
            cell.urokSlider.value = slider3Value
            
            cell.urokStepper.addTarget(self, action: #selector(SavingsTableViewController.urokStepperAction(_:)), forControlEvents: .ValueChanged)
            cell.urokStepper.value = stepper3Value
            
            return cell
        
        } else if indexPath.row == 3 + num {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("celkemNasporeno") as! SavingsCell
            
            cell.celkemNasporenoLabel.text = label1Value
            
            return cell
            
        } else if indexPath.row == 4 + num {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("vyplacenyUrok") as! SavingsCell
            
            cell.vyplacenyUrokLabel.text = label2Value
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("pridatGraf") as! SavingsCell
            
            cell.grafSwitch.addTarget(self, action: #selector(SavingsTableViewController.grafSwitchAction(_:)), forControlEvents: .ValueChanged)
            
            if udajeKlienta.chceGrafDuchodu {
                
                cell.grafSwitch.on = true
                
            } else {
                
                cell.grafSwitch.on = false
                
            }
            
            return cell
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 + num || indexPath.row == 1 + num || indexPath.row == 2 + num {
            
            return 75
        
        } else if indexPath.row == 4 + num || indexPath.row == 3 + num {
            
            return 30
        
        } else {
        
            return 44
        
        }
    }
    
    //MARK: - switch action
    
    func grafSwitchAction(sender: UISwitch) {
        
        if sender.on == true {
            
            udajeKlienta.chceGrafDuchodu = true
            
        } else {
            
            udajeKlienta.chceGrafDuchodu = false
            
        }
        
        tableView.reloadData()
    }

    
    //MARK: slider ibactions
    
    func mesicniPlatbaSliderAction(sender: UISlider) {
        
        let a = Int(sender.value)*100
        
        textField1Value = a.currencyFormattingWithSymbol("Kč")
        stepper1Value = Double(a)
        slider1Value = sender.value
        
        pocitani()
        
    }
    
    func dobaSliderAction(sender: UISlider) {
        
        let b = Int(sender.value)
        
        textField2Value = b.currencyFormattingWithSymbol("let")
        stepper2Value = Double(b)
        slider2Value = sender.value
        
        pocitani()
        
    }
    
    func urokSliderAction(sender: UISlider) {
        
        var c = Float(sender.value)
        c = round(c)
        c = c * 0.1
        
        textField3Value = c.currencyFormattingWithSymbol("%")
        stepper3Value = Double(sender.value)
        slider3Value = sender.value
        
        pocitani()
        
    }
    
    //MARK: - stepper ibactions
    
    func mesicniPlatbaStepperAction(sender: UIStepper) {
        
        let a = Int(sender.value)
        
        textField1Value = a.currencyFormattingWithSymbol("Kč")
        slider1Value = Float(sender.value)/100
        stepper1Value = sender.value
        
        pocitani()
        
    }
    
    func dobaStepperAction(sender: UIStepper) {
        
        let b = Int(sender.value)
        
        textField2Value = b.currencyFormattingWithSymbol("let")
        slider2Value = Float(sender.value)
        stepper2Value = sender.value
        
        pocitani()
        
    }
    
    func urokStepperAction(sender: UIStepper) {
        
        var c = Float(sender.value)
        c = round(c)
        c = c * 0.1
        
        textField3Value = c.currencyFormattingWithSymbol("%")
        slider3Value = Float(sender.value)
        stepper3Value = sender.value
        
        pocitani()
        
    }
    
    //MARK: - text field actions
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField.text != "" {
            
            var int = Int()
            
            if textField.tag == 3 {
                
                int = 1
                
            } else {
                
                int = 3
            }
            
            textField.text = textField.text?.chopSuffix(int).condenseWhitespace()
            
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField.tag == 1 {
            
            var num = Int((textField.text! as NSString).intValue)
            
            if num > 10000 {
                
                num = 10000
            }
            
            if num < 500 || textField.text == "" {
                
                num = 500
            }
            
            slider1Value = Float(num)/100
            stepper1Value = Double(num)
            textField1Value = num.currencyFormattingWithSymbol("Kč")
            
            pocitani()
            
        } else if textField.tag == 2 {
            
            var num = Int((textField.text! as NSString).intValue)
            
            if num > 50 {
                
                num = 50
            }
            
            if num < 1 || textField.text == "" {
                
                num = 1
                
            }
            
            slider2Value = Float(num)
            stepper2Value = Double(num)
            textField2Value = num.currencyFormattingWithSymbol("let")
            
            pocitani()
            
        } else if textField.tag == 3 {
            
            let str = textField.text?.stringByReplacingOccurrencesOfString(",", withString: ".")
            var num = Float((str! as NSString).floatValue)
            
            if num > 20 {
                
                num = 20
            }
            
            if num < 1 || textField.text == "" {
                
                num = 1
            }
            
            slider3Value = num*10
            stepper3Value = Double(num)*10
            textField3Value = num.currencyFormattingWithSymbol("%")
            
            pocitani()
        }
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var result = true
        let prospectiveText = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if string.characters.count > 0 {
            
            var int = Int()
            
            if textField.tag == 1 {
                
                int = 5
                
            } else {
                
                int = 2
                
            } 
            
            let resultingStringLengthIsLegal = prospectiveText.characters.count <= int
            
            let disallowedCharacterSet = NSCharacterSet(charactersInString: "0123456789.,").invertedSet
            let replacementStringIsLegal = string.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
            
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
    
    //MARK: - prepareForSegue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "sporeniGraf" {
            
            let svc = segue.destinationViewController as! SavingsGrafTableViewController;
            
            svc.toPassCelkovaUlozka = celkovaUlozkaGlobal
            svc.toPassArrayInterest = arrayOfInterestSegue
            svc.toPassDobaGlobal = dobaGlobal
        }
    }
    
    func segueToGraph() {
        
        self.performSegueWithIdentifier("sporeniGraf", sender: self)
        
    }

}
