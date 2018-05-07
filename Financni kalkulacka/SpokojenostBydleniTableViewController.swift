//
//  SpokojenostBydleniTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 02.11.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import UIKit

class SpokojenostBydleniTableViewController: UITableViewController, UITextViewDelegate {
    
    var cellLabels:[String] = []
    var parametr = Int()
    var checkedCell = Int()
    var headerTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Bydlení"
        
        if parametr == 0 {
            
            checkedCell = cellLabels.indexOf(udajeKlienta.spokojenostSBydlenim)!
            
        } else {
            
            checkedCell = cellLabels.indexOf(udajeKlienta.planujeVetsi)!
            
        }
        
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage()
        imageView.image = image.background(UIScreen.mainScreen().bounds.height)
        tableView.backgroundView = imageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0 {
            
            return 2
            
        } else {
            
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        if indexPath.section == 1 {
            
            return 3*44
            
        } else {
            
            return 44
            
        }
    
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            
            return headerTitle
            
        } else {
            
            return "Poznámky"
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            
            cell.textLabel?.text = cellLabels[indexPath.row]
            
            if checkedCell == indexPath.row {
                
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                
            }
            
            return cell
        
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("poznamky") as! SpokojenostSNemovitosti
            
            if parametr == 0 {
            
                cell.poznamky.text = udajeKlienta.spokojenostSBydlenimPoznamky

            } else {
                
                cell.poznamky.text = udajeKlienta.planujeVetsiPoznamky
                
            }
            
            cell.poznamky.delegate = self
            
            return cell
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row != checkedCell {
            
            let tappedCell = tableView.cellForRowAtIndexPath(indexPath)
            
            tappedCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: checkedCell, inSection: 0))?.accessoryType = UITableViewCellAccessoryType.None
            
            checkedCell = indexPath.row
        }
        
        if parametr == 0 {
            
            udajeKlienta.spokojenostSBydlenim = cellLabels[checkedCell]
        
        } else {
            
            udajeKlienta.planujeVetsi = cellLabels[checkedCell]
        
        }
        
        tableView.reloadData()
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    }
    
    
    func textViewDidEndEditing(textView: UITextView) {
        
        if parametr == 0 {
            
            udajeKlienta.spokojenostSBydlenimPoznamky = textView.text
            
        } else {
            
            udajeKlienta.planujeVetsiPoznamky = textView.text
            
        }
        
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        let toolbar = UIToolbar()
        textView.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true
    }
    
    
    

}
