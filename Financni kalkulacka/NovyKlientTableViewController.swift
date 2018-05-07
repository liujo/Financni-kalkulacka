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

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hotovo", style: .plain, target: self, action: #selector(NovyKlientTableViewController.hotovoButton))
        
        if clientID != Int() {
        
            fillStruct(clientID: clientID)
        
        } else {
            
            resetStruct()
        }
        
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage()
        imageView.image = image.background(height: UIScreen.main.bounds.height)
        tableView.backgroundView = imageView
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if udajeKlienta.krestniJmeno == nil || udajeKlienta.prijmeni == nil {
            
            self.title = "Nový klient"
            
        } else {
            
            let krestniJmeno = udajeKlienta.krestniJmeno
            let mezera = " "
            let prijmeni = udajeKlienta.prijmeni
            
            self.title = krestniJmeno! + mezera + prijmeni!
        }
        
        jeVyplnenoArr = [udajeKlienta.jeVyplnenoUdaje, udajeKlienta.jeVyplnenoZajisteniPrijmu, udajeKlienta.jeVyplnenoBydleni, udajeKlienta.jeVyplnenoDeti, udajeKlienta.jeVyplnenoDuchod, udajeKlienta.jeVyplnenoDane, udajeKlienta.jeVyplnenoOstatniPozadavky, udajeKlienta.jeVyplnenoPriority]
        
        if let realnaCastkaNaProjekt = udajeKlienta.realnaCastkaNaProjekt, realnaCastkaNaProjekt > 0 {
            
            jeVyplnenoArr.append(true)
            
        } else {
            
            jeVyplnenoArr.append(false)
            
        }
                
        tableView.reloadData()
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return labels.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NovyKlientCell

        cell.poradi.text = "\(indexPath.row + 1)."
        cell.lbl.text = labels[indexPath.row]
        cell.poradi.textColor = UIColor.black
        cell.lbl.textColor = UIColor.black
        cell.isUserInteractionEnabled = true
        cell.accessoryType = .disclosureIndicator
        
        
        if jeVyplnenoArr[indexPath.row] == true {
                
            let greenTint = UIColor(red: 5/255, green: 128/255, blue: 0/255, alpha: 1)
            cell.poradi.textColor = greenTint
            cell.lbl.textColor = greenTint
                
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegue(withIdentifier: ids[indexPath.row], sender: self)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    
    
    @objc func hotovoButton() {
        
        print("hotovo")
        
        var arr: [String] = []
        arr = arr.actionSheetStrings()
        
        let optionMenu = UIAlertController(title: arr[0], message: arr[1], preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: arr[2], style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.exportData()
            self.dismiss(animated: true, completion: nil)
        })
        
        let saveAction = UIAlertAction(title: arr[3], style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }

}


