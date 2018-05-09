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
            
            checkedCell = cellLabels.index(of: udajeKlienta.spokojenostSBydlenim)!
            
        } else {
            
            checkedCell = cellLabels.index(of: udajeKlienta.planujeVetsi)!
            
        }
        
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage()
        imageView.image = image.background(height: UIScreen.main.bounds.height)
        tableView.backgroundView = imageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0 {
            
            return 2
            
        } else {
            
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        if indexPath.section == 1 {
            
            return 3*44
            
        } else {
            
            return 44
            
        }
    
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            
            return headerTitle
            
        } else {
            
            return "Poznámky"
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
            
            cell.textLabel?.text = cellLabels[indexPath.row]
            
            if checkedCell == indexPath.row {
                
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
                
            }
            
            return cell
        
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "poznamky") as! SpokojenostSNemovitosti
            
            if parametr == 0 {
            
                cell.poznamky.text = udajeKlienta.spokojenostSBydlenimPoznamky

            } else {
                
                cell.poznamky.text = udajeKlienta.planujeVetsiPoznamky
                
            }
            
            cell.poznamky.delegate = self
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row != checkedCell {
            
            let tappedCell = tableView.cellForRow(at: indexPath as IndexPath)
            tappedCell?.accessoryType = .checkmark
            tableView.cellForRow(at: IndexPath(row: checkedCell, section: 0))?.accessoryType = .none
            
            checkedCell = indexPath.row
        }
        
        if parametr == 0 {
            
            udajeKlienta.spokojenostSBydlenim = cellLabels[checkedCell]
        
        } else {
            
            udajeKlienta.planujeVetsi = cellLabels[checkedCell]
        
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if parametr == 0 {
            
            udajeKlienta.spokojenostSBydlenimPoznamky = textView.text
            
        } else {
            
            udajeKlienta.planujeVetsiPoznamky = textView.text
            
        }
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        let toolbar = UIToolbar()
        textView.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true
    }
    
    
    

}
