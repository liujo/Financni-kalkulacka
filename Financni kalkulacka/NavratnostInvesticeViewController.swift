//
//  NavratnostInvesticeViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 10.09.15.
//  Copyright (c) 2015 Joseph Liu. All rights reserved.
//

import UIKit

class NavratnostInvesticeViewController: UIViewController, UITextFieldDelegate {
    
    var activeField: UITextField?

    //MARK: - UI outlets
    @IBOutlet var scrollView: UIScrollView!
    
    //UITextFields
    @IBOutlet var kupniCenaTextField: UITextField!
    @IBOutlet var vyseNajmuTextField: UITextField!
    @IBOutlet var zalohyTextField: UITextField!
    
    //UISliders
    @IBOutlet var kupniCenaSlider: UISlider!
    @IBOutlet var vyseNajmuSlider: UISlider!
    @IBOutlet var zalohySlider: UISlider!
    
    //UISteppers
    @IBOutlet weak var stepper1: UIStepper!
    @IBOutlet weak var stepper2: UIStepper!
    @IBOutlet weak var stepper3: UIStepper!
    
    //vysledne labely
    @IBOutlet var zhodnoceniLabel: UILabel!
    @IBOutlet var navratnostLabel: UILabel!
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kupniCenaTextField.delegate = self
        vyseNajmuTextField.delegate = self
        zalohyTextField.delegate = self
        
        self.title = "Návratnost investice"
        scrollView.alwaysBounceVertical = true
        
        
        pocitat()
        
    }
        
    //MARK: - rovnice vypoctu
    
    func pocitat() {
        
        //udaje z UI elementu na variables
        
        //vymazani mezer
        let kupniCenaBezMezer = kupniCenaTextField.text?.condenseWhitespace()
        let vyseNajmuBezMezer = vyseNajmuTextField.text?.condenseWhitespace()
        let zalohyBezMezer = zalohyTextField.text?.condenseWhitespace()
        
        //prevedeni na integery
        let kupniCena = Float((kupniCenaBezMezer! as NSString).floatValue)
        let vyseNajmu = Float((vyseNajmuBezMezer! as NSString).floatValue)
        let zalohy = Float((zalohyBezMezer! as NSString).floatValue)
        
        // 1)
        // tady spocitam zhodnoceni
        ///rovnice: [(hruby najem - zalohy) * mesice]/kupni cena = zhodnoceni v procentech/100
        
        var zhodnoceni = (vyseNajmu - zalohy) * 12
        zhodnoceni = zhodnoceni/kupniCena
        zhodnoceni = zhodnoceni*100
    
        zhodnoceni = round(zhodnoceni*10)/10
        
        zhodnoceniLabel.text = "\(zhodnoceni) % ročně"
        zhodnoceniLabel.text = zhodnoceniLabel.text?.stringByReplacingOccurrencesOfString(".", withString: ",")
        
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
            navratnostLabel.text = "\(navratnostInt/12) let"
        
        } else {
            
            print("roky: \(round(navratnost/12)), mesice: \(navratnost%12)")
            navratnostLabel.text = "\(navratnostInt/12) let a \(navratnostInt%12) měsíců"
        }
        
    }
    
    //MARK: - slider IBAction

    @IBAction func kupniCenaSliderAction(sender: UISlider) {
        
        let a = Int(sender.value) * 100000
        kupniCenaTextField.text = a.currencyFormattingWithSymbol("Kč")
        stepper1.value = Double(a)
        
        pocitat()
    }
   
    @IBAction func vyseNajmuSliderAction(sender: UISlider) {
        
        let a = Int(sender.value) * 100
        vyseNajmuTextField.text = a.currencyFormattingWithSymbol("Kč")
        stepper2.value = Double(a)
        
        pocitat()
    }

    @IBAction func zalohySliderAction(sender: UISlider) {
        
        let a = Int(sender.value) * 100
        zalohyTextField.text = a.currencyFormattingWithSymbol("Kč")
        stepper3.value = Double(a)
        
        pocitat()
    }
    
    //MARK: - stepper actions
    
    @IBAction func kupniCenaStepper(sender: UIStepper) {
        
        let a = Int(sender.value)
        
        kupniCenaTextField.text = a.currencyFormattingWithSymbol("Kč")
        kupniCenaSlider.value = Float(a)/100000
        
        pocitat()
        
    }
    
    @IBAction func mesicniPrijemStepper(sender: UIStepper) {
        
        let b = Int(sender.value)
        
        vyseNajmuTextField.text = b.currencyFormattingWithSymbol("Kč")
        vyseNajmuSlider.value = Float(b)/100
        
        pocitat()
    }
    
    @IBAction func nakladyStepper(sender: UIStepper) {
        
        let c = Int(sender.value)
        
        zalohyTextField.text = c.currencyFormattingWithSymbol("Kč")
        zalohySlider.value = Float(c)/100
        
        pocitat()
        
    }
    
    
    //MARK: - text field formatting
    @IBAction func kupniCenaTextFieldAction(sender: AnyObject) {
        
        var num = Int((kupniCenaTextField.text! as NSString).intValue)
        
        if num > 200000000 {
            
            num = 200000000
        }
        
        if num < 100000 || kupniCenaTextField.text == "" {
            
            num = 100000
        }
        
        
        kupniCenaSlider.value = Float((kupniCenaTextField.text! as NSString).floatValue) / 100000
        stepper1.value = Double(num)
        
        kupniCenaTextField.text = num.currencyFormattingWithSymbol("Kč")
        
        pocitat()
    }
    
    @IBAction func vyseNajmuTextFieldAction(sender: AnyObject) {
        
        var num = Int((vyseNajmuTextField.text! as NSString).intValue)
        
        if num > 3000000 {
            
            num = 3000000
        }
        
        if num < 3000 || vyseNajmuTextField.text == "" {
            
            num = 3000
        }
        
        vyseNajmuSlider.value = Float((vyseNajmuTextField.text! as NSString).floatValue) / 100
        stepper2.value = Double(num)
        
        vyseNajmuTextField.text = num.currencyFormattingWithSymbol("Kč")
        
        pocitat()
    }
    
    @IBAction func zalohyTextFieldAction(sender: AnyObject) {
        
        var num = Int((zalohyTextField.text! as NSString).intValue)
        
        if num > 200000 {
            
            num = 200000
        }
        
        if num < 500 || zalohyTextField.text == "" {
            
            num = 500
        }
        
        zalohySlider.value = Float((zalohyTextField.text! as NSString).floatValue) / 100
        stepper3.value = Double(num)
        
        zalohyTextField.text = num.currencyFormattingWithSymbol("Kč")
        
        pocitat()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var result = true
        let prospectiveText = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        
        if string.characters.count > 0 {
            let disallowedCharacterSet = NSCharacterSet(charactersInString: "0123456789").invertedSet
            let replacementStringIsLegal = string.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
            
            var int = Int()
            
            if textField.tag == 1 {
                
                int = 9
            
            } else if textField.tag == 2 {
                
                int = 7
                
            } else {
                
                int = 6
            }
            
            let resultingStringLengthIsLegal = prospectiveText.characters.count <= int
            
            let scanner = NSScanner(string: prospectiveText)
            let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.atEnd
            
            result = replacementStringIsLegal && resultingStringLengthIsLegal && resultingTextIsNumeric
        }
        
        return result
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField.text != "" {
        
            textField.text = textField.text?.chopSuffix(2).condenseWhitespace()
        
        }
        
        activeField = textField
        
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        activeField = nil
    }
    
    //MARK: - schovat klavesnici
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        let toolbar = UIToolbar()
        textField.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true
    }
        
    

    
}
