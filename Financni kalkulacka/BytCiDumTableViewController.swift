//
//  BytCiDumTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 02.11.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import UIKit

class BytCiDumTableViewController: UITableViewController {

    var cellLabels = ["Byt", "Dům"]
    var checkedCell = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkedCell = cellLabels.index(of: udajeKlienta.bytCiDum)!
        self.title = "Bydlení"
        
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
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        
        cell.textLabel?.text = cellLabels[indexPath.row]
        
        if indexPath.row == checkedCell {
            
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row != checkedCell {
            
            let tappedCell = tableView.cellForRow(at: indexPath as IndexPath)
            tappedCell?.accessoryType = UITableViewCellAccessoryType.checkmark
            tableView.cellForRow(at: IndexPath(row: checkedCell, section: 0))?.accessoryType = .none
            checkedCell = indexPath.row
        }
        
        udajeKlienta.bytCiDum = cellLabels[checkedCell]
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }

}
