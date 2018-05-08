//
//  ShrnutiTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 08.11.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import UIKit
import MessageUI
import Foundation

class ShrnutiTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, MFMailComposeViewControllerDelegate {
    
    var sections = [3, 3, 4, 1, udajeKlienta.priority.count, 1]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Finanční rozvaha"
        
        let hotovo = UIBarButtonItem(title: "Hotovo", style: .plain, target: self, action: #selector(ShrnutiTableViewController.hotovoButton))
        let backwardButton = UIBarButtonItem(image: UIImage(named: "backward.png"), style: .plain, target: self, action: #selector(ShrnutiTableViewController.backward))
        self.navigationItem.setRightBarButtonItems([hotovo, backwardButton], animated: true)
        
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage()
        imageView.image = image.background(height: UIScreen.main.bounds.height)
        tableView.backgroundView = imageView
        
        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        if udajeKlienta.priority.count == 0 {
            sections.remove(at: 4)
            
        }
    }

    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.view.endEditing(true)
        
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        if udajeKlienta.priority.count == 0 {
            
            return 5
            
        } else {
            
            return 6
        }
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return sections[section]
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "celkovePrijmyDomacnosti") as! CelkovePrijmyDomacnosti
                
                var str = String()
                
                if udajeKlienta.prijmy != nil {
                    
                    str = udajeKlienta.prijmy!.currencyFormattingWithSymbol(currencySymbol: "Kč")
                    
                } else {
                    
                    str = 0.currencyFormattingWithSymbol(currencySymbol: "Kč")
                    
                }
                
                cell.celkovePrijmyDomacnosti.text = str
                
                return cell
            
            } else if indexPath.row == 1 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "celkoveVydajeDomacnosti") as! CelkoveVydajeDomacnosti
                
                var str = String()
                
                if udajeKlienta.vydaje != nil {
                    
                    str = udajeKlienta.vydaje!.currencyFormattingWithSymbol(currencySymbol: "Kč")
                    
                } else {
                    
                    str = 0.currencyFormattingWithSymbol(currencySymbol: "Kč")
                    
                }
                
                cell.celkoveVydajeDomacnosti.text = str
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "rozdilMeziPrijmyAVydaji") as! RozdilMeziPrijmyAVydaji
                
                var str = String()
                
                if udajeKlienta.vydaje != nil && udajeKlienta.prijmy != nil {
                
                    let vysledek = udajeKlienta.prijmy! - udajeKlienta.vydaje!
                    str = vysledek.currencyFormattingWithSymbol(currencySymbol: "Kč")
                    
                } else {
                    
                    str = 0.currencyFormattingWithSymbol(currencySymbol: "Kč")
                    
                }
                
                cell.rozdilMeziPrijmyAVydaji.text = str
                
                return cell
                
            }
            
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "celkovaCastkaNaProjekt") as! CelkovaCastkaNaProjekt
                
                var vysledek = Int()
                
                let arr = [udajeKlienta.zajisteniPrijmuCastka, udajeKlienta.zajisteniBydleniCastka, udajeKlienta.detiVynalozenaCastka, udajeKlienta.duchodVynalozenaCastka]
                
                for num in arr {
                    
                    if num != nil {
                        
                        vysledek = vysledek + num!
                    
                    }
                    
                }
                
                cell.celkovaCastkaNaProjekt.text = vysledek.currencyFormattingWithSymbol(currencySymbol: "Kč")
                
                return cell
            
            } else if indexPath.row == 1 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "pulkaRozdilu") as! PulkaRozdilu
                
                var str = String()
                
                if udajeKlienta.vydaje != nil && udajeKlienta.prijmy != nil {
                    
                    let vysledek = (udajeKlienta.prijmy! - udajeKlienta.vydaje!)/2
                    str = vysledek.currencyFormattingWithSymbol(currencySymbol: "Kč")
                    
                } else {
                    
                    str = 0.currencyFormattingWithSymbol(currencySymbol: "Kč")
                    
                }
                
                cell.pulkaRozdilu.text = str
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "realnaCastkaNaProjekt") as! RealnaCastkaNaProjekt
                
                if let realnaCastkaNaProjekt = udajeKlienta.realnaCastkaNaProjekt, realnaCastkaNaProjekt > 0 {
                    
                    cell.realnaCastkaNaProjekt.text = realnaCastkaNaProjekt.currencyFormattingWithSymbol(currencySymbol: "Kč")
                }
                
                cell.realnaCastkaNaProjekt.delegate = self
                cell.realnaCastkaNaProjekt.tag = 1
                
                return cell
            }
        
        } else if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "castka") as! CastkaNaPredmet
            
            let castky = [udajeKlienta.zajisteniPrijmuCastka, udajeKlienta.zajisteniBydleniCastka, udajeKlienta.detiVynalozenaCastka, udajeKlienta.duchodVynalozenaCastka]
            
            let labels = ["zajištění příjmů", "bydlení", "děti", "důchod"]
            
            cell.label.text = "Částka na \(labels[indexPath.row])"
            
            var str = String()
            
            if castky[indexPath.row] != nil {
                
                str = castky[indexPath.row]!.currencyFormattingWithSymbol(currencySymbol: "Kč")
            
            } else {
                
                str = 0.currencyFormattingWithSymbol(currencySymbol: "Kč")
            }
            
            cell.castka.text = str

            return cell
        
        } else if indexPath.section == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ostatniPozadavkyRekapitulace") as! OstatniPozadavkyRekapitulace
            
            cell.ostatniPozadavkyRekapitulace.text = udajeKlienta.ostatniPozadavky
            cell.ostatniPozadavkyRekapitulace.delegate = self
            
            return cell
        
        } else if indexPath.section == 4 && udajeKlienta.priority.count != 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "priority") as! PriorityRekapitulace
            
            let poradi = "\(indexPath.row + 1). "
            
            let polozka = NSMutableAttributedString(string: udajeKlienta.priority[indexPath.row])
            let attributedString = NSMutableAttributedString()
            
            let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 20)]
            let boldString = NSMutableAttributedString(string: poradi, attributes: attrs)
            
            attributedString.append(boldString)
            attributedString.append(polozka)
            
            cell.priority.attributedText = attributedString
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "exportDoEmailu") as! ExportDoEmailu
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 3 {
            
            return "Rekapitulace ostatních požadavků"
            
        } else if section == 4 && udajeKlienta.priority.count != 0 {
            
            return "Priority klienta"
            
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 3 {
            
            return 3*44
            
        } else {
            
            return 44
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var num = 5
        
        if udajeKlienta.priority.isEmpty {
            
            num = 4
        }
        
        if indexPath.section == num {
            
            var arr = [udajeKlienta.jeVyplnenoUdaje, udajeKlienta.jeVyplnenoZajisteniPrijmu, udajeKlienta.jeVyplnenoBydleni, udajeKlienta.jeVyplnenoDeti ,udajeKlienta.jeVyplnenoDuchod, udajeKlienta.jeVyplnenoDane, udajeKlienta.jeVyplnenoOstatniPozadavky, udajeKlienta.jeVyplnenoPriority]
            
            if udajeKlienta.realnaCastkaNaProjekt != nil {
                
                arr.append(true)
                
            } else {
                
                arr.append(false)
            }
            
            var jeVyplnenoVsude = true
            
            for bool in arr {
                
                if bool == false {
                    
                    jeVyplnenoVsude = false
                    break
                }
                
            }
            
            if jeVyplnenoVsude == false {
                
                let alert = UIAlertController(title: nil, message: "Prosím doplňte všechny sekce Karty Klienta pro zobrazení PDF", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                self.performSegue(withIdentifier: "PDFsegue", sender: self)
            }
        }
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    func reloadTable() {
        
        sections = [3, 3, 4, 1, udajeKlienta.priority.count, 1]
        tableView.reloadData()
        
    }
    
    //MARK: - textField formatting
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var result = true
        let prospectiveText = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        if string.count > 0 {
            
            let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789").inverted
            let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
            var resultingStringLengthIsLegal = Bool()
            
            resultingStringLengthIsLegal = prospectiveText.count <= 6
                
            let scanner = Scanner.localizedScanner(with: prospectiveText) as! Scanner
            let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.isAtEnd
            
            result = replacementStringIsLegal && resultingStringLengthIsLegal && resultingTextIsNumeric
            
        }
        
        return result
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.text = textField.text?.replacingOccurrences(of: "Kč", with: "")
        textField.text = textField.text!.condenseWhitespace()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        udajeKlienta.realnaCastkaNaProjekt = Int((textField.text! as NSString).intValue)
        
        if let realnaCastkaNaProjekt = udajeKlienta.realnaCastkaNaProjekt, realnaCastkaNaProjekt > 0 {
            
            textField.text = udajeKlienta.realnaCastkaNaProjekt!.currencyFormattingWithSymbol(currencySymbol: "Kč")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        udajeKlienta.ostatniPozadavky = textView.text
        
        if textView.text != "" {
            
            udajeKlienta.chceResitOstatniPozadavky = true
            prioritiesUpdate(label: "Ostatní požadavky", chceResit: true)
            reloadTable()
            
        } else {
            
            udajeKlienta.chceResitOstatniPozadavky = false
            prioritiesUpdate(label: "Ostatní požadavky", chceResit: false)
            reloadTable()
        }
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
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func backward() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "8")
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    @objc func hotovoButton() {
        
        var arr: [String] = []
        arr = arr.actionSheetStrings()
        
        let optionMenu = UIAlertController(title: arr[0], message: arr[1], preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: arr[2], style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.exportData()
            self.dismiss(animated: true, completion: nil)
        })
        
        let saveAction = UIAlertAction(title: arr[3], style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }

    
}
