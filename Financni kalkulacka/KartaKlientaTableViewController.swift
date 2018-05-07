//
//  KartaKlientaTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 05.12.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import UIKit

class KartaKlientaTableViewController: UITableViewController, UISearchControllerDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var upravitButton: UIBarButtonItem!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var clientID = Int()
    
    var filtered:[String] = []
    var cellLabels: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Karta klienta"
        
        searchController.searchBar.placeholder = "Filtrovat"
        
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage()
        imageView.image = image.background(UIScreen.mainScreen().bounds.height)
        tableView.backgroundView = imageView
        
        //timhle muzu smazat vsechny soubory
        //defaults.removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
        
        if defaults.dictionaryRepresentation().keys.contains("clientsArray") != true {
            
            let arr: [Int] = []
            defaults.setObject(arr, forKey: "clientsArray")
        
        }
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //print vsech ulozenych dat v userdefaults
        //print(defaults.dictionaryRepresentation())
        
        if self.defaults.arrayForKey("clientsArray")?.count < 1 {
            
            self.upravitButton.enabled = false
            
        } else {
            
            self.upravitButton.enabled = true
        }
        
        cellLabels.removeAll()
        generateCellLabels()
        tableView.reloadData()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        if searchController.active {
            
            searchController.active = false
            
        }
    }
    
    
    // MARK: edit button
    
    @IBAction func upravitPoradi(sender: AnyObject) {
        
        if tableView.editing == false {
            
            tableView.setEditing(true, animated: true)
            upravitButton.style = .Done
            upravitButton.title = "Hotovo"
            
        } else {
            
            tableView.setEditing(false, animated: true)
            upravitButton.style = .Plain
            upravitButton.title = "Upravit"
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections

        return 1
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if searchController.active && searchController.searchBar.text != "" {
            
            return filtered.count
            
        }
        
        return cellLabels.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("novyKlient", forIndexPath: indexPath) as! KartaKlientaCell
        
        if searchController.active && searchController.searchBar.text != "" {
            
            cell.textLabel?.text = filtered[indexPath.row]
        
        } else {
        
            cell.textLabel?.text = cellLabels[indexPath.row]
        
        }
        
        return cell
    
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var index = indexPath.row
        
        if searchController.active {
            
            let path = tableView.indexPathForSelectedRow
            let currentCell = tableView.cellForRowAtIndexPath(path!) as! KartaKlientaCell
            let textLabel = currentCell.textLabel?.text
            
            index = cellLabels.indexOf(textLabel!)!
            
        }
        
        clientID = defaults.arrayForKey("clientsArray")![index] as! Int
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.performSegueWithIdentifier("existingClient", sender: self)
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "existingClient" {
            
            let destination = segue.destinationViewController as! UINavigationController
            let vc = destination.topViewController as! NovyKlientTableViewController
            
            vc.clientID = clientID
            
            
        }
        
        if segue.identifier == "newClient" {
            
            let destination = segue.destinationViewController as! UINavigationController
            let vc = destination.topViewController as! NovyKlientTableViewController
            
            vc.clientID = 0
        }
        
    }
    
    //MARK: editing tableview rows
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        if searchController.active {
            
            return UITableViewCellEditingStyle.None
        
        } else {
            
            return UITableViewCellEditingStyle.Delete

        }
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let optionMenu = UIAlertController(title: nil, message: "Opravdu chcete smazat údaje klienta? Data budou smazána a nenávratně ztracena.", preferredStyle: .ActionSheet)
        
        let deleteAction = UIAlertAction(title: "Smazat údaje klienta", style: .Destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            
            var clientsArray = self.defaults.arrayForKey("clientsArray")
            self.defaults.removeObjectForKey("\(clientsArray![indexPath.row])")
            clientsArray?.removeAtIndex(indexPath.row)
            self.defaults.setObject(clientsArray, forKey: "clientsArray")
            
            self.generateCellLabels()
            tableView.reloadData()
            
            if self.defaults.arrayForKey("clientsArray")?.count < 1 {
                
                tableView.setEditing(false, animated: true)
                self.upravitButton.style = .Plain
                self.upravitButton.title = "Upravit"
                self.upravitButton.enabled = false
                
            } else {
                
                self.upravitButton.enabled = true
            }
        })
        
        let dismissAction = UIAlertAction(title: "Zrušit", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(dismissAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        var clientsArray = defaults.objectForKey("clientsArray") as! [Int]
        let polozka = clientsArray[sourceIndexPath.row]
        clientsArray.removeAtIndex(sourceIndexPath.row)
        clientsArray.insert(polozka, atIndex: destinationIndexPath.row)
        defaults.setObject(clientsArray, forKey: "clientsArray")
        
        generateCellLabels()
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    func generateCellLabels() {
        
        let clientsArray = defaults.arrayForKey("clientsArray") as! [Int]
        print(clientsArray)
        
        var arr: [String] = []
        
        for var i = 0; i < clientsArray.count; i += 1 {
            
            let ID = clientsArray[i] as! Int
            let client = defaults.objectForKey("\(ID)")
            
            let krestniJmeno = client!["krestniJmeno"] as? String
            let prijmeni = client!["prijmeni"] as? String
            let povolani = client!["povolani"] as? String
            
            var str = String()
            
            if krestniJmeno == nil || prijmeni == nil {
                
                str = "Klient"
                
            } else {
                
                str = "\(krestniJmeno!) \(prijmeni!)"
            }
            
            if povolani != nil {
                
                str = str + ", \(povolani!)"
                
            }
            
            if arr.contains(str) {
                
                str = str + "1"
            }
            
            arr.append(str)
        }
        
        cellLabels = arr
        print(cellLabels)
        
    }
    
    @IBAction func newClient(sender: AnyObject) {
        
        //resetStruct()
        self.performSegueWithIdentifier("newClient", sender: self)
        
    }
    
    
    //MARK: - UISearchController methods
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        filtered = cellLabels.filter { str in
            
            return str.lowercaseString.containsString(searchText.lowercaseString)
            
        }
        
        tableView.reloadData()
    }
    
    
}

extension KartaKlientaTableViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        filterContentForSearchText(searchController.searchBar.text!)
        
    }
}
