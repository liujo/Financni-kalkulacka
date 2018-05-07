//
//  DiteSporeniTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 05.05.16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import UIKit

class DiteSporeniTableViewController: UITableViewController, UITextFieldDelegate {
    
    var kidID = Int()
    
    //MARK: - Global variables for segue
    
    var celkovaUlozkaGlobal = Int()
    var arrayOfInterestGlobal:[Int] = []
    var arrayOfInterestSegue:[Int] = []
    var dobaGlobal = Int()
    
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

    override func viewDidLoad() {
        super.viewDidLoad()

        if udajeKlienta.detiJmena[kidID] == String() {
            
            self.title = "Dítě \(kidID + 1)"
            
        } else {
            
            self.title = udajeKlienta.detiJmena[kidID]
            
        }
        
        let backButton = UIBarButtonItem(image: UIImage(named: "zpet"), style: .Plain, target: self, action: #selector(DiteSporeniTableViewController.zpetButton))
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Graf", style: .Plain, target: self, action: #selector(DiteSporeniTableViewController.segueToGraph))
        
        let value1 = udajeKlienta.detiMesicneSporeni[kidID]
        
        if value1 != Int() {
            
            textField1Value = value1.currencyFormattingWithSymbol("Kč")
            slider1Value = Float(value1)/100
            stepper1Value = Double(value1)
            
        }
        
        let value2 = udajeKlienta.detiDoKdySporeni[kidID]
        
        if value2 != Int() {
            
            textField2Value = value2.currencyFormattingWithSymbol("let")
            slider2Value = Float(value2)
            stepper2Value = Double(value2)
            
        }
        
        let value3 = udajeKlienta.detiUrok[kidID]
        
        if value3 != Float() {
            
            textField3Value = value3.currencyFormattingWithSymbol("%")
            slider3Value = Float(value3)*10
            stepper3Value = Double(value3)*10
            
        }
        
        
        pocitani()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        endEditingNow()
        
    }
    
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
        
        let penizeBezUroku = dobaNaMesice*mesicniUlozka //penize, ktere tam klient zaslal. Tato hodnota nezapocitava uroky
        var celkemUrok = nasporenaCastka - penizeBezUroku
        
        nasporenaCastka = round(nasporenaCastka)
        celkemUrok = round(celkemUrok)
        
        let nasporenaCastkaInt:Int = Int(nasporenaCastka)
        let celkemUrokInt:Int = Int(celkemUrok)
        
        label1Value = nasporenaCastkaInt.currencyFormattingWithSymbol("Kč")
        label2Value = celkemUrokInt.currencyFormattingWithSymbol("Kč")
        
        //user defaults values
        udajeKlienta.detiMesicneSporeni[kidID] = Int(mesicniUlozka)
        udajeKlienta.detiDoKdySporeni[kidID] = Int(doba)
        udajeKlienta.detiUrok[kidID] = urok
        udajeKlienta.detiCilovaCastka[kidID] = nasporenaCastkaInt
        
        //values for segue - graph view
        celkovaUlozkaGlobal = Int(penizeBezUroku)
        dobaGlobal = Int(doba)
        arrayOfInterestSegue = arrayOfInterestGlobal
        arrayOfInterestGlobal = []
        
        udajeKlienta.grafCelkovaUlozka[kidID] = celkovaUlozkaGlobal
        udajeKlienta.grafDobaSporeni[kidID] = dobaGlobal
        
        if kidID == 0 {
            
            udajeKlienta.grafArrayUrok1 = arrayOfInterestSegue
            
        } else if kidID == 1{
            
            udajeKlienta.grafArrayUrok2 = arrayOfInterestSegue

        } else if kidID == 2 {
            
            udajeKlienta.grafArrayUrok3 = arrayOfInterestSegue
            
        } else {
            
            udajeKlienta.grafArrayUrok4 = arrayOfInterestSegue
            
        }
        
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
            
            return 3
            
        } else {
            
            return 2
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("jmeno") as! diteJmeno
            
            cell.diteJmeno.delegate = self
            cell.diteJmeno.tag = 1
            cell.diteJmeno.text = udajeKlienta.detiJmena[kidID]
            
            return cell
        
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("mesicniPlatba") as! detiMesicniPlatba
                
                cell.mesicniPlatbaTextField.delegate = self
                cell.mesicniPlatbaTextField.tag = 2
                cell.mesicniPlatbaTextField.text = textField1Value
                
                cell.mesicniPlatbaSlider.addTarget(self, action: #selector(DiteSporeniTableViewController.mesicniPlatbaSliderAction(_:)), forControlEvents: .ValueChanged)
                cell.mesicniPlatbaSlider.value = slider1Value
                
                cell.mesicniPlatbaStepper.addTarget(self, action: #selector(DiteSporeniTableViewController.mesicniPlatbaStepperAction(_:)), forControlEvents: .ValueChanged)
                cell.mesicniPlatbaStepper.value = stepper1Value
                
                return cell
                
            } else if indexPath.row == 1 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("doba") as! detiDoba
                
                cell.dobaTextField.delegate = self
                cell.dobaTextField.tag = 3
                cell.dobaTextField.text = textField2Value
                
                cell.dobaSlider.addTarget(self, action: #selector(DiteSporeniTableViewController.dobaSliderAction(_:)), forControlEvents: .ValueChanged)
                cell.dobaSlider.value = slider2Value
                
                cell.dobaStepper.addTarget(self, action: #selector(DiteSporeniTableViewController.dobaStepperAction(_:)), forControlEvents: .ValueChanged)
                cell.dobaStepper.value = stepper2Value
                
                return cell
            
            } else {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("rocniUrok") as! rocniUrok
                
                cell.urokTextField.delegate = self
                cell.urokTextField.tag = 4
                cell.urokTextField.text = textField3Value
                
                cell.urokSlider.addTarget(self, action: #selector(DiteSporeniTableViewController.urokSliderAction(_:)), forControlEvents: .ValueChanged)
                cell.urokSlider.value = slider3Value
                
                cell.urokStepper.addTarget(self, action: #selector(DiteSporeniTableViewController.urokStepperAction(_:)), forControlEvents: .ValueChanged)
                cell.urokStepper.value = stepper3Value
                
                return cell
            }

        } else {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("celkemNasporeno") as! detiLabels
                
                cell.celkemNasporenoLabel.text = label1Value
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("vyplacenyUrok") as! detiLabels
                
                cell.vyplacenyUrokLabel.text = label2Value
                
                return cell
            }
            
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 44
            
        } else if indexPath.section == 1 {
            
            return 75
        }
        
        return 30
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
    
    //MARK: - textfield methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField.text != "" && textField.tag > 0 {
            
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
            
            udajeKlienta.detiJmena[kidID] = textField.text!
            
        } else if textField.tag == 2 {
            
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
            
        } else if textField.tag == 3 {
            
            var num = Int((textField.text! as NSString).intValue)
            
            if num > 35 {
                
                num = 35
            }
            
            if num < 1 || textField.text == "" {
                
                num = 1
                
            }
            
            slider2Value = Float(num)
            stepper2Value = Double(num)
            textField2Value = num.currencyFormattingWithSymbol("let")
            
            pocitani()
            
        } else if textField.tag == 4 {
            
            let str = textField.text?.stringByReplacingOccurrencesOfString(",", withString: ".")
            var num = Float((str! as NSString).floatValue)
            
            if num > 10 {
                
                num = 10
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
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        let toolbar = UIToolbar()
        textField.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true
    }
    
    //MARK: - textfield formatting
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var result = true
        let prospectiveText = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if string.characters.count > 0 && textField.tag > 1 {
            
            let disallowedCharacterSet = NSCharacterSet(charactersInString: "0123456789").invertedSet
            let replacementStringIsLegal = string.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
            var resultingStringLengthIsLegal = Bool()
            
           if textField.tag == 2 {
                
                resultingStringLengthIsLegal = prospectiveText.characters.count <= 8
                
            } else if textField.tag == 3 {
                
                resultingStringLengthIsLegal = prospectiveText.characters.count <= 2
                
            } else if textField.tag == 4 {
                
                resultingStringLengthIsLegal = prospectiveText.characters.count <= 5
                
            }
            
            let scanner:NSScanner = NSScanner.localizedScannerWithString(prospectiveText) as! NSScanner
            let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.atEnd
            
            result = replacementStringIsLegal && resultingStringLengthIsLegal && resultingTextIsNumeric
            
        }
        
        return result
        
    }
    
    //MARK: - prepareForSegue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "sporeniGraf" {
            
            let svc = segue.destinationViewController as! SavingsGrafTableViewController;
            
            print(celkovaUlozkaGlobal)
            print(arrayOfInterestSegue)
            print(dobaGlobal)
            
            svc.toPassCelkovaUlozka = celkovaUlozkaGlobal
            svc.toPassArrayInterest = arrayOfInterestSegue
            svc.toPassDobaGlobal = dobaGlobal
        }
    }
    
    func segueToGraph() {
        
        self.performSegueWithIdentifier("sporeniGraf", sender: self)
        
    }
    
    func zpetButton() {
        
        endEditingNow()
        
        if hasProvidedAllInfo().0 == false {
            
            let alert = UIAlertController(title: "Opravdu chcete pokračovat?", message: "Zbývá doplnit tyto údaje:\n\n\(hasProvidedAllInfo().1)" , preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Doplnit údaje", style: .Cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Pokračovat", style: .Default, handler: { (action) in
                
                self.navigationController?.popViewControllerAnimated(true)
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    
    }

    
    func hasProvidedAllInfo() -> (Bool, String) {
        
        let jmeno = "Jméno"
        let cilovaCastka = "Cílová částka"
        let doKdy = "Doba"
        let mesicne = "Měsíčně"
        
        var values: [AnyObject?] = [udajeKlienta.detiJmena[kidID], textField1Value, textField2Value, textField3Value]
        var labels = [jmeno, cilovaCastka, doKdy, mesicne]
        
        
        var arr: [String] = []
        
        for i in 0 ..< 4 {
            
            if i == 0 {
                
                if values[0] as! String == "" {
                
                    arr.append(labels[i])
                
                }
            
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
            
            udajeKlienta.detiJeVyplneno[kidID] = true
            
            return (true, str)
            
        } else {
            
            udajeKlienta.detiJeVyplneno[kidID] = false
            
            return (false, str)
        }
        
        
    }
    

}
