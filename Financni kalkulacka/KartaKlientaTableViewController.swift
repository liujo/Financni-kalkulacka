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
    
    let defaults = UserDefaults.standard
    var clientID = Int()
    
    var filtered:[String] = []
    var cellLabels: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Karta klienta"
        
        searchController.searchBar.placeholder = "Filtrovat"
        
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage()
        imageView.image = image.background(height: UIScreen.main.bounds.height)
        tableView.backgroundView = imageView
        
        //timhle muzu smazat vsechny soubory
        //defaults.removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
        
        if defaults.dictionaryRepresentation().keys.contains("clientsArray") != true {
            
            let arr: [Int] = []
            defaults.set(arr, forKey: "clientsArray")
        
        }
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //print vsech ulozenych dat v userdefaults
        //print(defaults.dictionaryRepresentation())
        
        if let arr = self.defaults.array(forKey: "clientsArray"), arr.count < 1 {
            
            self.upravitButton.isEnabled = false
            
        } else {
            
            self.upravitButton.isEnabled = true
        }
        
        cellLabels.removeAll()
        generateCellLabels()
        tableView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if searchController.isActive {
            
            searchController.isActive = false
            
        }
    }
    
    
    // MARK: edit button
    
    @IBAction func upravitPoradi(sender: AnyObject) {
        
        if tableView.isEditing == false {
            
            tableView.setEditing(true, animated: true)
            upravitButton.style = .done
            upravitButton.title = "Hotovo"
            
        } else {
            
            tableView.setEditing(false, animated: true)
            upravitButton.style = .plain
            upravitButton.title = "Upravit"
        }
    }
    

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections

        return 1
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            return filtered.count
            
        }
        
        return cellLabels.count
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "novyKlient", for: indexPath as IndexPath) as! KartaKlientaCell
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            cell.textLabel?.text = filtered[indexPath.row]
        
        } else {
        
            cell.textLabel?.text = cellLabels[indexPath.row]
        
        }
        
        return cell
    
    }
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var index = indexPath.row
        
        if searchController.isActive {
            
            let path = tableView.indexPathForSelectedRow
            let currentCell = tableView.cellForRow(at: path!) as! KartaKlientaCell
            let textLabel = currentCell.textLabel?.text
            
            index = cellLabels.index(of: textLabel!)!
            
        }
        
        clientID = defaults.array(forKey: "clientsArray")![index] as! Int
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        self.performSegue(withIdentifier: "existingClient", sender: self)
    
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "existingClient" {
            
            let destination = segue.destination as! UINavigationController
            let vc = destination.topViewController as! NovyKlientTableViewController
            
            vc.clientID = clientID
            
            
        }
        
        if segue.identifier == "newClient" {
            
            let destination = segue.destination as! UINavigationController
            let vc = destination.topViewController as! NovyKlientTableViewController
            
            vc.clientID = 0
        }
        
    }
    
    //MARK: editing tableview rows
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        if searchController.active {
            
            return UITableViewCellEditingStyle.none
        
        } else {
            
            return UITableViewCellEditingStyle.delete

        }
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let optionMenu = UIAlertController(title: nil, message: "Opravdu chcete smazat údaje klienta? Data budou smazána a nenávratně ztracena.", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Smazat údaje klienta", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            
            var clientsArray = self.defaults.array(forKey: "clientsArray")
            self.defaults.removeObject(forKey: "\(clientsArray![indexPath.row])")
            clientsArray?.remove(at: indexPath.row)
            self.defaults.set(clientsArray, forKey: "clientsArray")
            
            self.generateCellLabels()
            tableView.reloadData()
            
            if (self.defaults.array(forKey: "clientsArray")?.count)! < 1 {
                
                tableView.setEditing(false, animated: true)
                self.upravitButton.style = .plain
                self.upravitButton.title = "Upravit"
                self.upravitButton.isEnabled = false
                
            } else {
                
                self.upravitButton.isEnabled = true
            }
        })
        
        let dismissAction = UIAlertAction(title: "Zrušit", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(dismissAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        var clientsArray = defaults.object(forKey: "clientsArray") as! [Int]
        let polozka = clientsArray[sourceIndexPath.row]
        clientsArray.remove(at: sourceIndexPath.row)
        clientsArray.insert(polozka, at: destinationIndexPath.row)
        defaults.set(clientsArray, forKey: "clientsArray")
        
        generateCellLabels()
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    func generateCellLabels() {
        
        let clientsArray = defaults.array(forKey: "clientsArray") as! [Int]
        print(clientsArray)
        
        var arr: [String] = []
        
        var i = 0
        while i < clientsArray.count {
            
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
            i += 1
        }
        
        cellLabels = arr
        print(cellLabels)
        
    }
    
    @IBAction func newClient(sender: AnyObject) {
        
        //resetStruct()
        self.performSegue(withIdentifier: "newClient", sender: self)
        
    }
    
    
    //MARK: - UISearchController methods
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        filtered = cellLabels.filter { str in
            
            //return str.lowercaseString.containsString(searchText.lowercaseString)
            return str.lowercased().contains(searchText.lowercased())
            
        }
        
        tableView.reloadData()
    }
    
    
}

extension KartaKlientaTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
