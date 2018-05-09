//
//  SalaryViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 11.06.15.
//  Copyright (c) 2015 Joseph Liu. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class SalaryViewController: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {
    
    //MARK: - UI elements
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var salaryWholeView: UIView!
    
    @IBOutlet var hrubaMzdaTextField: UITextField!
    
    @IBOutlet var stepperOutlet: UIStepper!
    @IBOutlet var pocetDetiLabel: UILabel!
    
    @IBOutlet var castecnaInvalidita: UISwitch!
    @IBOutlet var plnaInvalidita: UISwitch!
    @IBOutlet var drzitelZTP: UISwitch!
    @IBOutlet var student: UISwitch!
    @IBOutlet var manzelkaPrijem: UISwitch!
    
    //vysledne labely
    @IBOutlet var cistaMzdaLabel: UILabel!
    @IBOutlet var superHrubaMzdaLabel: UILabel!
    @IBOutlet var socialniPojisteniZamestnanecLabel: UILabel!
    @IBOutlet var zdravotniPojisteniZamestnanecLabel: UILabel!
    @IBOutlet var socialniPojisteniZamestnavatelLAbel: UILabel!
    @IBOutlet var zdravotniPojisteniZamestnavatelLabel: UILabel!
    
    //MARK: - danove slevy
    
    var slevaZaPoplatnika:Float = Float(2070) //kdyz mam manzela/manzelku s vlastnimi prijmy do 68 000 rocne, tak sleva dalsich 2070. Vyplaci se rocne castkou 24840
    var slevaStudenta = Float()
    var invaliditaLehci = Float() //1. a 2. stupen
    var invaliditaTezka = Float() //3. stupen
    var drzitelPrukazuZTP = Float() //drzitel prukazu ZTP/P

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.hrubaMzdaTextField.delegate = self
        
        self.title = "Čistá mzda"
        
        //stepper setup
        stepperOutlet.autorepeat = true
        stepperOutlet.maximumValue = 10
        
        scrollView.alwaysBounceVertical = true
        
        
        let b = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(self.sendEmail))
        self.navigationItem.rightBarButtonItem = b
    }
    
    //MARK: - rovnice ciste mzdy
    
    func spocitat() {
        
        let hrubaMzdaBezMezer = condenseWhitespace(string: hrubaMzdaTextField.text!)
        
        //hruba mzda
        let hrubaMzda:Float = Float((hrubaMzdaBezMezer as NSString).floatValue) //penize, ktere zamestnanec dostane od zamestnavatele
        
        //povinne odvody zamestnance ze sve hrube mzdy
        let zdravotniPojisteni = 0.045*hrubaMzda //4,5% z hrube mzdy.
        let socialniPojisteni = 0.065*hrubaMzda //6,5% z hrube mzdy
        
        print(zdravotniPojisteni)
        print(socialniPojisteni)
        
        //povinne odvody zamestnavatele z hrube mzdy zamestnance
        let zdravotniPojisteniSef = 0.09*hrubaMzda
        let socialniPojisteniSef = 0.25*hrubaMzda
        
        print(zdravotniPojisteniSef)
        print(socialniPojisteniSef)
        
        //solidarni dan
        var solidarniDan = Float()
        
        if hrubaMzda > 106444 {
            
            let rozdil = hrubaMzda - 106444.0
            solidarniDan = 0.07*rozdil
        }
        
        //superhruba mzda
        var superHrubaMzda = zdravotniPojisteniSef + socialniPojisteniSef + hrubaMzda
        superHrubaMzda = 100*round(superHrubaMzda/100)
        
        print(superHrubaMzda)
        
        //Danove slevy
        //deti
        let pocetDeti = Int((pocetDetiLabel.text)!)!
        var slevaDite = Int()//rocne max 60 300
        
        if pocetDeti == 1 {
            
            slevaDite = 1117
            
        } else if pocetDeti == 2 {
            
            slevaDite = 1117 + 1317
            
        } else if pocetDeti > 2 {
            
            let pocetDetiMinusDva = pocetDeti - 2
            slevaDite = 1117 + 1317 + 1417 * pocetDetiMinusDva
            
        } else {
            
            slevaDite = 0
        }
        
        //dan z prijmu fyzickych osob
        let dan:Float = Float(0.15*superHrubaMzda)
        print(dan)
        let zalohaNaDan:Float = dan + solidarniDan - Float(slevaZaPoplatnika) - slevaStudenta - invaliditaLehci - invaliditaTezka - Float(slevaDite) - drzitelPrukazuZTP
        
        print(zalohaNaDan)
        
        //vypocet ciste mzdy
        
        var mzda = hrubaMzda - zdravotniPojisteni - socialniPojisteni - zalohaNaDan
        mzda = round(mzda)
        
        let mzdaInt:Int = Int(mzda)
        
        cistaMzdaLabel.text = mzdaInt.currencyFormattingWithSymbol(currencySymbol: "Kč")
        superHrubaMzdaLabel.text = Int(superHrubaMzda).currencyFormattingWithSymbol(currencySymbol: "Kč")
        socialniPojisteniZamestnanecLabel.text = Int(socialniPojisteni).currencyFormattingWithSymbol(currencySymbol: "Kč")
        zdravotniPojisteniZamestnanecLabel.text = Int(zdravotniPojisteni).currencyFormattingWithSymbol(currencySymbol: "Kč")
        socialniPojisteniZamestnavatelLAbel.text = Int(socialniPojisteniSef).currencyFormattingWithSymbol(currencySymbol: "Kč")
        zdravotniPojisteniZamestnavatelLabel.text = Int(zdravotniPojisteniSef).currencyFormattingWithSymbol(currencySymbol: "Kč")
    }
    
        //MARK: - stepper and switches shanenigans

    @IBAction func stepperAction(sender: AnyObject) {
        
        pocetDetiLabel.text = "\(Int(stepperOutlet.value))"
        
        spocitat()
    }
    
    @IBAction func isLehceInvalidni(sender: AnyObject) {
        
        if castecnaInvalidita.isOn {
            
            invaliditaLehci = 210.0
        
        } else {
            
            invaliditaLehci = 0.0
        }
        
        print(invaliditaLehci)
        spocitat()
    }
    
    @IBAction func isPlneInvalidni(sender: AnyObject) {
        
        if plnaInvalidita.isOn {
            
            invaliditaTezka = 420.0
        
        } else {
            
            invaliditaTezka = 0.0
        }
        spocitat()
    }
    
    @IBAction func isDrzitelZTP(sender: AnyObject) {
        
        if drzitelZTP.isOn {
            
            drzitelPrukazuZTP = 1345.0
        
        } else {
            
            drzitelPrukazuZTP = 0.0
        }
        spocitat()
    }
    
    @IBAction func isStudent(sender: AnyObject) {
        
        if student.isOn {
            
            slevaStudenta = 335.0
        
        } else {
            
            slevaStudenta = 0.0
        }
        spocitat()
    }
    
    @IBAction func hasLowIncomePartner(sender: AnyObject) {
        
        if manzelkaPrijem.isOn {
            
            slevaZaPoplatnika = slevaZaPoplatnika + 2070
        } else {
            
            slevaZaPoplatnika = 2070
        }
        spocitat()
    }
    
    //MARK: - Formatovani cisel
    
    func numberFormattingInt(number: Int) -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number))!
    }
    
    func numberFormatting(number: Float) -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number))!
        
    }
    
    func condenseWhitespace(string: String) -> String {
        
        let components = NSString(string: string).components(separatedBy: NSCharacterSet.whitespacesAndNewlines).filter({!$0.isEmpty})
        
        return components.joined(separator: "")
    }
    
    //MARK: - share graph via email
    
    @objc func sendEmail() {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setSubject("Zajištění příjmů")
        mailComposerVC.setMessageBody("<h2>Čistá mzda</h2><br></br><p>Čistá mzda: \(cistaMzdaLabel.text!)</p><p>Superhrubá mzda: \(superHrubaMzdaLabel.text!)</p><h6>Odvody zaměstnance</h6><p>Sociální pojištění: \(socialniPojisteniZamestnanecLabel.text!)</p><p>Zdravotní pojištění: \(zdravotniPojisteniZamestnanecLabel.text!)</p><h6>Odvody zaměstnavatele</h6><p>Sociální pojištění: \(socialniPojisteniZamestnavatelLAbel.text!)</p><p>Zdravotní pojištění: \(zdravotniPojisteniZamestnavatelLabel.text!)", isHTML: true)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Nelze poslat email", message: "Email se nepodařilo odeslat! Zkontrolujte nastavení svého telefonu a zkuste to znovu.", delegate: self, cancelButtonTitle: "Ok")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - formatovani text fieldu
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var result = true
        let prospectiveText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if textField == hrubaMzdaTextField {
            if string.count > 0 {
                let disallowedCharacterSet = NSCharacterSet(charactersIn: "0123456789").inverted
                //let replacementStringIsLegal = string.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.count <= 7
                
                let scanner = Scanner(string: prospectiveText)
                let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.isAtEnd
                
                result = replacementStringIsLegal && resultingStringLengthIsLegal && resultingTextIsNumeric
            }
        }
        return result
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.text != "" {
        
            textField.text = textField.text?.chopSuffix(count: 2).condenseWhitespace()
        
        }
        
    }
    
    
    @IBAction func hrubaMzda(sender: AnyObject) {
        
        var num = Int((hrubaMzdaTextField.text! as NSString).intValue)
        
        if num > 2000000 {
            
            num = 2000000
        }
        
        if hrubaMzdaTextField.text == "" || num < 10000 {
            
            num = 10000
        }
        
        hrubaMzdaTextField.text = num.currencyFormattingWithSymbol(currencySymbol: "Kč")
        
        spocitat()

    }
    
    //MARK: - schovat klavesnici
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let toolbar = UIToolbar()
        textField.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true
    }
    
    

}

