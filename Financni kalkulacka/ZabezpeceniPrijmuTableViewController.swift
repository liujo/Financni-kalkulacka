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

        let backItem = UIBarButtonItem(title: "Zpět", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        let forwardButton = UIBarButtonItem(image: UIImage(named: "forward.png"), style: .plain, target: self, action: #selector(ZabezpeceniPrijmuTableViewController.forward))
        let backwardButton = UIBarButtonItem(image: UIImage(named: "backward.png"), style: .plain, target: self, action: #selector(ZabezpeceniPrijmuTableViewController.backward))
        navigationItem.setRightBarButtonItems([forwardButton, backwardButton], animated: true)
        
        self.title = "Zabezpečení příjmů"
        
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage()
        imageView.image = image.background(height: UIScreen.main.bounds.height)
        tableView.backgroundView = imageView
        
        if udajeKlienta.rodinnyStav != "Svobodný" {
            int = 1
        } else {
            int = 0
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if udajeKlienta.chceResitZajisteniPrijmu == true {
            
            vypocetZajisteni(isClient: true)
            
            if int == 1 {
                
                vypocetZajisteni(isClient: false)
            }
            
        }
        
        tableView.reloadData()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        endEditingNow()
            
    }
    

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
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

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "chceResit") as! ChceResitZabezpeceniPrijmu
            cell.switcher.addTarget(self, action: #selector(ZabezpeceniPrijmuTableViewController.chceResitSwitch(sender:)), for: .valueChanged)
            
            if udajeKlienta.chceResitZajisteniPrijmu == true {
                
                cell.switcher.isOn = true
                
            } else {
                
                cell.switcher.isOn = false
            }
            
            return cell
            
        } else if indexPath.section == 1 {
            
           if indexPath.row == 0 {
                
            let cell = tableView.dequeueReusableCell(withIdentifier: "pracovniPomer") as! PracovniPomer
            
                cell.pracovniPomer.text = udajeKlienta.pracovniPomer
                
                return cell
            
           } else if indexPath.row == 1 {
                
            let cell = tableView.dequeueReusableCell(withIdentifier: "prijem") as! Prijmy
                
                cell.prijem.tag = 1
                cell.prijem.delegate = self
            
                if let prijmy = udajeKlienta.prijmy, prijmy > 0 {
            
                    cell.prijem.text = prijmy.currencyFormattingWithSymbol(currencySymbol: "Kč")
            
                }
            
                return cell
            
            } else if indexPath.row == 2 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "vydaje") as! Vydaje
                
                cell.vydaje.tag = 2
                cell.vydaje.delegate = self
            
                if let vydaje = udajeKlienta.vydaje, vydaje > 0 {
                    
                    cell.vydaje.text = vydaje.currencyFormattingWithSymbol(currencySymbol: "Kč")
                
                }
            
                return cell
            
            } else if indexPath.row == 3 {
            
                let cell = tableView.dequeueReusableCell(withIdentifier: "denniPrijem") as! Prijmy
            
                if let prijmy = udajeKlienta.denniPrijmy, prijmy > 0 {
                
                    cell.denniPrijem.textColor = UIColor.black
                    cell.denniPrijem.text = prijmy.currencyFormattingWithSymbol(currencySymbol: "Kč")
                
                } else {
                
                    cell.denniPrijem.textColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1)
                    cell.denniPrijem.text = "583 Kč"
                
                }
            
                return cell
            
            } else {
                
            let cell = tableView.dequeueReusableCell(withIdentifier: "denniVydaje") as! Vydaje
            
                if let vydaje = udajeKlienta.denniVydaje, vydaje > 0 {
                
                    cell.denniVydaje.textColor = UIColor.black
                    cell.denniVydaje.text = vydaje.currencyFormattingWithSymbol(currencySymbol: "Kč")
                
                } else {
                
                    cell.denniVydaje.textColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1)
                    cell.denniVydaje.text = "666 Kč"
                
                }
            
                return cell
            
            }
        
        } else if indexPath.section == 2 + int {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "uver") as! Uver
            
            if let splatka = udajeKlienta.mesicniSplatkaUveru, splatka > 0, udajeKlienta.maUver == true {
                
                let castka = splatka.currencyFormattingWithSymbol(currencySymbol: "Kč")
                
                cell.uver.text = "\(castka) měsíčně"
                
            } else {
                
                cell.uver.text = "Ne"
                
            }
            
            return cell
            
        } else if indexPath.section == 3 + int {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "zabezpeceniPrijmu") as! ZabezpeceniPrijmu
            
            cell.zabezpeceniPrijmu.tag = 3
            cell.zabezpeceniPrijmu.delegate = self
            
            if let castka = udajeKlienta.zajisteniPrijmuCastka, castka > 0 {
                
                cell.zabezpeceniPrijmu.text = castka.currencyFormattingWithSymbol(currencySymbol: "Kč")
            }
            
            return cell
            
        } else if indexPath.section == 4 + int {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "poznamky") as! ZabezpeceniPrijmuPoznamky
            
            cell.zabezpeceniPrijmuPoznamky.tag = 7
            cell.zabezpeceniPrijmuPoznamky.delegate = self
            cell.zabezpeceniPrijmuPoznamky.text = udajeKlienta.zajisteniPrijmuPoznamky
            
            return cell
            
        } else {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "pracovniPomer") as! PracovniPomer
                
                cell.pracovniPomer.text = udajeKlienta.pracovniPomerPartner
                
                return cell
                
            } else if indexPath.row == 1 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "prijem") as! Prijmy
                
                cell.prijem.tag = 4
                cell.prijem.delegate = self
                
                if let prijmyPartnera = udajeKlienta.prijmyPartner, prijmyPartnera > 0 {
                    
                    cell.prijem.text = prijmyPartnera.currencyFormattingWithSymbol(currencySymbol: "Kč")
                    
                }
                
                return cell
                
            } else if indexPath.row == 2 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "vydaje") as! Vydaje
                
                cell.vydaje.tag = 5
                cell.vydaje.delegate = self
                
                if let vydajePartnera = udajeKlienta.vydajePartner, vydajePartnera > 0 {
                    
                    cell.vydaje.text = vydajePartnera.currencyFormattingWithSymbol(currencySymbol: "Kč")
                    
                }
                
                return cell
                
            } else if indexPath.row == 3 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "denniPrijem") as! Prijmy
                
                if let denniPrijmyPartner = udajeKlienta.denniPrijmyPartner, denniPrijmyPartner > 0 {
                    
                    cell.denniPrijem.textColor = UIColor.black
                    cell.denniPrijem.text = denniPrijmyPartner.currencyFormattingWithSymbol(currencySymbol: "Kč")
                    
                } else {
                    
                    cell.denniPrijem.textColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1)
                    cell.denniPrijem.text = "583 Kč"
                    
                }
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "denniVydaje") as! Vydaje
                
                if let denniVydajePartner = udajeKlienta.denniVydajePartner, denniVydajePartner > 0 {
                    
                    cell.denniVydaje.textColor = UIColor.black
                    cell.denniVydaje.text = denniVydajePartner.currencyFormattingWithSymbol(currencySymbol: "Kč")
                    
                } else {
                    
                    cell.denniVydaje.textColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1)
                    cell.denniVydaje.text = "666 Kč"
                    
                }
                
                return cell
                
            }
        }
    }
        
        
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
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
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UITableViewHeaderFooterView()
        headerView.backgroundView?.backgroundColor = UIColor.clear
        
        return headerView
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footView = UITableViewHeaderFooterView()
        footView.backgroundView?.backgroundColor = UIColor.clear
        
        return footView
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        if section == 4 + int {
            
            return "Další bod: Bydlení"
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 4 + int {
            
            return 3*44
            
        } else {
            
            return 44
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                isClientSegue = true
                
                self.performSegue(withIdentifier: "pracovniPomerSegue", sender: self)

            }
        
        } else if indexPath.section == 2 && udajeKlienta.rodinnyStav == "Vdaná/Ženatý" {
            
            if indexPath.row == 0 {
                
                isClientSegue = false
                
                self.performSegue(withIdentifier: "pracovniPomerSegue", sender: self)
            
            }
        }
        
    }
    
    
    //MARK: - passing data to global variable
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        selectedRow = textField.tag
        
        if textField.text != "" {
            
            textField.text = textField.text?.chopSuffix(count: 2).condenseWhitespace()
        
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if selectedRow == 1 {
            
            if textField.text?.count != 0 {
            
                udajeKlienta.prijmy = Int((textField.text! as NSString).intValue)
                textField.text = udajeKlienta.prijmy?.currencyFormattingWithSymbol(currencySymbol: "Kč")
            
            } else {
                
                udajeKlienta.prijmy = nil
                
            }
            
            isIncomeHigherThanExpenses()
            vypocetZajisteni(isClient: true)
            
        } else if selectedRow == 2 {
            
            if textField.text?.count != 0 {
            
                udajeKlienta.vydaje = Int((textField.text! as NSString).intValue)
                textField.text = udajeKlienta.vydaje?.currencyFormattingWithSymbol(currencySymbol: "Kč")
            
            } else {
                
                udajeKlienta.vydaje = nil
                
            }
            
            isIncomeHigherThanExpenses()
            vypocetZajisteni(isClient: true)
        
        } else if selectedRow == 3 {
            
            if textField.text?.count != 0 {
                
                udajeKlienta.zajisteniPrijmuCastka = Int((textField.text! as NSString).intValue)
                textField.text = udajeKlienta.zajisteniPrijmuCastka?.currencyFormattingWithSymbol(currencySymbol: "Kč")
                
            } else {
                
                udajeKlienta.zajisteniPrijmuCastka = nil
                
            }
        
        } else if selectedRow == 4 {
            
            if textField.text?.count != 0 {
                
                udajeKlienta.prijmyPartner = Int((textField.text! as NSString).intValue)
                textField.text = udajeKlienta.prijmyPartner?.currencyFormattingWithSymbol(currencySymbol: "Kč")
                
            } else {
                
                udajeKlienta.prijmyPartner = nil
            
            }
            
            isIncomeHigherThanExpenses()
            vypocetZajisteni(isClient: false)
        
        } else {
            
            if textField.text?.count != 0 {
                
                udajeKlienta.vydajePartner = Int((textField.text! as NSString).intValue)
                textField.text = udajeKlienta.vydajePartner?.currencyFormattingWithSymbol(currencySymbol: "Kč")
                
            } else {
                
                udajeKlienta.vydajePartner = nil
            
            }
            
            isIncomeHigherThanExpenses()
            vypocetZajisteni(isClient: false)
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        udajeKlienta.zajisteniPrijmuPoznamky = textView.text
    }
    
    //MARK: - vypocet zabezpeceni prijmu a nakladu
    
    func vypocetZajisteni(isClient: Bool) {
        
        if isClient {
            
            if let prijmy = udajeKlienta.prijmy, prijmy > 0 {
                
                udajeKlienta.denniPrijmy = (prijmy/30)/2
                
            }
            
            if let vydaje = udajeKlienta.vydaje, vydaje > 0 {
                
                udajeKlienta.denniVydaje = vydaje/30
            }
            
            
            if udajeKlienta.pracovniPomer == "OSVČ", let denniPrijmy = udajeKlienta.denniPrijmy {
                
                udajeKlienta.denniPrijmy = denniPrijmy*2
                
            }
            
            tableView.reloadData()
        
        } else {
            
            if let prijmyPartner = udajeKlienta.prijmyPartner, prijmyPartner > 0 {
                
                udajeKlienta.denniPrijmyPartner = (prijmyPartner/30)/2
                
            }
            
            if let vydajePartner = udajeKlienta.vydajePartner, vydajePartner > 0 {
                
                udajeKlienta.denniVydajePartner = vydajePartner/30
            }
            
            
            if udajeKlienta.pracovniPomerPartner == "OSVČ", let denniPrijmyPartner = udajeKlienta.denniPrijmyPartner {
                
                udajeKlienta.denniPrijmyPartner = denniPrijmyPartner*2
                
            }
            
            let cell1 = tableView.cellForRow(at: IndexPath(row: 3, section: 2))
            let label1 = cell1?.contentView.viewWithTag(5) as! UILabel?
            
            if let denniPrijmyPartner = udajeKlienta.denniPrijmyPartner, denniPrijmyPartner > 0 {
                
                label1?.textColor = UIColor.black
                label1?.text = denniPrijmyPartner.currencyFormattingWithSymbol(currencySymbol: "Kč")
                
            } else {
                
                label1?.textColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1)
                label1?.text = "583 Kč"
                
            }
            
            let cell2 = tableView.cellForRow(at: IndexPath(row: 4, section: 2))
            let label2 = cell2?.contentView.viewWithTag(6) as! UILabel?
            
            if let denniVydajePartner = udajeKlienta.denniVydajePartner, denniVydajePartner > 0 {
                
                label2?.textColor = UIColor.black
                label2?.text = udajeKlienta.denniVydajePartner!.currencyFormattingWithSymbol(currencySymbol: "Kč")
                
            } else {
                
                label2?.textColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1)
                label2?.text = "666 Kč"
                
            }
        }

    }
    
    //MARK: - textField formatting
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var result = true
        let prospectiveText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if textField.tag >= 2 {
            
            if string.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789").inverted
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil

                let resultingStringLengthIsLegal = prospectiveText.count <= 6
                
                let scanner = Scanner.localizedScanner(with: prospectiveText) as! Scanner
                let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.isAtEnd
                
                result = replacementStringIsLegal && resultingStringLengthIsLegal && resultingTextIsNumeric
                
            }
        }
        
        return result
    
    }
    
    //MARK: - press return key to go to other textfield
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTage=textField.tag+1;
        // Try to find next responder
        let nextResponder=textField.superview?.superview?.superview?.viewWithTag(nextTage) as UIResponder?
        
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let toolbar = UIToolbar()
        textField.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        let toolbar = UIToolbar()
        textView.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true
    }
    
    
    
    //MARK: - navigation bar buttons
    
    @IBAction func zpet(sender: AnyObject) {
        
        moveOn(moveID: 0)
    }
    
    
    @objc func forward() {
        
        moveOn(moveID: 3)
    }
    
    @objc func backward() {
        
        moveOn(moveID: 1)
    }
    
    //MARK: - infoChecks
    
    func moveOn(moveID: Int) {
        
        endEditingNow()
        
        if hasProvidedAllInfo().0 == false && udajeKlienta.chceResitZajisteniPrijmu {
            
            let alert = UIAlertController(title: "Opravdu chcete pokračovat?", message: "Zbývá doplnit tyto údaje:\n\n\(hasProvidedAllInfo().1)" , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Doplnit údaje", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Pokračovat", style: .default, handler: { (action) in
                
                if moveID > 0 {
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "\(moveID)")
                    self.navigationController?.pushViewController(vc!, animated: false)
                    
                } else {
                    
                    self.navigationController?.popToRootViewController(animated: true)
                    
                }
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        
        } else {
            
            udajeKlienta.jeVyplnenoZajisteniPrijmu = true
            
            if moveID > 0 {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "\(moveID)")
                self.navigationController?.pushViewController(vc!, animated: false)
                
            } else {
                
                self.navigationController?.popToRootViewController(animated: true)
                
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
        
        if let vydaje = udajeKlienta.vydaje, let prijmy = udajeKlienta.prijmy, vydaje > prijmy {
            
            let alert = UIAlertController(title: "Výdaje jsou vyšší než příjmy", message: nil , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        
        }
        
        if let vydajePartner = udajeKlienta.vydajePartner, let prijmyPartner = udajeKlienta.prijmyPartner, vydajePartner > prijmyPartner {
            
            let alert = UIAlertController(title: "Výdaje jsou vyšší než příjmy", message: nil , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    
    //MARK: - chceResitSwitch
    
    @objc func chceResitSwitch(sender: UISwitch) {
        
        if sender.isOn == true {
            
            udajeKlienta.chceResitZajisteniPrijmu = true

        } else {
            
            udajeKlienta.chceResitZajisteniPrijmu = false
            udajeKlienta.zajisteniPrijmuCastka = nil
            
        }
        
        prioritiesUpdate(label: "Zabezpečení příjmů a rodiny", chceResit: sender.isOn)
        
        tableView.reloadData()
        
    }
    
    //MARK: - prepare for segue
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "pracovniPomerSegue" {
            
            let destination = segue.destination as! PracovniPomerTableViewController
            
            destination.isClient = isClientSegue
            
            
        }
        
    }

    
}
