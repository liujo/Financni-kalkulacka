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
        
        let backItem = UIBarButtonItem(title: "Zpět", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        let forwardButton = UIBarButtonItem(image: UIImage(named: "forward.png"), style: .plain, target: self, action: #selector(DetiTableViewController.forward))
        let backwardButton = UIBarButtonItem(image: UIImage(named: "backward.png"), style: .plain, target: self, action: #selector(DetiTableViewController.backward))
        navigationItem.setRightBarButtonItems([forwardButton, backwardButton], animated: true)
        
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage()
        imageView.image = image.background(height: UIScreen.main.bounds.height)
        tableView.backgroundView = imageView
        
        cellCalculation()
        
        if udajeKlienta.pocetDeti! > 0 {
            
            topNum = 0
            bottomNum = 0
            
        } else {
            
            topNum = 1
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        endEditingNow()
        
    }
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        if udajeKlienta.chceResitDeti == true {
            
            if let pocetDeti = udajeKlienta.pocetDeti, pocetDeti > 0 || udajeKlienta.pocetPlanovanychDeti == nil || udajeKlienta.pocetPlanovanychDeti == 0 {
                
                return 6
                
            } else {
                
                return 7
                
            }
            
        }
        
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if udajeKlienta.chceResitDeti == true {
        
            if let pocetDeti = udajeKlienta.pocetDeti, pocetDeti > 0 {
                
                return numberOfRowsWithKids[section]!
                
            } else {
                
                return numberOfRowsNoKids[section]
                
            }
        
        }
        
        return 1
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var dostatecneDeti = false
        var dostatecnePlanovanychDeti = false
        
        if let a = udajeKlienta.pocetDeti, a > 0 {
            dostatecneDeti = true
        }
        
        if let b = udajeKlienta.pocetPlanovanychDeti, b > 0 {
            dostatecnePlanovanychDeti = true
        }
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "chceResitDeti") as! ChceResitDeti
            
            cell.switcher.addTarget(self, action: #selector(DetiTableViewController.chceResitSwitch(sender:)), for: .valueChanged)
            
            if udajeKlienta.chceResitDeti == true {
                
                cell.switcher.isOn = true
                
            } else {
                
                cell.switcher.isOn = false
                
            }
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "mateDeti") as! mateDeti
            
            var str = "Ne"
            
            if let pocetDeti = udajeKlienta.pocetDeti, pocetDeti > 0 {
                
                str = "Ano, \(pocetDeti) děti"
                
                if pocetDeti == 1 {
                    
                    str = "Ano, 1 dítě"
                    
                } else if pocetDeti > 4 {
                    
                    str = "Ano, \(pocetDeti) dětí"
                    
                }
                
            }
            
            cell.mateDeti.text = str
            
            return cell
        
        } else if indexPath.section == 2 && (udajeKlienta.pocetDeti == 0 || udajeKlienta.pocetDeti == nil) {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "planujeteDeti") as! planujeteDeti
                
                cell.planujeteDeti.text = udajeKlienta.planujeteDeti
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "kolik") as! kolikDeti
                
                if let pocetPlanovanychDeti = udajeKlienta.pocetPlanovanychDeti, pocetPlanovanychDeti > 0 {
                    
                    cell.kolikDeti.text = "\(pocetPlanovanychDeti)"
                    
                }
                
                cell.kolikDeti.tag = 1
                cell.kolikDeti.delegate = self
                
                return cell
            }
        
        } else if indexPath.section == 2 + topNum {
          
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "otazka1") as! mateDeti
                
                var str = "Ano"
                
                if udajeKlienta.otazka1 == false {
                    
                    str = "Ne"
                }
                
                cell.otazka1.text = str
                
                return cell
            
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "otazka2") as! mateDeti
                
                var str = "Ano"
                
                if udajeKlienta.otazka2 == false {
                    
                    str = "Ne"
                }
                
                cell.otazka2.text = str
                
                return cell
            }
            
        } else if indexPath.section == 3 + topNum && (dostatecneDeti || dostatecnePlanovanychDeti) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "seznamDeti") as! diteSporeni
            
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "deti") as! DetiVynalozenaCastka
            
            if udajeKlienta.detiVynalozenaCastka == 0 && udajeKlienta.jeVyplnenoDeti {
                
                cell.detiVynalozenaCastka.text = "0"
                
            } else if let castka = udajeKlienta.detiVynalozenaCastka, castka > 0 {
                
                cell.detiVynalozenaCastka.text = udajeKlienta.detiVynalozenaCastka!.currencyFormattingWithSymbol(currencySymbol: "Kč")
            }
            
            cell.detiVynalozenaCastka.tag = 2
            cell.detiVynalozenaCastka.delegate = self
            
            return cell

        } else if indexPath.section == 5 + bottomNum {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "detiPoznamky") as! DetiPoznamky
            
            cell.detiPoznamky.text = "\(udajeKlienta.detiPoznamky)"
            cell.detiPoznamky.delegate = self
            
            return cell

        } else {
            
            return UITableViewCell()
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 3 + topNum {
            
            kidID = indexPath.row
            self.performSegue(withIdentifier: "diteSporeni", sender: self)
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let sctn = 5 + bottomNum
        
        if indexPath.section == sctn {
            
            return 44*3
            
        } else {
            
            return 44
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var dostatecneDeti = false
        var dostatecnePlanovanychDeti = false
        
        if let a = udajeKlienta.pocetDeti, a > 0 {
            dostatecneDeti = true
        }
        
        if let b = udajeKlienta.pocetPlanovanychDeti, b > 0 {
            dostatecnePlanovanychDeti = true
        }
        //if section == 3 + topNum && (udajeKlienta.pocetDeti > 0 || udajeKlienta.pocetPlanovanychDeti > 0) {
        if section == 3 + topNum && (dostatecneDeti || dostatecnePlanovanychDeti) {
            
            return "Děti spoření"
        
        } else if section == 4 + bottomNum {
            
            return "Vynaložená částka na zajištění dětí"
            
        } else if section == 5 + bottomNum {
            
            return "Poznámky"
            
        }
        
        return nil

    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
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
        
        if let pocetPlanovanychDeti = udajeKlienta.pocetPlanovanychDeti, pocetPlanovanychDeti > 0 {
            
            bottomNum = 1
            
            if numberOfRowsNoKids.count == 8 {
                
                numberOfRowsNoKids[4] = pocetPlanovanychDeti
                
            } else {
                
                numberOfRowsNoKids.insert(pocetPlanovanychDeti, at: 4)

            }
            
        } else if let pocetPlanovanychDeti = udajeKlienta.pocetPlanovanychDeti, pocetPlanovanychDeti < 1 || udajeKlienta.pocetPlanovanychDeti == nil {
            
            bottomNum = 0
            
            if numberOfRowsNoKids.count == 8 {
                
                numberOfRowsNoKids.remove(at: 4)
            }
        }

    }
    
    
    //MARK: - textfield formatting
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var result = true
        let prospectiveText = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        if string.count > 0 {
            
            var disallowedCharacterSet = CharacterSet(charactersIn: "0123456789").inverted
            var resultingStringLengthIsLegal = Bool()
            
            if textField.tag == 1 {
                
                resultingStringLengthIsLegal = prospectiveText.count <= 1
                disallowedCharacterSet = CharacterSet(charactersIn: "01234").inverted
                
            } else if textField.tag == 2 {
                
                resultingStringLengthIsLegal = prospectiveText.count <= 7
                
            }
            
            let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
            let scanner = Scanner.localizedScanner(with: prospectiveText) as! Scanner
            let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.isAtEnd
            
            result = replacementStringIsLegal && resultingStringLengthIsLegal && resultingTextIsNumeric
            
        }
        
        return result
        
    }
    
    //MARK: - passing data to struct
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            
        if textField.text != "" {
        
            textField.text = textField.text?.chopSuffix(count: 2)
            
        }
        
        textField.text = textField.text?.condenseWhitespace()

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 1 {
            
            udajeKlienta.pocetPlanovanychDeti = Int((textField.text! as NSString).intValue)
            
            cellCalculation()
            
            tableView.reloadData()
            
        } else if textField.tag == 2 {
            
            udajeKlienta.detiVynalozenaCastka = Int((textField.text! as NSString).intValue)
            
            if let castka = udajeKlienta.detiVynalozenaCastka, castka > 0 {
                
                textField.text = castka.currencyFormattingWithSymbol(currencySymbol: "Kč")
                
            }
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        udajeKlienta.detiPoznamky = textView.text
        
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
    
    //MARK: - toolbar & button to hide keyboard
    
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
    
    
    //MARK: - chceResitSwitch
    
    @objc func chceResitSwitch(sender: UISwitch) {
        
        if sender.isOn == true {
            
            udajeKlienta.chceResitDeti = true
            
        } else {
            
            udajeKlienta.chceResitDeti = false
            udajeKlienta.detiVynalozenaCastka = nil
            
        }
        
        prioritiesUpdate(label: "Děti", chceResit: sender.isOn)
        
        tableView.reloadData()
        
    }
    
    //MARK: - segue
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "planujeteDeti" {
            
            let destination = segue.destination as! PlanujeteDetiTableViewController
            
            destination.int = 0
            
        } else if segue.identifier == "otazka1" {
            
            let destination = segue.destination as! PlanujeteDetiTableViewController
            
            destination.int = 1
        
        } else if segue.identifier == "otazka2" {
            
            let destination = segue.destination as! PlanujeteDetiTableViewController
            
            destination.int = 2
        
        } else if segue.identifier == "diteSporeni" {
            
            let destination = segue.destination as! DiteSporeniTableViewController
            
            destination.kidID = kidID
            
        }
    }
    
    @IBAction func zpet(sender: AnyObject) {
        
        moveOn(moveID: 0)
    }
    
    @objc func backward() {
        
        moveOn(moveID: 3)
    }
    
    @objc func forward() {
    
        moveOn(moveID: 5)
    
    }
    
    //MARK: - infoChecks
    
    func moveOn(moveID: Int) {
        
        endEditingNow()
        
        if hasProvidedAllInfo().0 == false && udajeKlienta.chceResitDeti {
            
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
            
            udajeKlienta.jeVyplnenoDeti = true
            
            if moveID > 0 {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "\(moveID)")
                self.navigationController?.pushViewController(vc!, animated: false)
                
            } else {
                
                self.navigationController?.popToRootViewController(animated: true)
                
            }
        }
        
    }
 
    func hasProvidedAllInfo() -> (Bool, String) {
        
        var values: [Bool] = []
        var labels: [String] = []
        
        if let pocetDeti = udajeKlienta.pocetDeti, pocetDeti > 0 {
            
            labels.append("Vynaložená částka")
            
            if udajeKlienta.detiVynalozenaCastka != nil {
                
                values.append(true)
                
            } else {
                
                values.append(false)
                
            }
            
            for i in 0 ..< pocetDeti {

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
            
            if let pocetPlanovanychDeti = udajeKlienta.pocetPlanovanychDeti, pocetPlanovanychDeti >= 0 {
            
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
