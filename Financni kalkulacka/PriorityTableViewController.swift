//
//  PriorityTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 08.11.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import UIKit

class PriorityTableViewController: UITableViewController {
    
    var polozky = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Priority"
        
        let backItem = UIBarButtonItem(title: "Zpět", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        let forwardButton = UIBarButtonItem(image: UIImage(named: "forward.png"), style: .Plain, target: self, action: #selector(PriorityTableViewController.forward))
        let backwardButton = UIBarButtonItem(image: UIImage(named: "backward.png"), style: .Plain, target: self, action: #selector(PriorityTableViewController.backward))
        navigationItem.setRightBarButtonItems([forwardButton, backwardButton], animated: true)
        
        tableView.setEditing(true, animated: true)
        
        tableView.alwaysBounceVertical = false
        
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage()
        imageView.image = image.background(UIScreen.mainScreen().bounds.height)
        tableView.backgroundView = imageView
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        polozky = udajeKlienta.priority
        

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        udajeKlienta.jeVyplnenoPriority = true
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return polozky.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("priority") as! Priority
        
        let poradi = "\(indexPath.row + 1). "
        let polozka = NSMutableAttributedString(string: polozky[indexPath.row])
        
        let attributedString = NSMutableAttributedString()
        
        let attrs = [NSFontAttributeName : UIFont.boldSystemFontOfSize(20)]
        let boldString = NSMutableAttributedString(string: poradi, attributes: attrs)
        
        attributedString.appendAttributedString(boldString)
        attributedString.appendAttributedString(polozka)
        
        cell.polozka.attributedText = attributedString
        
        return cell
        
        
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
        
    }

    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        let polozka = polozky[sourceIndexPath.row]
        polozky.removeAtIndex(sourceIndexPath.row)
        polozky.insert(polozka, atIndex: destinationIndexPath.row)
        
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.None
        
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return false
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        return "Další bod: Finanční rozvaha"
    }
   
    @IBAction func zpet(sender: AnyObject) {
        
        udajeKlienta.priority = polozky
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func backward() {
        
        udajeKlienta.priority = polozky
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("7")
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    func forward() {
        
        udajeKlienta.priority = polozky
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("9")
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    
}
