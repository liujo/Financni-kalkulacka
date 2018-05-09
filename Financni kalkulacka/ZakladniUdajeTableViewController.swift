//
//  ZakladniUdajeTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 27.10.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import UIKit

class ZakladniUdajeTableViewController: UITableViewController, UITextFieldDelegate, UINavigationBarDelegate {
    
    var selectedRow = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Klient"
        
        let backItem = UIBarButtonItem(title: "Zpět", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        let forwardButton = UIBarButtonItem(image: UIImage(named: "forward.png"), style: .plain, target: self, action: #selector(ZakladniUdajeTableViewController.forward))
        navigationItem.rightBarButtonItem = forwardButton
        
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
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return 8
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "krestniJmeno") as! KrestniJmeno
            
            cell.krestniJmeno.tag = 1
            cell.krestniJmeno.delegate = self
            
            cell.krestniJmeno.text = udajeKlienta.krestniJmeno

            return cell
        
        } else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "prijmeni") as! Prijmeni
            
            cell.prijmeni.tag = 2
            cell.prijmeni.delegate = self
            
            cell.prijmeni.text = udajeKlienta.prijmeni
            
            return cell
        
        } else if indexPath.row == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "vek") as! Vek
            
            cell.vek.tag = 3
            cell.vek.delegate = self
            
            if let vek = udajeKlienta.vek, vek > 0 {
                
                cell.vek.text = "\(vek)"
                
            }
            

            return cell
        
        } else if indexPath.row == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "povolani") as! Povolani
            
            cell.povolani.tag = 4
            cell.povolani.delegate = self
            
            cell.povolani.text = udajeKlienta.povolani
            
            return cell
            
        } else if indexPath.row == 4 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "deti") as! Deti
            
            cell.deti.tag = 5
            cell.deti.delegate = self
            
            if let pocetDeti = udajeKlienta.pocetDeti {
            
                cell.deti.text = "\(pocetDeti)"
            
            }
            
            return cell
            
        } else if indexPath.row == 5 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "rodinnyStav") as! RodinnyStav
            
            cell.rodinnyStav.text = udajeKlienta.rodinnyStav
            
            return cell
            
        } else if indexPath.row == 6 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "sport") as! Sport
            
            cell.sport.tag = 6
            cell.sport.delegate = self
            
            cell.sport.text = udajeKlienta.sport
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "zdravotniStav") as! ZdravotniStav
            
            cell.zdravotniStav.text = udajeKlienta.zdravotniStav
                        
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        return "Další bod: Zabezpečení příjmů"
    }
    
    //MARK: - textField formatting
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result = true
        let prospectiveText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if textField.tag == 3 || textField.tag == 5 {
            
            if string.count > 0 {
                
                var disallowedCharacterSet = CharacterSet(charactersIn: "0123456789.,").inverted
                var resultingStringLengthIsLegal = Bool()
                
                if textField.tag == 3 {
                    
                    resultingStringLengthIsLegal = prospectiveText.count <= 2
                    
                } else {
                    
                    resultingStringLengthIsLegal = prospectiveText.count <= 1
                    disallowedCharacterSet = CharacterSet(charactersIn: "01234").inverted
                }
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let scanner = Scanner.localizedScanner(with: prospectiveText) as! Scanner
                let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.isAtEnd
                
                result = replacementStringIsLegal && resultingStringLengthIsLegal && resultingTextIsNumeric
                
            }
        }
        
        return result
        
    }
    
    //MARK: - passing data to struct
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        selectedRow = textField.tag
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if selectedRow == 1 {
            
            if textField.text?.count != 0 {
            
                udajeKlienta.krestniJmeno = textField.text!
            
            } else {
                
                udajeKlienta.krestniJmeno = nil
                
            }
        
        } else if selectedRow == 2 {
            
            if textField.text?.count != 0 {
            
                udajeKlienta.prijmeni = textField.text!
            
            } else {
                
                udajeKlienta.prijmeni = nil
                
            }
            
            
        } else if selectedRow == 3 {
            
            if textField.text?.count != 0 {
            
                udajeKlienta.vek = Int((textField.text! as NSString).intValue)
            
            } else {
                
                udajeKlienta.vek = nil
                
            }
            
            
        } else if selectedRow == 4 {
            
            if textField.text?.count != 0 {
            
                udajeKlienta.povolani = textField.text!
            
            } else {
                
                udajeKlienta.povolani = nil
                
            }
            
        } else if selectedRow == 5 {
            
            if textField.text?.count != 0 {
            
                udajeKlienta.pocetDeti = Int((textField.text! as NSString).intValue)
            
            } else {
                
                udajeKlienta.pocetDeti = nil
                
            }
            
        } else {
            
            udajeKlienta.sport = textField.text!
        }
        
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
    
    @IBAction func zpetButton(sender: AnyObject) {
        
        moveOn(isMovingForward: false)
        
    }
    
    @objc func forward() {
                
        moveOn(isMovingForward: true)
        
    }
    
    func moveOn(isMovingForward: Bool) {
        
        endEditingNow()
        
        if hasProvidedAllInfo().0 == false {
            
            let alert = UIAlertController(title: "Opravdu chcete pokračovat?", message: "Zbývá doplnit tyto údaje:\n\n\(hasProvidedAllInfo().1)" , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Doplnit údaje", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Pokračovat", style: .default, handler: { (action) in
                
                if isMovingForward {
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "2")
                    self.navigationController?.pushViewController(vc!, animated: false)
                    
                } else {
                    
                    self.navigationController?.popViewController(animated: true)
                }
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            if isMovingForward {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "2")
                self.navigationController?.pushViewController(vc!, animated: false)
                
            } else {
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func hasProvidedAllInfo() -> (Bool, String) {
        
        let krestniJmeno = "Křestní jméno"
        let prijmeni = "Příjmení"
        let vek = "Věk"
        let povolani = "Povolání"
        let pocetDeti = "Počet dětí"
        
        var values: [AnyObject?] = [udajeKlienta.krestniJmeno as AnyObject, udajeKlienta.prijmeni as AnyObject, udajeKlienta.vek as AnyObject, udajeKlienta.povolani as AnyObject, udajeKlienta.pocetDeti as AnyObject]
        var labels: [String] = [krestniJmeno, prijmeni, vek, povolani, pocetDeti]
        
        var arr: [String] = []
        
        for i in 0 ..< 5 {
            
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
            
            udajeKlienta.jeVyplnenoUdaje = true

            return (true, str)
            
        } else {
            
            udajeKlienta.jeVyplnenoUdaje = false
            
            return (false, str)
        }
    }
    
}
