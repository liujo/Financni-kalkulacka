//
//  PripravaNaDuchodTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 08.11.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import UIKit

class PripravaNaDuchodTableViewController: UITableViewController {
    
    let cellLabels = ["Ano", "Ne"]
    var parametr = Int()
    var checkedCell = Int()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Příprava na důchod"
        
        if parametr == 0 {
            
            checkedCell = cellLabels.indexOf(udajeKlienta.pripravaNaDuchod)!
            
        } else {
            
            checkedCell = cellLabels.indexOf(udajeKlienta.chtelBysteSePripravit)!
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = cellLabels[indexPath.row]
        
        if indexPath.row == checkedCell {
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
        }
        
        return cell
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row != checkedCell {
            
            let tappedCell = tableView.cellForRowAtIndexPath(indexPath)
            
            tappedCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: checkedCell, inSection: 0))?.accessoryType = UITableViewCellAccessoryType.None
            
            checkedCell = indexPath.row
        }
        
        if parametr == 0 {
        
            udajeKlienta.pripravaNaDuchod = cellLabels[checkedCell]
            
        } else {
            
            udajeKlienta.chtelBysteSePripravit = cellLabels[checkedCell]
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
