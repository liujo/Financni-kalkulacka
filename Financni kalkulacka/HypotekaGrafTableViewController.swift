//
//  HypotekaGrafTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 30.11.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class HypotekaGrafTableViewController: UITableViewController, JBLineChartViewDataSource, JBLineChartViewDelegate, MFMailComposeViewControllerDelegate {
    
    let gradientLayer = CAGradientLayer()
    let jistinaColor = UIColor.greenColor()
    let urokColor = UIColor.redColor()
    
    var toPassPocetRokuGlobal = Int()
    var toPassPujcenyObnosGlobal = Int()
    var toPassCelkemUrokGlobal = Int()
    var toPassMesicniUrok = Float()
    var toPassMesicniPlatbaVcetneUrokuGlobal = Int()
    
    var soucetUroku = Float()
    var arrayOfInterest:[Float] = []
    
    var roky:[String] = []
    var castky:[Int] = []
    var uroky:[Int] = []
    
    var rokyLabels: [String] = []
    var castkyLabels: [String] = []
    
    //MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Graf hypotéky"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: #selector(HypotekaGrafTableViewController.sendEmail))
        
        updateData()
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
        _ = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("showChart"), userInfo: nil, repeats: false)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        
        let graphView: JBLineChartView = self.tableView.viewWithTag(20) as! JBLineChartView
        graphView.setState(.Collapsed, animated: true)
    
    }
    
    func showChart() {
        
        let graphView: JBLineChartView = self.tableView.viewWithTag(20) as! JBLineChartView
        graphView.reloadData()
        graphView.setState(.Expanded, animated: true)
    }
    
    //MARK: - JBLineChartView data source
    
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        
        return 2
    
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        
        return UInt(castky.count)
    
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        
        if lineIndex == 0 {
            
            return CGFloat(castky[Int(horizontalIndex)])
            
        } else {
            
            return CGFloat(uroky[Int(horizontalIndex)])
        }
    
    }
    
    func verticalSelectionWidthForLineChartView(lineChartView: JBLineChartView!) -> CGFloat {
        
        return 4
        
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalSelectionColorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        
        return UIColor.whiteColor()
        
    }
    
    func lineChartView(lineChartView: JBLineChartView!, selectionColorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        
        return UIColor.whiteColor()
        
    }
    
    func lineChartView(lineChartView: JBLineChartView!, dotRadiusForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        
        return 4
        
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        
        if lineIndex == 0 {
            
            return jistinaColor
            
        } else {
            
            return urokColor
        }
    }
    
    func lineChartView(lineChartView: JBLineChartView!, selectionColorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        
        return UIColor.whiteColor()
        
    }
    
    func lineChartView(lineChartView: JBLineChartView!, widthForLineAtLineIndex lineIndex: UInt) -> CGFloat {
        
        return 2
        
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        
        if lineIndex == 0 {
            
            return jistinaColor
            
        } else {
            
            return urokColor
            
        }
    }
    
    func lineChartView(lineChartView: JBLineChartView!, dimmedSelectionOpacityAtLineIndex lineIndex: UInt) -> CGFloat {
        
        return 0.15
        
    }
    
    func lineChartView(lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        
        return true
    }
    
    
    func lineChartView(lineChartView: JBLineChartView!, didSelectLineAtIndex lineIndex: UInt, horizontalIndex: UInt, touchPoint: CGPoint) {
        
        let infoLabel = self.tableView.viewWithTag(10) as! UILabel
        
        if lineIndex == 0 {
            
            let data = castky[Int(horizontalIndex)]
            infoLabel.text = "\(roky[Int(horizontalIndex)]) rok: zbývá \(numberFormattingInt(data)) Kč z jistiny"
            
        } else {
            
            let data = uroky[Int(horizontalIndex)]
            infoLabel.text = "\(roky[Int(horizontalIndex)]) rok: zaplaceno \(numberFormattingInt(data)) Kč na úrocích"
        
        }
        
        tableView.scrollEnabled = false
        
        
    }
    
    func didDeselectLineInLineChartView(lineChartView: JBLineChartView!) {
        
        let infoLabel = self.tableView.viewWithTag(10) as! UILabel
        infoLabel.text = ""
        
        tableView.scrollEnabled = true
        
    }
    
    //MARK: - vypocet popisnych labelu
    
    func vypocetRokyLabels(pocetRoku: Int) {
        
        if pocetRoku < 5 {
            
            let fl = pocetRoku/2
            rokyLabels = ["\(fl). rok", "\(pocetRoku). rok"]
            
        } else {
            
            let num1 = pocetRoku / 4
            let num2 = pocetRoku / 2
            let num3 = pocetRoku * 3/4
            let num4 = pocetRoku - 1
            
            rokyLabels = ["\(num1). rok", "\(num2). rok", "\(num3). rok", "\(num4). rok"]
            
            print(rokyLabels)
        }
    }
    
    func vypocetCastkyLabels(maxCastka: Int) {
        
        let num1 = maxCastka
        let num2 = maxCastka*3/4
        let num3 = maxCastka/2
        let num4 = maxCastka/4
        
        //formatting do stringu
        castkyLabels = [numberFormatting(num1), numberFormatting(num2), numberFormatting(num3), numberFormatting(num4)]
    }
    
    func numberFormatting(castka: Int) -> String {
        
        var num:Float = Float(castka)/1000000
        
        var result = String()
        
        if num > 1 {
            
            num = round(num*10)/10
            result = "\(num)M"
        
        } else {
            
            num = num * 1000
            
            result = "\(Int(num))K"
        }
        
        return result
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0 {
            
            return 1
            
        } else {
            
            return castky.count + 1
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 1 {
            
            return "Tabulka"
            
        } else {
            
            return "Graf"
        }
    }

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 275
        
        } else {
            
            if indexPath.row == 0 {
                
                return 44
            
            } else {
            
                return 30
            
            }
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("graf") as! GrafCell
            
            //setting gradient background
            gradientBackground()
            gradientLayer.frame = cell.contentView.bounds
            cell.contentView.layer.insertSublayer(gradientLayer, atIndex: 0)
            
            //graph setup
            cell.graphView.delegate = self
            cell.graphView.dataSource = self
            cell.graphView.tag = 20
            cell.graphView.minimumValue = 0
            cell.graphView.maximumValue = CGFloat(castky[castky.count - 1])
            
            cell.informationLabel.tag = 10
            cell.informationLabel.text = ""
            
            //vysvetlivky
            cell.jistinaView.layer.cornerRadius = 4
            cell.jistinaView.layer.backgroundColor = jistinaColor.CGColor
            
            cell.urokView.layer.cornerRadius = 4
            cell.urokView.layer.backgroundColor = urokColor.CGColor
            
            //popisky grafu: roky
            if rokyLabels.count == 2 {
                
                cell.roky1.hidden = true
                cell.roky3.hidden = true
                
                cell.roky2.text = rokyLabels[0]
                cell.roky4.text = rokyLabels[1]
                
            } else {
                
                cell.roky1.text = rokyLabels[0]
                cell.roky2.text = rokyLabels[1]
                cell.roky3.text = rokyLabels[2]
                cell.roky4.text = rokyLabels[3]
                
            }
            
            //popisky grafu: castky
            cell.castka1.text = castkyLabels[0]
            cell.castka2.text = castkyLabels[1]
            cell.castka3.text = castkyLabels[2]
            cell.castka4.text = castkyLabels[3]
            
            return cell
        
        } else {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("headerCell")
                
                return cell!
            
            } else {
             
                let cell = tableView.dequeueReusableCellWithIdentifier("tabulka") as! TabulkaCell
                
                let index = indexPath.row - 1
                
                cell.rokyLabel.text = "\(roky[index])"
                cell.jistinaLabel.text = "\(numberFormattingInt(castky[index])) Kč"
                cell.urokyLabel.text = "\(numberFormattingInt(uroky[index])) Kč"
                
                if indexPath.row % 2 == 0 {
                    
                    cell.backgroundColor = UIColor.whiteColor()
                    
                } else {
                
                    cell.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
                
                }
                
                return cell
            }
            
            
        }
        
        
    }
    
    func gradientBackground() {
        
        let color1 = UIColor(red: 15/255, green: 63/255, blue: 10/255, alpha: 1).CGColor
        let color2 = UIColor(red: 8/255, green: 161/255, blue: 2/255, alpha: 1).CGColor
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.0, 1]
    }
    
    //MARK: - update data
    
    func updateData() {
        
        rovniceVypoctuUroku()
        
        for var i = 1; i <= toPassPocetRokuGlobal; i++ {
            
            if i == toPassPocetRokuGlobal {
                
                castky.append(0)
                
            } else {
                
                castky.append(rovniceVypoctuJistiny(i))
                
            }
            roky.append("\(i).")
        }
        
        castky.insert(toPassPujcenyObnosGlobal, atIndex: 0)
        roky.insert("0.", atIndex: 0)
        uroky.insert(0, atIndex: 0)
        
        vypocetRokyLabels(roky.count)
        vypocetCastkyLabels(castky[0])

    }
    
    
    func rovniceVypoctuJistiny(rok: Int) -> Int {
        
        //tohle je rovnice, kde se pocita kolik jeste po roce x zbyva zaplatit (jistina + urok)
        //(1+r)^N*P - {[(1+r)^N - 1]/r}*c
        
        
        //leva strana - var a
        let a = pow(Double(1 + toPassMesicniUrok), Double(rok*12))*Double(toPassPujcenyObnosGlobal)
        
        //prava strana, horni cast - var b
        var b = pow(Double(1 + toPassMesicniUrok), Double(rok*12)) - 1
        
        //prava strana, dolni cast a nasobeni "c" - mesicni platba vc. uroku - var c
        b = b/Double(toPassMesicniUrok)
        b = b*Double(toPassMesicniPlatbaVcetneUrokuGlobal)
        
        let vysledek = a - b
        var vysledekRounded = Int(round(vysledek))
        
        //println(vysledekRounded)
        
        if vysledekRounded < 0 {
            
            print("Vysledek rounded: \(vysledekRounded)")
            
            vysledekRounded = 0
        }
        
        return vysledekRounded
    }
    
    func rovniceVypoctuUroku() {
        
        var jistina:Float = Float(toPassPujcenyObnosGlobal)
        let mesicniUrok:Float = toPassMesicniUrok
        let mesicniPlatba:Float = Float(toPassMesicniPlatbaVcetneUrokuGlobal)
        let dobaMesice = toPassPocetRokuGlobal*12
        
        for var i = 1; i <= dobaMesice; i++ {
            
            arrayOfInterest.append(Float(Float(jistina)*Float(mesicniUrok)))
            soucetUroku = soucetUroku + Float(Float(jistina)*Float(mesicniUrok))
            
            if i % 12 == 0 {
                
                uroky.append(Int(round(soucetUroku)))
            }
            
            jistina = Float(jistina) - Float(Float(mesicniPlatba) - Float(Float(jistina)*Float(mesicniUrok)))
            
        }
        
    }
    
    
    //MARK: - number formatting
    
    func numberFormattingInt(number: Int) -> String {
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        return formatter.stringFromNumber(number)!.stringByReplacingOccurrencesOfString(",", withString: " ")
        
    }
    
    //MARK: - share graph via email
    
    func sendEmail() {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        //mailComposerVC.setToRecipients(["someone@somewhere.com"])
        mailComposerVC.setSubject("Graf a tabulka hypotečního úvěru")
        //mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        
        let imageData2 = UIImagePNGRepresentation(tableView.screenshotExcludingAllHeaders(true, excludingAllFooters: true, excludingAllRows: false))
        mailComposerVC.addAttachmentData(imageData2!, mimeType: "image/png", fileName: "TableView_snapshot")
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Nelze poslat email", message: "Email se nepodařilo odeslat! Zkontrolujte nastavení svého telefonu a zkuste to znovu.", delegate: self, cancelButtonTitle: "Ok")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

}
