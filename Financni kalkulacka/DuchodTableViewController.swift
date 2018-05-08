//
//  DuchodTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 08.11.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import UIKit

class DuchodTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Důchod"
        
        let backItem = UIBarButtonItem(title: "Zpět", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        let forwardButton = UIBarButtonItem(image: UIImage(named: "forward.png"), style: .plain, target: self, action: #selector(DuchodTableViewController.forward))
        let backwardButton = UIBarButtonItem(image: UIImage(named: "backward.png"), style: .plain, target: self, action: #selector(DuchodTableViewController.backward))
        navigationItem.setRightBarButtonItems([forwardButton, backwardButton], animated: true)
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hotovo", style: .Plain, target: self, action: "hotovoButton")
        
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage()
        imageView.image = image.background(height: UIScreen.main.bounds.height)
        tableView.backgroundView = imageView
        
        

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
        
        if udajeKlienta.chceResitDuchod == true {
            
            return 7
        }
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if udajeKlienta.chceResitDuchod == true {
        
            if section == 2 || section == 3 {
            
                return 2
        
            } else {
            
                return 1
            
            }
        
        }
        
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "chceResitDuchod") as! ChceResitDuchod
            
            cell.switcher.addTarget(self, action: #selector(DuchodTableViewController.chceResitSwitch(sender:)), for: .valueChanged)
            
            if udajeKlienta.chceResitDuchod == true {
                
                cell.switcher.isOn = true
                
            } else {
                
                cell.switcher.isOn = false
                
            }
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "predstavaDuchodu") as! PredstavaDuchodu
            
            cell.predstavaDuchodu.delegate = self
            cell.predstavaDuchodu.tag = 1
            
            if let duchodVek = udajeKlienta.duchodVek, duchodVek > 0 {
                
                cell.predstavaDuchodu.text = duchodVek.currencyFormattingWithSymbol(currencySymbol: "let")
            
            }
            
            return cell
        
        } else if indexPath.section == 2 {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "pripravaNaDuchod") as! PripravaNaDuchod
                
                cell.pripravaNaDuchod.text = udajeKlienta.pripravaNaDuchod
                
                return cell
            
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "jakDlouho") as! JakDlouho
                
                cell.jakDlouho.delegate = self
                cell.jakDlouho.tag = 2
                
                if udajeKlienta.jakDlouho != nil {
                
                    cell.jakDlouho.text = udajeKlienta.jakDlouho?.currencyFormattingWithSymbol(currencySymbol: "let")

                } else {
                    
                    cell.jakDlouho.text = ""
                }
                
                return cell
            
            }
        
        } else if indexPath.section == 3 {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "chtelBysteSePripravit") as! ChtelBysteSePripravit
                
                cell.chtelBysteSePripravit.text = udajeKlienta.chtelBysteSePripravit
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "predstavovanaCastka") as! PripravaNaDuchod
                
                cell.predstavovanaCastka.delegate = self
                cell.predstavovanaCastka.tag = 3
                
                if let castka = udajeKlienta.predstavovanaCastka, castka > 0 {
                 
                    cell.predstavovanaCastka.text = castka.currencyFormattingWithSymbol(currencySymbol: "Kč")
                
                }
                
                return cell
            }
            
        } else if indexPath.section == 4 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            
            return cell!
            
        } else if indexPath.section == 5 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "duchodVynalozenaCastka") as! DuchodVynalozenaCastka
            
            cell.duchodVynalozenaCastka.delegate = self
            cell.duchodVynalozenaCastka.tag = 4
            
            if let castka = udajeKlienta.duchodVynalozenaCastka, castka > 0 {
                
                cell.duchodVynalozenaCastka.text = castka.currencyFormattingWithSymbol(currencySymbol: "Kč")
            }
            
            return cell
        
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "duchodPoznamky") as! DuchodPoznamky
            
            cell.duchodPoznamky.text = udajeKlienta.duchodPoznamky
            cell.duchodPoznamky.delegate = self
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 1 {
            
            return "Představa důchodu"
            
        } else if section == 2 {
            
            return "Současná příprava na důchod"
            
        } else if section == 3 {
            
            return "Chtěl(a) byste se připravit na důchod?"
            
        } else if section == 4 {
            
            return "Měl(a) byste zájem o spoření na důchod?"
            
        } else if section == 5 {
            
            return "Vynaložená částka na zajištění spokojeného důchodu"
        
        } else if section == 6 {
            
            return "Poznámky"
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        if section == 3 {
            
            return "Představovaná částka na celý důchod"
        }
        
        if section == 6 {
            
            return "Další bod: Daňové úlevy"
            
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 6 {
            
            return 3*44
            
        } else {
            
            return 44
        }
    }
    
    
    //MARK: - textfield formatting
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var result = true
        let prospectiveText = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        if string.count > 0 {
            
            let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789").inverted
            let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
            var resultingStringLengthIsLegal = Bool()
            
            if textField.tag == 1 || textField.tag == 2 {
                
                resultingStringLengthIsLegal = prospectiveText.count <= 2
                
            } else if textField.tag == 3 {
                
                resultingStringLengthIsLegal = prospectiveText.count <= 9
                
            } else {
                
                resultingStringLengthIsLegal = prospectiveText.count <= 6
            }
            
            let scanner = Scanner.localizedScanner(with: prospectiveText) as! Scanner
            let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.isAtEnd
            
            result = replacementStringIsLegal && resultingStringLengthIsLegal && resultingTextIsNumeric
            
        }
        
        return result
        
    }


    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 1 {
            
            if udajeKlienta.duchodVek != nil {
            
                textField.text = "\(udajeKlienta.duchodVek!)"
            
            }
            
        } else if textField.tag == 2 {
            
            if udajeKlienta.jakDlouho != nil {
        
                textField.text = "\(udajeKlienta.jakDlouho!)"
            }
            
        } else if textField.tag == 4 {
            
            if udajeKlienta.duchodVynalozenaCastka != nil {
                
                textField.text = "\(udajeKlienta.duchodVynalozenaCastka!)"
            }
            
        } else {
            
            if udajeKlienta.predstavovanaCastka != nil {
            
                textField.text = "\(udajeKlienta.predstavovanaCastka!)"
                
            }
        }
        
        textField.text = textField.text?.condenseWhitespace()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 1 {
            
            if textField.text?.count != 0 {
                
                udajeKlienta.duchodVek = Int((textField.text! as NSString).intValue)
                textField.text = udajeKlienta.duchodVek?.currencyFormattingWithSymbol(currencySymbol: "let")
                
            } else {
                
                udajeKlienta.duchodVek = nil
            }
            
            
        } else if textField.tag == 2 {
            
            if textField.text?.count != 0 {
            
                udajeKlienta.jakDlouho = Int((textField.text! as NSString).intValue)
                textField.text = udajeKlienta.jakDlouho?.currencyFormattingWithSymbol(currencySymbol: "let")
                
            } else {
                
                udajeKlienta.jakDlouho = nil
                
            }
            
            
        } else if textField.tag == 3 {
            
            if textField.text?.count != 0 {
                
                udajeKlienta.predstavovanaCastka = Int((textField.text! as NSString).intValue)
                textField.text = udajeKlienta.predstavovanaCastka?.currencyFormattingWithSymbol(currencySymbol: "Kč")
                
            } else {
                
                udajeKlienta.predstavovanaCastka = nil
                
            }
            
            
        } else {
            
            if textField.text?.count != 0 {
                
                udajeKlienta.duchodVynalozenaCastka = Int((textField.text! as NSString).intValue)
                textField.text = udajeKlienta.duchodVynalozenaCastka?.currencyFormattingWithSymbol(currencySymbol: "Kč")

            } else {
                
                udajeKlienta.duchodVynalozenaCastka = nil
                
            }
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        udajeKlienta.duchodPoznamky = textView.text
        
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
        
    
    @IBAction func zpet(sender: AnyObject) {
        
        moveOn(moveID: 0)
        
    }
    
    //MARK: - chceResitSwitch
    
    @objc func chceResitSwitch(sender: UISwitch) {
        
        if sender.isOn == true {
            
            udajeKlienta.chceResitDuchod = true
            
        } else {
            
            udajeKlienta.chceResitDuchod = false
            udajeKlienta.duchodVynalozenaCastka = nil
            
        }
        
        prioritiesUpdate(label: "Důchod", chceResit: sender.isOn)
        
        tableView.reloadData()
        
    }
    
    //MARK: - segue
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "pripravaNaDuchodSegue" {
            
            let destination = segue.destination as! PripravaNaDuchodTableViewController
            
            destination.parametr = 0
        }
        
        if segue.identifier == "chtelBysteSePripravitNaDuchodSegue" {
            
            let destination = segue.destination as! PripravaNaDuchodTableViewController
            
            destination.parametr = 1
        }
        
        if segue.identifier == "grafSegue" {
            
            let destination = segue.destination as! SavingsTableViewController
            
            destination.isSegueFromKartaKlienta = true
        }
    }
    
    func backward() {
        
        moveOn(moveID: 4)
    }
    
    func forward() {
        
        moveOn(moveID: 6)
    }
    
    //MARK: - infoChecks
    
    func moveOn(moveID: Int) {
    
        endEditingNow()
        
        if hasProvidedAllInfo().0 == false && udajeKlienta.chceResitDuchod {
            
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
            
            udajeKlienta.jeVyplnenoDuchod = true
            
            if moveID > 0 {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "\(moveID)")
                self.navigationController?.pushViewController(vc!, animated: false)
                
            } else {
                
                self.navigationController?.popToRootViewController(animated: true)
                
            }
            
        }
        
    }
    
    func hasProvidedAllInfo() -> (Bool, String) {
    
        let predstavaDuchodu = "Představa důchodu ve věku"
        let jakDlouho = "Jak dlouho?"
        let castkaDuchod = "Částka v důchodu"
        let vynalozenaCastka = "Vynaložená částka"
        
        let values = [udajeKlienta.duchodVek, udajeKlienta.jakDlouho, udajeKlienta.predstavovanaCastka, udajeKlienta.duchodVynalozenaCastka]
        let labels = [predstavaDuchodu, jakDlouho, castkaDuchod, vynalozenaCastka]
        
        var arr: [String] = []
        
        for i in 0 ..< 4 {
            
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
            
            udajeKlienta.jeVyplnenoDuchod = true
            
            return (true, str)
            
        } else {
            
            udajeKlienta.jeVyplnenoDuchod = false
            
            return (false, str)
        }
    }
    
    
}
