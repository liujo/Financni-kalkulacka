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

class PPSGrafTableViewController: UITableViewController, JBLineChartViewDataSource, JBLineChartViewDelegate, MFMailComposeViewControllerDelegate {
    
    
    
    let gradientLayer = CAGradientLayer()
    let jistinaColor = UIColor.green
    let urokColor = UIColor.blue
    
    var mesicSplaceni = Int()
    var poleSporeni:[Int] = []
    var poleJistin:[Int] = []
    var hlaskaSplaceni = String()
    
    var roky:[String] = []
    var castky:[Int] = []
    var sporeni:[Int] = []
    
    var rokyLabels: [String] = []
    var castkyLabels: [String] = []
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Graf PPS"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: "sendEmail")
        
        vypocet()
               
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: Selector("showChart"), userInfo: nil, repeats: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let graphView: JBLineChartView = self.tableView.viewWithTag(20) as! JBLineChartView
        graphView.setState(.collapsed, animated: true)
        
    }
    
    func showChart() {
        
        let graphView: JBLineChartView = self.tableView.viewWithTag(20) as! JBLineChartView
        graphView.reloadData()
        graphView.setState(.expanded, animated: true)
        
    }
    
    //MARK: - JBLineChartView data source
    
    func numberOfLines(in lineChartView: JBLineChartView!) -> UInt {
        return 2
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        
        return UInt(castky.count)
        
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        
        if lineIndex == 0 {
            
            return CGFloat(castky[Int(horizontalIndex)])
            
        } else {
            
            return CGFloat(sporeni[Int(horizontalIndex)])
        }
        
    }
    
    func verticalSelectionWidthForLineChartView(lineChartView: JBLineChartView!) -> CGFloat {
        
        return 4
        
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, verticalSelectionColorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        
        return UIColor.white
        
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, selectionColorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        
        return UIColor.white
        
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, dotRadiusForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        
        return 4
        
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, colorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        
        if lineIndex == 0 {
            
            return jistinaColor
            
        } else {
            
            return urokColor
        }
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, selectionColorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        
        return UIColor.white
        
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, widthForLineAtLineIndex lineIndex: UInt) -> CGFloat {
        
        return 2
        
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        
        if lineIndex == 0 {
            
            return jistinaColor
            
        } else {
            
            return urokColor
            
        }
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, dimmedSelectionOpacityAtLineIndex lineIndex: UInt) -> CGFloat {
        
        return 0.15
        
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        
        return true
    }
    
    
    func lineChartView(_ lineChartView: JBLineChartView!, didSelectLineAt lineIndex: UInt, horizontalIndex: UInt, touch touchPoint: CGPoint) {
        
        let infoLabel = self.tableView.viewWithTag(10) as! UILabel
        
        if lineIndex == 0 {
            
            let data = castky[Int(horizontalIndex)]
            infoLabel.text = "\(roky[Int(horizontalIndex)]) rok: zbývá \(numberFormattingInt(number: data)) Kč z jistiny"
            
        } else {
            
            let data = sporeni[Int(horizontalIndex)]
            infoLabel.text = "\(roky[Int(horizontalIndex)]) rok: uspořeno \(numberFormattingInt(number: data)) Kč"
            
        }
        
        tableView.isScrollEnabled = false
        
        
    }
    
    func didDeselectLineInLineChartView(lineChartView: JBLineChartView!) {
        
        let infoLabel = self.tableView.viewWithTag(10) as! UILabel
        infoLabel.text = hlaskaSplaceni
        
        tableView.isScrollEnabled = true
        
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
        }
    }
    
    func vypocetCastkyLabels(maxCastka: Int) {
        
        let num1 = maxCastka
        let num2 = maxCastka*3/4
        let num3 = maxCastka/2
        let num4 = maxCastka/4
        
        //formatting do stringu
        castkyLabels = [numberFormatting(castka: num1), numberFormatting(castka: num2), numberFormatting(castka: num3), numberFormatting(castka: num4)]
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0 {
            
            return 1
            
        } else {
            
            return castky.count + 1
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 1 {
            
            return "Tabulka"
            
        } else {
            
            return "Graf"
        }
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "graf") as! PPSCell
            
            //setting gradient background
            gradientBackground()
            gradientLayer.frame = cell.contentView.bounds
            cell.contentView.layer.insertSublayer(gradientLayer, at: 0)
            
            //graph setup
            cell.graphView.delegate = self
            cell.graphView.dataSource = self
            cell.graphView.tag = 20
            cell.graphView.minimumValue = 0
            cell.graphView.maximumValue = CGFloat(castky[0])
            
            cell.informationLabel.tag = 10
            cell.informationLabel.text = ""
            
            //vysvetlivky
            cell.jistinaKolecko.layer.cornerRadius = 4
            cell.jistinaKolecko.layer.backgroundColor = jistinaColor.cgColor
            
            cell.urokKolecko.layer.cornerRadius = 4
            cell.urokKolecko.layer.backgroundColor = urokColor.cgColor
            
            //popisky grafu: roky
            if rokyLabels.count == 2 {
                
                cell.roky1.isHidden = true
                cell.roky3.isHidden = true
                
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
            
            cell.informationLabel.text = hlaskaSplaceni
            
            return cell
            
        } else {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
                
                return cell!
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "tabulka") as! PPSTabulkaCell
                
                let index = indexPath.row - 1
                
                cell.rokyLabel.text = "\(roky[index])"
                cell.jistinaLabel.text = "\(numberFormattingInt(number: castky[index])) Kč"
                cell.urokyLabel.text = "\(numberFormattingInt(number: sporeni[index])) Kč"
                
                if indexPath.row % 2 == 0 {
                    
                    cell.backgroundColor = UIColor.white
                    
                } else {
                    
                    cell.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
                    
                }
                
                return cell
            }
            
            
        }
        
        
    }
    
    func gradientBackground() {
        
        let color1 = UIColor(red: 15/255, green: 63/255, blue: 10/255, alpha: 1).cgColor
        let color2 = UIColor(red: 8/255, green: 161/255, blue: 2/255, alpha: 1).cgColor
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.0, 1]
    }
    
    //MARK: - update data
    
    func vypocet() {
        
        castky = poleJistin
        sporeni = poleSporeni
        
        var i = 0
        while i < castky.count {
            
            roky.append("\(i).")
            i += 1
            
        }
        
        vypocetCastkyLabels(maxCastka: poleJistin[0])
        vypocetRokyLabels(pocetRoku: roky.count)
        
        print(castky.count, castky)
        print(sporeni.count, sporeni)
        print(roky.count, roky)
    }
    
    
    //MARK: - number formatting
    
    func numberFormattingInt(number: Int) -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        return formatter.stringFromNumber(number)!.stringByReplacingOccurrencesOfString(",", withString: " ")
    }
    
    //MARK: - share graph via email
    
    func sendEmail() {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
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
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
