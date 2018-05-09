//
//  BaseTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 29.11.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Podpora"
        
        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
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
        return 6
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BaseCell
        
        let imgs = ["mortgage", "saving", "insurance", "salary", "schedule", "investment"]
        let labels = ["Hypoteční kalkulačka", "Výpočet spoření", "Zajištění příjmů", "Čistá mzda", "Program předčasného splacení", "Návratnost investice"]
        
        cell.label.text = labels[indexPath.row]
        cell.icon.image = UIImage(named: "\(imgs[indexPath.row]).png")

        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let ids = ["hypotekaSegue", "sporeniSegue", "zajisteniPrijmuSegue", "cistaMzdaSegue", "PPSSegue", "investiceSegue"]
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        self.performSegue(withIdentifier: ids[indexPath.row], sender: self)
        
    }
    
    

}
