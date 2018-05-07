//
//  NovyKlientTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 17.12.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import UIKit

class NovyKlientTableViewController: UITableViewController {
    
    let labels = ["Základní údaje klienta", "Zabezpečení příjmů", "Bydlení", "Děti", "Důchod", "Daňové úlevy", "Ostatní požadavky", "Priority", "Shrnutí"]
    let ids = ["zakladniUdaje", "zabezpeceniPrijmu", "bydleni", "deti", "duchod", "dane", "ostatniPozadavky", "priority", "shrnuti"]
    var clientID = Int()
    
    var jeVyplnenoArr = [Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hotovo", style: .Plain, target: self, action: #selector(NovyKlientTableViewController.hotovoButton))
        
        if clientID != Int() {
        
            fillStruct(clientID)
        
        } else {
            
            resetStruct()
        }
        
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage()
        imageView.image = image.background(UIScreen.mainScreen().bounds.height)
        tableView.backgroundView = imageView
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if udajeKlienta.krestniJmeno == nil || udajeKlienta.prijmeni == nil {
            
            self.title = "Nový klient"
            
        } else {
            
            let krestniJmeno = udajeKlienta.krestniJmeno
            let mezera = " "
            let prijmeni = udajeKlienta.prijmeni
            
            self.title = krestniJmeno! + mezera + prijmeni!
        }
        
        jeVyplnenoArr = [udajeKlienta.jeVyplnenoUdaje, udajeKlienta.jeVyplnenoZajisteniPrijmu, udajeKlienta.jeVyplnenoBydleni, udajeKlienta.jeVyplnenoDeti, udajeKlienta.jeVyplnenoDuchod, udajeKlienta.jeVyplnenoDane, udajeKlienta.jeVyplnenoOstatniPozadavky, udajeKlienta.jeVyplnenoPriority]
        
        if udajeKlienta.realnaCastkaNaProjekt > 0 {
            
            jeVyplnenoArr.append(true)
            
        } else {
            
            jeVyplnenoArr.append(false)
            
        }
                
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return labels.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! NovyKlientCell

        cell.poradi.text = "\(indexPath.row + 1)."
        cell.lbl.text = labels[indexPath.row]
        cell.poradi.textColor = UIColor.blackColor()
        cell.lbl.textColor = UIColor.blackColor()
        cell.userInteractionEnabled = true
        cell.accessoryType = .DisclosureIndicator
        
        
        if jeVyplnenoArr[indexPath.row] == true {
                
            let greenTint = UIColor(red: 5/255, green: 128/255, blue: 0/255, alpha: 1)
            cell.poradi.textColor = greenTint
            cell.lbl.textColor = greenTint
                
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier(ids[indexPath.row], sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    
    func hotovoButton() {
        
        print("hotovo")
        
        var arr: [String] = []
        arr = arr.actionSheetStrings()
        
        let optionMenu = UIAlertController(title: arr[0], message: arr[1], preferredStyle: .ActionSheet)
        
        let deleteAction = UIAlertAction(title: arr[2], style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.exportData()
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        let saveAction = UIAlertAction(title: arr[3], style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }

}


