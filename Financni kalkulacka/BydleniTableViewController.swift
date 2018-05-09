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
        
        let backItem = UIBarButtonItem(title: "Zpět", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        let forwardButton = UIBarButtonItem(image: UIImage(named: "forward.png"), style: .plain, target: self, action: #selector(BydleniTableViewController.forward))
        let backwardButton = UIBarButtonItem(image: UIImage(named: "backward.png"), style: .plain, target: self, action: #selector(BydleniTableViewController.backward))
        navigationItem.setRightBarButtonItems([forwardButton, backwardButton], animated: true)
        
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage()
        imageView.image = image.background(height: UIScreen.main.bounds.height)
        tableView.backgroundView = imageView
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if udajeKlienta.vlastniCiNajemnni == "Nájemní" {
            
            num = 1
            
        } else {
            
            num = 0
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

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->
        UITableViewCell {
            
        if indexPath.section == 0 {
                
            let cell = tableView.dequeueReusableCell(withIdentifier: "chceResitBydleni") as! ChceResitBydleni
            cell.switcher.addTarget(self, action: #selector(BydleniTableViewController.chceResitSwitch(sender:)), for: .valueChanged)
            if udajeKlienta.chceResitBydleni == true {
                
                cell.switcher.isOn = true
                
            } else {
                
                cell.switcher.isOn = false
            
            }
            
            return cell
        
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "bytCiDum") as! BytCiDum
                
                cell.bytCiDum.text = udajeKlienta.bytCiDum
                
                return cell
            
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "vlastniCiNajemni") as! VlastniCiNajemni
                
                if udajeKlienta.vlastniCiNajemnni == "Nájemní" {
                    
                    let najemne = udajeKlienta.najemne.currencyFormattingWithSymbol(currencySymbol: "Kč") + " nájemné"
                    
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
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "spokojenostSNemovitosti") as! SpokojenostSNemovitosti
                
                cell.spokojenostSBydlenim.text = udajeKlienta.spokojenostSBydlenim
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "planujeVetsi") as! PlanujeVetsi
                
                cell.planujeVetsi.text = udajeKlienta.planujeVetsi
                
                return cell
                
            }
            
        } else if indexPath.section == 3 + num {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "programPredcasnehoSplaceni") as! ProgramPredcasnehoSplaceni
            
            return cell
            
        } else if indexPath.section == 4 + num {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "zajisteniBydleni") as! ZajisteniBydleni
            
            cell.zajisteniBydleni.delegate = self
            cell.zajisteniBydleni.tag = 1
            
            if let castka = udajeKlienta.zajisteniBydleniCastka, castka > 0 {
                
                cell.zajisteniBydleni.text = castka.currencyFormattingWithSymbol(currencySymbol: "Kč")
            
            }
            
            return cell
            
        } else if indexPath.section == 5 + num {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "zajisteniBydleniPoznamky") as! ZajisteniBydleniPoznamky
            
            cell.zajisteniBydleniPoznamky.delegate = self
            cell.zajisteniBydleniPoznamky.text = udajeKlienta.zajisteniBydleniPoznamky
            
            return cell
            
        } else if num == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "propocetNajmu") as! PropocetNajmu
            
            if indexPath.row == 2 {
                
                cell.propocetNajmuPopisek.text = "20 let"
                let najemne = udajeKlienta.najemne*20*12
                cell.propocetNajmuVysledek.text = najemne.currencyFormattingWithSymbol(currencySymbol: "Kč")
                
            } else {
                
                let nasobitel = 5*indexPath.row
                cell.propocetNajmuPopisek.text = "\(5+nasobitel) let"
                
                let najemne = (5+nasobitel)*12*udajeKlienta.najemne
                cell.propocetNajmuVysledek.text = najemne.currencyFormattingWithSymbol(currencySymbol: "Kč")
                
            }
            
            return cell
            
        }
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
    
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
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
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        var sctn = 5
        
        if udajeKlienta.vlastniCiNajemnni == "Nájemní" {
            
            sctn = 6
            
        }
        
        if section == sctn {
            
            return "Další bod: Děti"
            
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.text = textField.text?.chopSuffix(count: 2).condenseWhitespace()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text?.count != 0 {
        
            udajeKlienta.zajisteniBydleniCastka = Int((textField.text! as NSString).intValue)
            textField.text = udajeKlienta.zajisteniBydleniCastka!.currencyFormattingWithSymbol(currencySymbol: "Kč")
        
        } else {
            
            udajeKlienta.zajisteniBydleniCastka = nil
            
        }
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        let toolbar = UIToolbar()
        textView.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true

    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        udajeKlienta.zajisteniBydleniPoznamky = textView.text
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var result = true
        let prospectiveText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if string.count > 0 {
            
            let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789").inverted
            let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil

            let resultingStringLengthIsLegal = prospectiveText.count <= 6
            
            let scanner = Scanner.localizedScanner(with: prospectiveText) as! Scanner
            let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.isAtEnd
            
            result = replacementStringIsLegal && resultingStringLengthIsLegal && resultingTextIsNumeric
            
        }
        
        return result
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        let toolbar = UIToolbar()
        textField.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true
    }
    
    
    //MARK: - navigation bar items
    
    @IBAction func zpet(sender: AnyObject) {

        moveOn(moveID: 0)
    }
    
    @objc func backward() {
        
        moveOn(moveID: 2)
    }
    
        
    @objc func forward() {
        
        moveOn(moveID: 4)
    }
    
    //MARK: - segue
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "spokojenostSegue" {
            
            let destination = segue.destination as! SpokojenostBydleniTableViewController
            
            destination.cellLabels = ["Ano", "Mám výhrady"]
            destination.parametr = 0
            destination.headerTitle = "Spokojenost s bydlením"
            
        }
        
        if segue.identifier == "planujeVetsiSegue" {
            
            let destination = segue.destination as! SpokojenostBydleniTableViewController
            
            destination.cellLabels = ["Ano", "Ne"]
            destination.parametr = 1
            destination.headerTitle = "Plánuje větší?"
            
        }
        
        if segue.identifier == "PPSsegue" {
            
            let destination = segue.destination as! PPSTableViewController
            
            destination.isSegueFromKartaKlienta = true
        }
        
    }
    
    //MARK: - info check
    
    func moveOn(moveID: Int) {
        
        endEditingNow()
        
        if hasProvidedInfo().0 == false && udajeKlienta.chceResitBydleni {
            
            let alert = UIAlertController(title: "Opravdu chcete pokračovat?", message: "Zbývá doplnit tyto údaje:\n\n\(hasProvidedInfo().1)" , preferredStyle: .alert)
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
            
            udajeKlienta.jeVyplnenoBydleni = true
            
            if moveID > 0 {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "\(moveID)")
                self.navigationController?.pushViewController(vc!, animated: false)
                
            } else {
                
                self.navigationController?.popToRootViewController(animated: true)
                
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
    
    @objc func chceResitSwitch(sender: UISwitch) {
        
        if sender.isOn == true {
            
            udajeKlienta.chceResitBydleni = true
            
        } else {
            
            udajeKlienta.chceResitBydleni = false
            udajeKlienta.zajisteniBydleniCastka = nil
            
        }
        
        prioritiesUpdate(label: "Bydlení", chceResit: sender.isOn)
        
        tableView.reloadData()
        
    }
    
    
}
