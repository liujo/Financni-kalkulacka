//
//  HypotekaTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 13.05.16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import UIKit

class HypotekaTableViewController: UITableViewController, UITextFieldDelegate {
    
    //MARK: - global variables to pass
    
    var pocetRoku = Int()
    var pujcenyObnos = Int()
    var celkemUrok = Int()
    
    var mesicniUrok = Float()
    var mesicniPlatbaVcetneUroku = Int()
    
    //MARK: - local variables
    
    var textField1Value = "3 000 000 Kč"
    var textField2Value = "25 let"
    var textField3Value = "1,8 %"
    
    var label1Value = "12 426 Kč"
    var label2Value = "727 682 Kč"
    var label3Value = "3 727 682 Kč"
    
    var slider1Value: Float = 30
    var slider2Value: Float = 25
    var slider3Value: Float = 18
    
    var stepper1Value: Double = 3000000
    var stepper2Value: Double = 25
    var stepper3Value: Double = 18

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Hypoteční úvěr"
        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Graf", style: .plain, target: self, action: #selector(HypotekaTableViewController.showGraph))
        
        pocitani()
        
    }
    
    func pocitani() {
        
        //preformatovat pujcenou castku
        let castkaBezMezerCelkem = textField1Value.condenseWhitespace()
        //formatovani urokove sazby
        let urokCarka = textField3Value.replacingOccurrences(of: ",", with: ".")
        
        let castkaCelkem = Float((castkaBezMezerCelkem as NSString).floatValue) //jistina
        let doba = Float((textField2Value as NSString).floatValue)*12 //celkem doba prevedena na mesice
        let mesicniUrok1 = Float((urokCarka as NSString).floatValue)/12*0.01 //mesicni urok. mesicniUrok = rocniUrok/12
        
        //rovnice
        let vDole = 1+mesicniUrok1
        let v = 1/vDole
        
        let aNahore = castkaCelkem*mesicniUrok1
        let aDole = 1-pow(v, doba)
        let a = aNahore/aDole
        
        //vysledky
        
        let zaplatit = a*doba //castka, kteoru klient zaplati (jistina + urok)
        
        let celkemUrok1 = zaplatit - castkaCelkem
        
        let prumernaMesicniPlatba = a
        
        //Prevedeni z floatu na Int
        
        let prumernaMesicniPlatbaInt:Int = Int(round(prumernaMesicniPlatba))
        let celkemUrokInt:Int = Int(round(celkemUrok1))
        let zaplatitInt:Int = Int(round(zaplatit))
        
        //Formatovani vysledku
        
        let formattedPrumernaMesicniPlatba = prumernaMesicniPlatbaInt.currencyFormattingWithSymbol(currencySymbol: "Kč")
        let formattedCelkemUrok = celkemUrokInt.currencyFormattingWithSymbol(currencySymbol: "Kč")
        let formattedZaplatit = zaplatitInt.currencyFormattingWithSymbol(currencySymbol: "Kč")
        
        //vysledne labely
        
        label1Value = formattedPrumernaMesicniPlatba
        label2Value = formattedCelkemUrok
        label3Value = formattedZaplatit
        
        pocetRoku = Int(doba)/12
        pujcenyObnos = Int(castkaCelkem)
        celkemUrok = celkemUrokInt
        mesicniUrok = mesicniUrok1
        mesicniPlatbaVcetneUroku = prumernaMesicniPlatbaInt
        
        tableView.reloadData()
        
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "castka") as! HypoCell
            
            cell.castkaTextField.delegate = self
            cell.castkaTextField.tag = 1
            cell.castkaTextField.text = textField1Value
            
            cell.castkaSlider.addTarget(self, action: #selector(HypotekaTableViewController.castkaSliderAction(sender:)), for: .valueChanged)
            cell.castkaSlider.value = slider1Value
            
            cell.castkaStepper.addTarget(self, action: #selector(HypotekaTableViewController.castkaStepperAction(sender:)), for: .valueChanged)
            cell.castkaStepper.value = stepper1Value
            
            return cell
        
        } else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "doba") as! HypoCell
            
            cell.dobaTextField.delegate = self
            cell.dobaTextField.tag = 2
            cell.dobaTextField.text = textField2Value
            
            cell.dobaSlider.addTarget(self, action: #selector(HypotekaTableViewController.dobaSliderAction(sender:)), for: .valueChanged)
            cell.dobaSlider.value = slider2Value
            
            cell.dobaStepper.addTarget(self, action: #selector(HypotekaTableViewController.dobaStepperAction(sender:)), for: .valueChanged)
            cell.dobaStepper.value = stepper2Value
            
            return cell
            
        } else if indexPath.row == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "rocniUrok") as! HypoCell
            
            cell.urokTextField.delegate = self
            cell.urokTextField.tag = 3
            cell.urokTextField.text = textField3Value
            
            cell.urokSlider.addTarget(self, action: #selector(HypotekaTableViewController.urokSliderAction(sender:)), for: .valueChanged)
            cell.urokSlider.value = slider3Value
            
            cell.urokStepper.addTarget(self, action: #selector(HypotekaTableViewController.urokStepperAction(sender:)), for: .valueChanged)
            cell.urokStepper.value = stepper3Value
            
            return cell
            
        } else if indexPath.row == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "mesicniPlatba") as! HypoCell
            
            cell.mesicniPlatbaLabel.text = label1Value
            
            return cell
            
        } else if indexPath.row == 4 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "celkemUrok") as! HypoCell
            
            cell.celkemUrokLabel.text = label2Value
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "klientCelkemZaplati") as! HypoCell
            
            cell.klientCelkemZaplatiLabel.text = label3Value
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row < 3 {
            
            return 75
        
        }
        
        return 30
    }
    
    //MARK: slider ibactions
    
    @objc func castkaSliderAction(sender: UISlider) {
        
        let a = Int(sender.value)*100000
        
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
    
    @objc func castkaStepperAction(sender: UIStepper) {
        
        let a = Int(sender.value)
        
        textField1Value = a.currencyFormattingWithSymbol(currencySymbol: "Kč")
        slider1Value = Float(sender.value)/100000
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
    
    //MARK: - text field actions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.text != "" {
            
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
            
            var num = Int((textField.text! as NSString).intValue)
            
            if num > 50000000 {
                
                num = 50000000
            }
            
            if num < 100000 || textField.text == "" {
                
                num = 100000
            }
            
            slider1Value = Float(num)/100000
            stepper1Value = Double(num)
            textField1Value = num.currencyFormattingWithSymbol(currencySymbol: "Kč")
            
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
            textField2Value = num.currencyFormattingWithSymbol(currencySymbol: "let")
            
            pocitani()
        
        } else if textField.tag == 3 {
            
            let str = textField.text?.replacingOccurrences(of: ",", with: ".")//stringByReplacingOccurrencesOfString(",", withString: ".")
            var num = Float((str! as NSString).floatValue)
            
            if num > 20 {
                
                num = 20
            }
            
            if num < 1.3 || textField.text == "" {
                
                num = 1.3
            }
            
            slider3Value = num*10
            stepper3Value = Double(num)*10
            textField3Value = num.currencyFormattingWithSymbol(currencySymbol: "%")
            
            pocitani()
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result = true
        let prospectiveText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
        if string.count > 0 {
            
            var int = Int()
            
            if textField.tag == 1 {
                
                int = 8

            } else if textField.tag == 2 {
                
                int = 2
                
            } else {
                
                int = 4
            }
            
            let resultingStringLengthIsLegal = prospectiveText.count <= int
                
            let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789.,").inverted
            let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil

            let scanner = Scanner.localizedScanner(with: prospectiveText) as! Scanner
            let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.isAtEnd
                
            result = replacementStringIsLegal && resultingStringLengthIsLegal && resultingTextIsNumeric
        
        }
        
        return result
    
    }
    
    //MARK: - schovat klavesnici
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let toolbar = UIToolbar()
        textField.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true
    }
    
    // MARK: - segue
    
    @objc func showGraph() {
        
        self.performSegue(withIdentifier: "grafSegue", sender: self)
        
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "grafSegue" {
            
            let svc = segue.destination as! HypotekaGrafTableViewController
            
            svc.toPassPocetRokuGlobal = pocetRoku
            svc.toPassPujcenyObnosGlobal = pujcenyObnos
            svc.toPassCelkemUrokGlobal = celkemUrok
            svc.toPassMesicniUrok = mesicniUrok
            svc.toPassMesicniPlatbaVcetneUrokuGlobal = mesicniPlatbaVcetneUroku
        }
    }

    
    
}
