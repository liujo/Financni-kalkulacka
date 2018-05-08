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
        
        let backItem = UIBarButtonItem(title: "Zpět", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        let forwardButton = UIBarButtonItem(image: UIImage(named: "forward.png"), style: .plain, target: self, action: #selector(PriorityTableViewController.forward))
        let backwardButton = UIBarButtonItem(image: UIImage(named: "backward.png"), style: .plain, target: self, action: #selector(PriorityTableViewController.backward))
        navigationItem.setRightBarButtonItems([forwardButton, backwardButton], animated: true)
        
        tableView.setEditing(true, animated: true)
        
        tableView.alwaysBounceVertical = false
        
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage()
        imageView.image = image.background(height: UIScreen.main.bounds.height)
        tableView.backgroundView = imageView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        polozky = udajeKlienta.priority
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        udajeKlienta.jeVyplnenoPriority = true
        
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return polozky.count
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "priority") as! Priority
        
        let poradi = "\(indexPath.row + 1). "
        let polozka = NSMutableAttributedString(string: polozky[indexPath.row])
        
        let attributedString = NSMutableAttributedString()
        
        let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 20)]
        let boldString = NSMutableAttributedString(string: poradi, attributes: attrs)
        
        attributedString.append(boldString)
        attributedString.append(polozka)
        
        cell.polozka.attributedText = attributedString
        
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
        
    }

    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        let polozka = polozky[sourceIndexPath.row]
        polozky.remove(at: sourceIndexPath.row)
        polozky.insert(polozka, at: destinationIndexPath.row)
        
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        return .none
        
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return false
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        return "Další bod: Finanční rozvaha"
    }
   
    @IBAction func zpet(sender: AnyObject) {
        
        udajeKlienta.priority = polozky
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func backward() {
        
        udajeKlienta.priority = polozky
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "7")
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    @objc func forward() {
        
        udajeKlienta.priority = polozky
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "9")
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    
}
