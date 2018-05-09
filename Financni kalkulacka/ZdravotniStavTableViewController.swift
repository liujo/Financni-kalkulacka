//
//  ZdravotniStavTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 27.10.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import UIKit

class ZdravotniStavTableViewController: UITableViewController {
    
    let cellLabels = ["Plně zdravý", "Drobné zdravotní potíže", "Invalidita"]
    
    var checkedCell = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkedCell = cellLabels.index(of: udajeKlienta.zdravotniStav)!
        
        self.title = "Zdravotní stav"
        
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
        return 3
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.textLabel?.text = cellLabels[indexPath.row]
        
        if indexPath.row == checkedCell {
            
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row != checkedCell {
            
            let tappedCell = tableView.cellForRow(at: indexPath as IndexPath)
            tappedCell?.accessoryType = .checkmark
            tableView.cellForRow(at: IndexPath(row: checkedCell, section: 0))?.accessoryType = .none
            checkedCell = indexPath.row
        }
        
        udajeKlienta.zdravotniStav = cellLabels[checkedCell]
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }

}
