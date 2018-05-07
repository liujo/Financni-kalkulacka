//
//  OstatniPozadavkyTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 08.11.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import UIKit

class OstatniPozadavkyTableViewController: UITableViewController, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Ostatní požadavky"
        
        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        let forwardButton = UIBarButtonItem(image: UIImage(named: "forward.png"), style: .Plain, target: self, action: #selector(OstatniPozadavkyTableViewController.forward))
        let backwardButton = UIBarButtonItem(image: UIImage(named: "backward.png"), style: .Plain, target: self, action: #selector(OstatniPozadavkyTableViewController.backward))
        navigationItem.setRightBarButtonItems([forwardButton, backwardButton], animated: true)
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hotovo", style: .Plain, target: self, action: "hotovoButton")
        
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage()
        imageView.image = image.background(UIScreen.mainScreen().bounds.height)
        tableView.backgroundView = imageView
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        udajeKlienta.jeVyplnenoOstatniPozadavky = true
        
        endEditingNow()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ostatniPozadavky") as! OstatniPozadavky
        
        cell.ostatniPozadavky.text = udajeKlienta.ostatniPozadavky

        cell.ostatniPozadavky.delegate = self
        
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 44*6
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Další požadavky klienta"
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        return "Další bod: Priority"
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        udajeKlienta.ostatniPozadavky = textView.text
        
        if textView.text == "" {
            
            udajeKlienta.chceResitOstatniPozadavky = false
            prioritiesUpdate("Ostatní požadavky", chceResit: false)
            
        } else {
            
            udajeKlienta.chceResitOstatniPozadavky = true
            prioritiesUpdate("Ostatní požadavky", chceResit: true)
            
        }
        
        
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        let toolbar = UIToolbar()
        textView.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true
        
    }
    
    
    @IBAction func zpet(sender: AnyObject) {
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    func backward() {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("6")
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    func forward() {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("8")
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    
}
