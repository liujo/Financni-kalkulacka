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
            
            checkedCell = cellLabels.index(of: udajeKlienta.pripravaNaDuchod)!
            
        } else {
            
            checkedCell = cellLabels.index(of: udajeKlienta.chtelBysteSePripravit)!
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
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.textLabel?.text = cellLabels[indexPath.row]
        
        if indexPath.row == checkedCell {
            
            cell.accessoryType = .checkmark
            
        }
        
        return cell
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row != checkedCell {
            
            let tappedCell = tableView.cellForRow(at: indexPath as IndexPath)
            tappedCell?.accessoryType = .checkmark
            //tableView.cellForRowAtIndexPath(NSIndexPath(forRow: checkedCell, inSection: 0))?.accessoryType = UITableViewCellAccessoryType.None
            tableView.cellForRow(at: IndexPath(row: checkedCell, section: 0))?.accessoryType = .none
            checkedCell = indexPath.row
        }
        
        if parametr == 0 {
        
            udajeKlienta.pripravaNaDuchod = cellLabels[checkedCell]
            
        } else {
            
            udajeKlienta.chtelBysteSePripravit = cellLabels[checkedCell]
        }
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }

}
