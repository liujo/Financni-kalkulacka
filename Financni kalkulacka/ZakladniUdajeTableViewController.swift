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
        
        let backItem = UIBarButtonItem(title: "Zpět", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        let forwardButton = UIBarButtonItem(image: UIImage(named: "forward.png"), style: .Plain, target: self, action: #selector(ZakladniUdajeTableViewController.forward))
        navigationItem.rightBarButtonItem = forwardButton
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hotovo", style: .Plain, target: self, action: "hotovoButton")
        
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage()
        imageView.image = image.background(UIScreen.mainScreen().bounds.height)
        tableView.backgroundView = imageView
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
        
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        endEditingNow()

    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return 8
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
        
            let cell = tableView.dequeueReusableCellWithIdentifier("krestniJmeno") as! KrestniJmeno
            
            cell.krestniJmeno.tag = 1
            cell.krestniJmeno.delegate = self
            
            cell.krestniJmeno.text = udajeKlienta.krestniJmeno

            return cell
        
        } else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("prijmeni") as! Prijmeni
            
            cell.prijmeni.tag = 2
            cell.prijmeni.delegate = self
            
            cell.prijmeni.text = udajeKlienta.prijmeni
            
            return cell
        
        } else if indexPath.row == 2 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("vek") as! Vek
            
            cell.vek.tag = 3
            cell.vek.delegate = self
            
            if udajeKlienta.vek > 0 {
                
                cell.vek.text = "\(udajeKlienta.vek!)"
                
            }
            

            return cell
        
        } else if indexPath.row == 3 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("povolani") as! Povolani
            
            cell.povolani.tag = 4
            cell.povolani.delegate = self
            
            cell.povolani.text = udajeKlienta.povolani
            
            return cell
            
        } else if indexPath.row == 4 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("deti") as! Deti
            
            cell.deti.tag = 5
            cell.deti.delegate = self
            
            if udajeKlienta.pocetDeti != nil {
            
                cell.deti.text = "\(udajeKlienta.pocetDeti!)"
            
            }
            
            return cell
            
        } else if indexPath.row == 5 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("rodinnyStav") as! RodinnyStav
            
            cell.rodinnyStav.text = udajeKlienta.rodinnyStav
            
            return cell
            
        } else if indexPath.row == 6 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("sport") as! Sport
            
            cell.sport.tag = 6
            cell.sport.delegate = self
            
            cell.sport.text = udajeKlienta.sport
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("zdravotniStav") as! ZdravotniStav
            
            cell.zdravotniStav.text = udajeKlienta.zdravotniStav
                        
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        return "Další bod: Zabezpečení příjmů"
    }
    
    //MARK: - textField formatting
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var result = true
        let prospectiveText = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if textField.tag == 3 || textField.tag == 5 {
            
            if string.characters.count > 0 {
                
                var disallowedCharacterSet = NSCharacterSet(charactersInString: "0123456789.,").invertedSet
                var resultingStringLengthIsLegal = Bool()
                
                if textField.tag == 3 {
                    
                    resultingStringLengthIsLegal = prospectiveText.characters.count <= 2
                    
                } else {
                    
                    resultingStringLengthIsLegal = prospectiveText.characters.count <= 1
                    disallowedCharacterSet = NSCharacterSet(charactersInString: "01234").invertedSet
                }
                
                let replacementStringIsLegal = string.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
                
                let scanner:NSScanner = NSScanner.localizedScannerWithString(prospectiveText) as! NSScanner
                let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.atEnd
                
                result = replacementStringIsLegal && resultingStringLengthIsLegal && resultingTextIsNumeric
                                
            }
        }
        
        return result
        
    }
    
    //MARK: - passing data to struct
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        selectedRow = textField.tag
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if selectedRow == 1 {
            
            if textField.text?.characters.count != 0 {
            
                udajeKlienta.krestniJmeno = textField.text!
            
            } else {
                
                udajeKlienta.krestniJmeno = nil
                
            }
        
        } else if selectedRow == 2 {
            
            if textField.text?.characters.count != 0 {
            
                udajeKlienta.prijmeni = textField.text!
            
            } else {
                
                udajeKlienta.prijmeni = nil
                
            }
            
            
        } else if selectedRow == 3 {
            
            if textField.text?.characters.count != 0 {
            
                udajeKlienta.vek = Int((textField.text! as NSString).intValue)
            
            } else {
                
                udajeKlienta.vek = nil
                
            }
            
            
        } else if selectedRow == 4 {
            
            if textField.text?.characters.count != 0 {
            
                udajeKlienta.povolani = textField.text!
            
            } else {
                
                udajeKlienta.povolani = nil
                
            }
            
        } else if selectedRow == 5 {
            
            if textField.text?.characters.count != 0 {
            
                udajeKlienta.pocetDeti = Int((textField.text! as NSString).intValue)
            
            } else {
                
                udajeKlienta.pocetDeti = nil
                
            }
            
        } else {
            
            udajeKlienta.sport = textField.text!
        }
        
    }
    
    //MARK: - press return key to go to other textfield
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let nextTage=textField.tag+1;
        // Try to find next responder
        let nextResponder=textField.superview?.superview?.superview?.viewWithTag(nextTage) as UIResponder!
        
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
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        let toolbar = UIToolbar()
        textField.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true
    }
    
    @IBAction func zpetButton(sender: AnyObject) {
        
        moveOn(false)
        
    }
    
    func forward() {
                
        moveOn(true)
        
    }
    
    func moveOn(isMovingForward: Bool) {
        
        endEditingNow()
        
        if hasProvidedAllInfo().0 == false {
            
            let alert = UIAlertController(title: "Opravdu chcete pokračovat?", message: "Zbývá doplnit tyto údaje:\n\n\(hasProvidedAllInfo().1)" , preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Doplnit údaje", style: .Cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Pokračovat", style: .Default, handler: { (action) in
                
                if isMovingForward {
                    
                    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("2")
                    self.navigationController?.pushViewController(vc!, animated: false)
                    
                } else {
                    
                    self.navigationController?.popViewControllerAnimated(true)
                }
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            if isMovingForward {
                
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("2")
                self.navigationController?.pushViewController(vc!, animated: false)
                
            } else {
                
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    func hasProvidedAllInfo() -> (Bool, String) {
        
        let krestniJmeno = "Křestní jméno"
        let prijmeni = "Příjmení"
        let vek = "Věk"
        let povolani = "Povolání"
        let pocetDeti = "Počet dětí"
        
        var values: [AnyObject?] = [udajeKlienta.krestniJmeno, udajeKlienta.prijmeni, udajeKlienta.vek, udajeKlienta.povolani, udajeKlienta.pocetDeti]
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
