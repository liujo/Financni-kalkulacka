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
        
        let backButton = UIBarButtonItem(image: UIImage(named: "zpet"), style: .plain, target: self, action: #selector(DiteSporeniTableViewController.zpetButton))
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Graf", style: .plain, target: self, action: #selector(DiteSporeniTableViewController.segueToGraph))
        
        let value1 = udajeKlienta.detiMesicneSporeni[kidID]
        
        if value1 != Int() {
            
            textField1Value = value1.currencyFormattingWithSymbol(currencySymbol: "Kč")
            slider1Value = Float(value1)/100
            stepper1Value = Double(value1)
            
        }
        
        let value2 = udajeKlienta.detiDoKdySporeni[kidID]
        
        if value2 != Int() {
            
            textField2Value = value2.currencyFormattingWithSymbol(currencySymbol: "let")
            slider2Value = Float(value2)
            stepper2Value = Double(value2)
            
        }
        
        let value3 = udajeKlienta.detiUrok[kidID]
        
        if value3 != Float() {
            
            textField3Value = value3.currencyFormattingWithSymbol(currencySymbol: "%")
            slider3Value = Float(value3)*10
            stepper3Value = Double(value3)*10
            
        }
        
        
        pocitani()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        endEditingNow()
        
    }
    
    func pocitani() {
        
        let num = textField1Value.condenseWhitespace() //formatovani mesicni platby
        let urokCarka = textField3Value.replacingOccurrences(of: ",", with: ".")//vymena carky za tecku

        let mesicniUlozka:Float = Float((num as NSString).floatValue)
        let doba:Float = Float((textField2Value as NSString).floatValue)
        let urok:Float = Float((urokCarka as NSString).floatValue) //roky
        
        let urokRozdelen = urok/12*0.01 //rozdeleno na mesicni urok a vynasobeno 0.01
        let dobaNaMesice = doba*12
        
        var nasporenaCastka = Float()
        
        var d = Int()
        
        //for var i:Float = Float(1); i <= dobaNaMesice; i++ {
        for i in 1 ... Int(dobaNaMesice) {
            
            nasporenaCastka = nasporenaCastka + mesicniUlozka + nasporenaCastka*urokRozdelen
            
            if i % 12 == 0 {
                
                //storeNumber += Int(round(nasporenaCastka)) - i*12*mesicniUlozka
                let a = round(nasporenaCastka)
                let b = Float(i)*mesicniUlozka
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
        
        label1Value = nasporenaCastkaInt.currencyFormattingWithSymbol(currencySymbol: "Kč")
        label2Value = celkemUrokInt.currencyFormattingWithSymbol(currencySymbol: "Kč")
        
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

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0 {
            
            return 1
        
        } else if section == 1 {
            
            return 3
            
        } else {
            
            return 2
        }
        
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "jmeno") as! diteJmeno
            
            cell.diteJmeno.delegate = self
            cell.diteJmeno.tag = 1
            cell.diteJmeno.text = udajeKlienta.detiJmena[kidID]
            
            return cell
        
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "mesicniPlatba") as! detiMesicniPlatba
                
                cell.mesicniPlatbaTextField.delegate = self
                cell.mesicniPlatbaTextField.tag = 2
                cell.mesicniPlatbaTextField.text = textField1Value
                
                cell.mesicniPlatbaSlider.addTarget(self, action: #selector(DiteSporeniTableViewController.mesicniPlatbaSliderAction(sender:)), for: .valueChanged)
                cell.mesicniPlatbaSlider.value = slider1Value
                
                cell.mesicniPlatbaStepper.addTarget(self, action: #selector(DiteSporeniTableViewController.mesicniPlatbaStepperAction(sender:)), for: .valueChanged)
                cell.mesicniPlatbaStepper.value = stepper1Value
                
                return cell
                
            } else if indexPath.row == 1 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "doba") as! detiDoba
                
                cell.dobaTextField.delegate = self
                cell.dobaTextField.tag = 3
                cell.dobaTextField.text = textField2Value
                
                cell.dobaSlider.addTarget(self, action: #selector(DiteSporeniTableViewController.dobaSliderAction(sender:)), for: .valueChanged)
                cell.dobaSlider.value = slider2Value
                
                cell.dobaStepper.addTarget(self, action: #selector(DiteSporeniTableViewController.dobaStepperAction(sender:)), for: .valueChanged)
                cell.dobaStepper.value = stepper2Value
                
                return cell
            
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "rocniUrok") as! rocniUrok
                
                cell.urokTextField.delegate = self
                cell.urokTextField.tag = 4
                cell.urokTextField.text = textField3Value
                
                cell.urokSlider.addTarget(self, action: #selector(DiteSporeniTableViewController.urokSliderAction(sender:)), for: .valueChanged)
                cell.urokSlider.value = slider3Value
                
                cell.urokStepper.addTarget(self, action: #selector(DiteSporeniTableViewController.urokStepperAction(sender:)), for: .valueChanged)
                cell.urokStepper.value = stepper3Value
                
                return cell
            }

        } else {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "celkemNasporeno") as! detiLabels
                
                cell.celkemNasporenoLabel.text = label1Value
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "vyplacenyUrok") as! detiLabels
                
                cell.vyplacenyUrokLabel.text = label2Value
                
                return cell
            }
            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 44
            
        } else if indexPath.section == 1 {
            
            return 75
        }
        
        return 30
    }
    
    //MARK: slider ibactions
    
    @objc func mesicniPlatbaSliderAction(sender: UISlider) {
        
        let a = Int(sender.value)*100
        
        textField1Value = a.currencyFormattingWithSymbol(currencySymbol: "Kč")
        stepper1Value = Double(a)
        slider1Value = sender.value
        
        pocitani()
        
    }
    
    @objc func dobaSliderAction(sender: UISlider) {
        
        let b = Int(sender.value)
        
        textField2Value = b.currencyFormattingWithSymbol(currencySymbol: "let")
        stepper2Value = Double(b)
        slider2Value = sender.value
        
        pocitani()
        
    }
    
    @objc func urokSliderAction(sender: UISlider) {
        
        var c = Float(sender.value)
        c = round(c)
        c = c * 0.1
        
        
        textField3Value = c.currencyFormattingWithSymbol(currencySymbol: "%")
        stepper3Value = Double(sender.value)
        slider3Value = sender.value
        
        pocitani()
        
    }
    
    //MARK: - stepper ibactions
    
    @objc func mesicniPlatbaStepperAction(sender: UIStepper) {
        
        let a = Int(sender.value)
        
        textField1Value = a.currencyFormattingWithSymbol(currencySymbol: "Kč")
        slider1Value = Float(sender.value)/100
        stepper1Value = sender.value
        
        pocitani()
        
    }
    
    @objc func dobaStepperAction(sender: UIStepper) {
        
        let b = Int(sender.value)
        
        textField2Value = b.currencyFormattingWithSymbol(currencySymbol: "let")
        slider2Value = Float(sender.value)
        stepper2Value = sender.value
        
        pocitani()
        
    }
    
    @objc func urokStepperAction(sender: UIStepper) {
        
        var c = Float(sender.value)
        c = round(c)
        c = c * 0.1
        
        textField3Value = c.currencyFormattingWithSymbol(currencySymbol: "%")
        slider3Value = Float(sender.value)
        stepper3Value = sender.value
        
        pocitani()
        
    }
    
    //MARK: - textfield methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.text != "" && textField.tag > 0 {
            
            var int = Int()
            
            if textField.tag == 3 {
                
                int = 1
                
            } else {
                
                int = 3
            }
            
            textField.text = textField.text?.chopSuffix(count: int).condenseWhitespace()
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
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
            textField1Value = num.currencyFormattingWithSymbol(currencySymbol: "Kč")
            
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
            textField2Value = num.currencyFormattingWithSymbol(currencySymbol: "let")
            
            pocitani()
            
        } else if textField.tag == 4 {
            
            let str = textField.text?.replacingOccurrences(of: ",", with: ".")
            var num = Float((str! as NSString).floatValue)
            
            if num > 10 {
                
                num = 10
            }
            
            if num < 1 || textField.text == "" {
                
                num = 1
            }
            
            slider3Value = num*10
            stepper3Value = Double(num)*10
            textField3Value = num.currencyFormattingWithSymbol(currencySymbol: "%")
            
            pocitani()
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let toolbar = UIToolbar()
        textField.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true
    }
    
    //MARK: - textfield formatting
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var result = true
        let prospectiveText = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        if string.count > 0 && textField.tag > 1 {
            
            let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789").inverted
            let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
            var resultingStringLengthIsLegal = Bool()
            
           if textField.tag == 2 {
                
                resultingStringLengthIsLegal = prospectiveText.count <= 8
                
            } else if textField.tag == 3 {
                
                resultingStringLengthIsLegal = prospectiveText.count <= 2
                
            } else if textField.tag == 4 {
                
                resultingStringLengthIsLegal = prospectiveText.count <= 5
                
            }
            
            let scanner = Scanner.localizedScanner(with: prospectiveText) as! Scanner
            let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.isAtEnd

            result = replacementStringIsLegal && resultingStringLengthIsLegal && resultingTextIsNumeric
            
        }
        
        return result
        
    }
    
    //MARK: - prepareForSegue
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "sporeniGraf" {
            
            let svc = segue.destination as! SavingsGrafTableViewController;
            
            print(celkovaUlozkaGlobal)
            print(arrayOfInterestSegue)
            print(dobaGlobal)
            
            svc.toPassCelkovaUlozka = celkovaUlozkaGlobal
            svc.toPassArrayInterest = arrayOfInterestSegue
            svc.toPassDobaGlobal = dobaGlobal
        }
    }
    
    @objc func segueToGraph() {
        
        self.performSegue(withIdentifier: "sporeniGraf", sender: self)
        
    }
    
    @objc func zpetButton() {
        
        endEditingNow()
        
        if hasProvidedAllInfo().0 == false {
            
            let alert = UIAlertController(title: "Opravdu chcete pokračovat?", message: "Zbývá doplnit tyto údaje:\n\n\(hasProvidedAllInfo().1)" , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Doplnit údaje", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Pokračovat", style: .default, handler: { (action) in
                
                self.navigationController?.popViewController(animated: true)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            self.navigationController?.popViewController(animated: true)
        }
    
    }

    
    func hasProvidedAllInfo() -> (Bool, String) {
        
        let jmeno = "Jméno"
        let cilovaCastka = "Cílová částka"
        let doKdy = "Doba"
        let mesicne = "Měsíčně"
        
        var values: [AnyObject?] = [udajeKlienta.detiJmena[kidID] as AnyObject, textField1Value as AnyObject, textField2Value as AnyObject, textField3Value as AnyObject]
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
