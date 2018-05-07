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
        
        let forwardButton = UIBarButtonItem(image: UIImage(named: "forward.png"), style: .Plain, target: self, action: #selector(DuchodTableViewController.forward))
        let backwardButton = UIBarButtonItem(image: UIImage(named: "backward.png"), style: .Plain, target: self, action: #selector(DuchodTableViewController.backward))
        navigationItem.setRightBarButtonItems([forwardButton, backwardButton], animated: true)
        
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
        
        if udajeKlienta.chceResitDuchod == true {
            
            return 7
        }
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("chceResitDuchod") as! ChceResitDuchod
            
            cell.switcher.addTarget(self, action: #selector(DuchodTableViewController.chceResitSwitch(_:)), forControlEvents: .ValueChanged)
            
            if udajeKlienta.chceResitDuchod == true {
                
                cell.switcher.on = true
                
            } else {
                
                cell.switcher.on = false
                
            }
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("predstavaDuchodu") as! PredstavaDuchodu
            
            cell.predstavaDuchodu.delegate = self
            cell.predstavaDuchodu.tag = 1
            
            if udajeKlienta.duchodVek > 0 {
                
                cell.predstavaDuchodu.text = udajeKlienta.duchodVek?.currencyFormattingWithSymbol("let")
            
            }
            
            return cell
        
        } else if indexPath.section == 2 {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("pripravaNaDuchod") as! PripravaNaDuchod
                
                cell.pripravaNaDuchod.text = udajeKlienta.pripravaNaDuchod
                
                return cell
            
            } else {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("jakDlouho") as! JakDlouho
                
                cell.jakDlouho.delegate = self
                cell.jakDlouho.tag = 2
                
                if udajeKlienta.jakDlouho != nil {
                
                    cell.jakDlouho.text = udajeKlienta.jakDlouho?.currencyFormattingWithSymbol("let")

                } else {
                    
                    cell.jakDlouho.text = ""
                }
                
                return cell
            
            }
        
        } else if indexPath.section == 3 {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("chtelBysteSePripravit") as! ChtelBysteSePripravit
                
                cell.chtelBysteSePripravit.text = udajeKlienta.chtelBysteSePripravit
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("predstavovanaCastka") as! PripravaNaDuchod
                
                cell.predstavovanaCastka.delegate = self
                cell.predstavovanaCastka.tag = 3
                
                if udajeKlienta.predstavovanaCastka > 0 {
                 
                    cell.predstavovanaCastka.text = udajeKlienta.predstavovanaCastka!.currencyFormattingWithSymbol("Kč")
                
                }
                
                return cell
            }
            
        } else if indexPath.section == 4 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell")
            
            return cell!
            
        } else if indexPath.section == 5 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("duchodVynalozenaCastka") as! DuchodVynalozenaCastka
            
            cell.duchodVynalozenaCastka.delegate = self
            cell.duchodVynalozenaCastka.tag = 4
            
            if udajeKlienta.duchodVynalozenaCastka > 0 {
                
                cell.duchodVynalozenaCastka.text = udajeKlienta.duchodVynalozenaCastka!.currencyFormattingWithSymbol("Kč")
            }
            
            return cell
        
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("duchodPoznamky") as! DuchodPoznamky
            
            cell.duchodPoznamky.text = udajeKlienta.duchodPoznamky
            cell.duchodPoznamky.delegate = self
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
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
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        if section == 3 {
            
            return "Představovaná částka na celý důchod"
        }
        
        if section == 6 {
            
            return "Další bod: Daňové úlevy"
            
        }
        
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 6 {
            
            return 3*44
            
        } else {
            
            return 44
        }
    }
    
    
    //MARK: - textfield formatting
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var result = true
        let prospectiveText = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if string.characters.count > 0 {
            
            let disallowedCharacterSet = NSCharacterSet(charactersInString: "0123456789").invertedSet
            let replacementStringIsLegal = string.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
            var resultingStringLengthIsLegal = Bool()
            
            if textField.tag == 1 || textField.tag == 2 {
                
                resultingStringLengthIsLegal = prospectiveText.characters.count <= 2
                
            } else if textField.tag == 3 {
                
                resultingStringLengthIsLegal = prospectiveText.characters.count <= 9
                
            } else {
                
                resultingStringLengthIsLegal = prospectiveText.characters.count <= 6
            }
            
            let scanner:NSScanner = NSScanner.localizedScannerWithString(prospectiveText) as! NSScanner
            let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.atEnd
            
            result = replacementStringIsLegal && resultingStringLengthIsLegal && resultingTextIsNumeric
            
        }
        
        return result
        
    }


    func textFieldDidBeginEditing(textField: UITextField) {
        
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
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField.tag == 1 {
            
            if textField.text?.characters.count != 0 {
                
                udajeKlienta.duchodVek = Int((textField.text! as NSString).intValue)
                textField.text = udajeKlienta.duchodVek?.currencyFormattingWithSymbol("let")
                
            } else {
                
                udajeKlienta.duchodVek = nil
            }
            
            
        } else if textField.tag == 2 {
            
            if textField.text?.characters.count != 0 {
            
                udajeKlienta.jakDlouho = Int((textField.text! as NSString).intValue)
                textField.text = udajeKlienta.jakDlouho?.currencyFormattingWithSymbol("let")
                
            } else {
                
                udajeKlienta.jakDlouho = nil
                
            }
            
            
        } else if textField.tag == 3 {
            
            if textField.text?.characters.count != 0 {
                
                udajeKlienta.predstavovanaCastka = Int((textField.text! as NSString).intValue)
                textField.text = udajeKlienta.predstavovanaCastka?.currencyFormattingWithSymbol("Kč")
                
            } else {
                
                udajeKlienta.predstavovanaCastka = nil
                
            }
            
            
        } else {
            
            if textField.text?.characters.count != 0 {
                
                udajeKlienta.duchodVynalozenaCastka = Int((textField.text! as NSString).intValue)
                textField.text = udajeKlienta.duchodVynalozenaCastka?.currencyFormattingWithSymbol("Kč")

            } else {
                
                udajeKlienta.duchodVynalozenaCastka = nil
                
            }
            
        }
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        udajeKlienta.duchodPoznamky = textView.text
        
    }
    
    //MARK: - toolbar & button to hide keyboard
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        let toolbar = UIToolbar()
        textField.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        let toolbar = UIToolbar()
        textView.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true
        
    }
        
    
    @IBAction func zpet(sender: AnyObject) {
        
        moveOn(0)
        
    }
    
    //MARK: - chceResitSwitch
    
    func chceResitSwitch(sender: UISwitch) {
        
        if sender.on == true {
            
            udajeKlienta.chceResitDuchod = true
            
        } else {
            
            udajeKlienta.chceResitDuchod = false
            udajeKlienta.duchodVynalozenaCastka = nil
            
        }
        
        prioritiesUpdate("Důchod", chceResit: sender.on)
        
        tableView.reloadData()
        
    }
    
    //MARK: - segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "pripravaNaDuchodSegue" {
            
            let destination = segue.destinationViewController as! PripravaNaDuchodTableViewController
            
            destination.parametr = 0
        }
        
        if segue.identifier == "chtelBysteSePripravitNaDuchodSegue" {
            
            let destination = segue.destinationViewController as! PripravaNaDuchodTableViewController
            
            destination.parametr = 1
        }
        
        if segue.identifier == "grafSegue" {
            
            let destination = segue.destinationViewController as! SavingsTableViewController
            
            destination.isSegueFromKartaKlienta = true
        }
    }
    
    func backward() {
        
        moveOn(4)
    }
    
    func forward() {
        
        moveOn(6)
    }
    
    //MARK: - infoChecks
    
    func moveOn(moveID: Int) {
    
        endEditingNow()
        
        if hasProvidedAllInfo().0 == false && udajeKlienta.chceResitDuchod {
            
            let alert = UIAlertController(title: "Opravdu chcete pokračovat?", message: "Zbývá doplnit tyto údaje:\n\n\(hasProvidedAllInfo().1)" , preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Doplnit údaje", style: .Cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Pokračovat", style: .Default, handler: { (action) in
                
                if moveID > 0 {
                    
                    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("\(moveID)")
                    self.navigationController?.pushViewController(vc!, animated: false)
                    
                } else {
                    
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
                }
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        
        } else {
            
            udajeKlienta.jeVyplnenoDuchod = true
            
            if moveID > 0 {
                
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("\(moveID)")
                self.navigationController?.pushViewController(vc!, animated: false)
                
            } else {
                
                self.navigationController?.popToRootViewControllerAnimated(true)
                
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
