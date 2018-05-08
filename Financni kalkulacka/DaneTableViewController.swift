//
//  DaneTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 08.11.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import UIKit

class DaneTableViewController: UITableViewController, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Daňové úlevy"
        
        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        let forwardButton = UIBarButtonItem(image: UIImage(named: "forward.png"), style: .plain, target: self, action: #selector(DaneTableViewController.forward))
        let backwardButton = UIBarButtonItem(image: UIImage(named: "backward.png"), style: .plain, target: self, action: #selector(DaneTableViewController.backward))
        navigationItem.setRightBarButtonItems([forwardButton, backwardButton], animated: true)
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hotovo", style: .Plain, target: self, action: "hotovoButton")
        
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage()
        imageView.image = image.background(height: UIScreen.main.bounds.height)
        tableView.backgroundView = imageView
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        udajeKlienta.jeVyplnenoDane = true
        
        self.view.endEditing(true)
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "chceteResitDane") as! ChceteResitDane
            
            cell.switcher.addTarget(self, action: #selector(DaneTableViewController.chceResitSwitch(sender:)), for: .valueChanged)
            
            if udajeKlienta.chceteResitDane == true {
                
                cell.switcher.isOn = true
                
            } else {
                
                cell.switcher.isOn = false
                
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "danePoznamky") as! DanePoznamky
            
            cell.danePoznamky.text = udajeKlienta.danePoznamky
            cell.danePoznamky.delegate = self
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 1 {
            
            return "Poznámky"
            
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        if section == 1 {
            
            return "Další bod: Ostatní požadavky"
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            
            return 3*44
            
        } else {
            
            return 44
        }
    }
    
    //MARK: - passing data to struct
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        udajeKlienta.danePoznamky = textView.text
    
    }
    
    //MARK: - toolbar & button to hide keyboard
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        let toolbar = UIToolbar()
        textView.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true
        
    }
        
    //MARK: - chceResitSwitch
    
    @objc func chceResitSwitch(sender: UISwitch) {
        
        if sender.isOn == true {
            
            udajeKlienta.chceteResitDane = true
            
        } else {
            
            udajeKlienta.chceteResitDane = false
            
        }
        
        prioritiesUpdate(label: "Daňové úlevy a státní dotace", chceResit: sender.isOn)
        
    }
   
    @IBAction func zpet(sender: AnyObject) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func backward() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "5")
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    func forward() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "7")
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
}
