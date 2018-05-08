//
//  PDFViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 08.12.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class PDFViewController: UIViewController, MFMailComposeViewControllerDelegate, JBLineChartViewDelegate, JBLineChartViewDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var webView: UIWebView!
    
    var filePath = String()
    
    //jbchartview data
    var roky:[String] = []
    var grafArray1:[Int] = []
    var grafArray2:[Int] = []
    
    //tableviewdata
    
    //bydleni
    var bydleniRoky:[String] = []
    var bydleniGrafArray1:[Int] = []
    var bydleniGrafArray2:[Int] = []
    
    //duchod
    var duchodRoky:[String] = []
    var duchodGrafArray1:[Int] = []
    var duchodGrafArray2:[Int] = []
    
    //deti
    var dite1Roky:[String] = []
    var dite1GrafArray1:[Int] = []
    var dite1GrafArray2:[Int] = []
    
    var dite2Roky:[String] = []
    var dite2GrafArray1:[Int] = []
    var dite2GrafArray2:[Int] = []

    var dite3Roky:[String] = []
    var dite3GrafArray1:[Int] = []
    var dite3GrafArray2:[Int] = []
    
    var dite4Roky:[String] = []
    var dite4GrafArray1:[Int] = []
    var dite4GrafArray2:[Int] = []
    
    var maxValue = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Náhled PDF"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(PDFViewController.sendEmail))
        
        webView.isOpaque = false
        webView.backgroundColor = UIColor.lightGray
        webView.scalesPageToFit = true
        
        //firstPage
        //page data
        var detiBool = (false, true)
        
        if detiRelevantNumber() < 3 {
            
            detiBool = (true, false)
        }
        
        let sectionViews = [zakladniUdajeSection(), prioritySection(), detiSection(includeFooter: detiBool.0), detiSection2(includeSecondPart: detiBool.1), zajisteniPrijmuSection(), bydleniSection(), duchodSection(), daneSection(), ostatniPozadavkySection(), klientNechceResit(), shrnutiSection()]

        let bools = [true, true, udajeKlienta.chceResitDeti, udajeKlienta.chceResitDeti, udajeKlienta.chceResitZajisteniPrijmu, udajeKlienta.chceResitBydleni, udajeKlienta.chceResitDuchod, udajeKlienta.chceteResitDane, udajeKlienta.chceResitOstatniPozadavky, true, true]
        
        var page1 = UIView.loadFromNibNamed("pdf")!
        var height = 104
        var views = [UIView]()
        
        for view in sectionViews {
            
            let sectionView = view
            let int = sectionViews.index(of: sectionView)!
            
            if bools[int] && height + Int(sectionView.bounds.height) + 12 < 1066 {
                
                sectionView.frame = CGRect(x: 25, y: CGFloat(height), width: sectionView.bounds.width, height: sectionView.bounds.height)
                sectionView.layer.borderWidth = 0.5
                sectionView.layer.borderColor = UIColor.black.cgColor
                sectionView.layer.cornerRadius = 7.5
                page1.addSubview(sectionView)
                
                height = height + Int(sectionView.bounds.height) + 12
                
            } else if height + Int(sectionView.bounds.height) + 12 >= 1066 {
                
                print("new page")
                
                views.append(page1)
                page1 = UIView.loadFromNibNamed("pdf")!
                height = 104
                
                sectionView.frame = CGRect(x: 25, y: CGFloat(height), width: sectionView.bounds.width, height: sectionView.bounds.height)
                sectionView.layer.borderWidth = 0.5
                sectionView.layer.borderColor = UIColor.black.cgColor
                sectionView.layer.cornerRadius = 7.5
                page1.addSubview(sectionView)
                
                height = height + Int(sectionView.bounds.height) + 12
                
            }
            
            if sectionViews.last == sectionView {
                
                views.append(page1)
                
            }
            
            
        }
        
        
        createPdfFromView(views: views, saveToDocumentsWithFileName: "pdf1")
        showPDF(fileName: "pdf1")
    }
    
    //MARK: - fill sections with info
    //MARK: - 1. section: zakladni udaje
    
    func zakladniUdajeSection() -> UIView {
        
        var jmeno = String()
        
        if udajeKlienta.krestniJmeno != nil || udajeKlienta.prijmeni != nil {
            
            jmeno = udajeKlienta.krestniJmeno! + " " + udajeKlienta.prijmeni!
            
        }
        
        //prvni sekce
        
        var data: [AnyObject?] = [
            
            jmeno as AnyObject,
            udajeKlienta.vek as AnyObject,
            udajeKlienta.povolani as AnyObject,
            udajeKlienta.sport as AnyObject,
            udajeKlienta.zdravotniStav as AnyObject,
            udajeKlienta.rodinnyStav as AnyObject,
            udajeKlienta.pracovniPomer as AnyObject,
            udajeKlienta.pocetDeti as AnyObject,
            udajeKlienta.prijmy?.currencyFormattingWithSymbol(currencySymbol: "Kč") as AnyObject,
            udajeKlienta.vydaje?.currencyFormattingWithSymbol(currencySymbol: "Kč") as AnyObject,
            
            ]
        
        if udajeKlienta.rodinnyStav != "Svobodný" {
            
            data.append("Partner(ka)" as AnyObject)
            data.append(udajeKlienta.pracovniPomerPartner as AnyObject)
            data.append(udajeKlienta.prijmyPartner as AnyObject)
            data.append(udajeKlienta.vydajePartner as AnyObject)
            data.append("Pracovní poměr" as AnyObject)
            data.append("Příjem" as AnyObject)
            data.append("Výdaje" as AnyObject)
            
        } else {
            
            data.append(String() as AnyObject)
            data.append(String() as AnyObject)
            data.append(String() as AnyObject)
            data.append(String() as AnyObject)
            data.append(String() as AnyObject)
            data.append(String() as AnyObject)
            data.append(String() as AnyObject)
            
        }
        
        var i = 0
        
        while i < data.count {
            
            let thing = data[i]
            
            if thing == nil {
                
                data[i] = String() as AnyObject
            }
            
            i += 1
        }
        
        let sectionView = UIView.loadFromNibNamed("ZakladniUdaje")!
        for subview in sectionView.subviews {
            
            if subview.isKindOfClass(UILabel) {
                
                if subview.tag > 0 && subview.tag < 18 {
                    
                    let label: UILabel = subview as! UILabel
                    let str = "\(data[label.tag - 1]!)"
                    label.text = str
                    
                }
            }
        }
        
        return sectionView
        
    }
    
    //MARK: - 2. section: priority
    
    func prioritySection() -> UIView {
        
        //druha sekce
        var data2 = [String]()
        
        var o = 0
        while o < udajeKlienta.priority.count {
            
            data2.append("\(o + 1). \(udajeKlienta.priority[o])")
            o += 1
            
        }
        
        if data2.count < 6 {
            
            while data2.count < 6 {
                
                data2.append(String())
                
            }
            
        }
        
        let sectionView = UIView.loadFromNibNamed("Priority")!
        for subview in sectionView.subviews {
            
            if subview.isKindOfClass(UILabel) {
                
                if subview.tag > 14 {
                    
                    let label: UILabel = subview as! UILabel
                    label.text = "\(data2[label.tag - 15])"
                    
                }
            }
        }
        
        return sectionView
    }
    
    //MARK: - 3. section: zajisteni prijmu
    
    func zajisteniPrijmuSection() -> UIView {
        
        if udajeKlienta.chceResitZajisteniPrijmu == false {
            
            return UIView()
        }
        
        //prvni sekce
        
        var data: [AnyObject?] = [
            
            udajeKlienta.maUver as AnyObject,
            udajeKlienta.dluznaCastka?.currencyFormattingWithSymbol(currencySymbol: "Kč") as AnyObject,
            udajeKlienta.mesicniSplatkaUveru?.currencyFormattingWithSymbol(currencySymbol: "Kč") as AnyObject,
            udajeKlienta.rokFixace as AnyObject,
            udajeKlienta.denniPrijmy?.currencyFormattingWithSymbol(currencySymbol: "Kč") as AnyObject,
            udajeKlienta.denniVydaje?.currencyFormattingWithSymbol(currencySymbol: "Kč") as AnyObject,
            udajeKlienta.zajisteniPrijmuPoznamky as AnyObject,
            udajeKlienta.zajisteniPrijmuCastka?.currencyFormattingWithSymbol(currencySymbol: "Kč") as AnyObject,
            
        ]
        
        
        if udajeKlienta.maUver {
            
            data[0] = "Ano" as AnyObject
            
        } else {
            
            data[0] = "Ne" as AnyObject
        }
        
        var i = 0
        while i < data.count {
            
            let thing = data[i]
            
            if thing == nil {
                
                data[i] = String() as AnyObject
                
            }
            
            i += 1
        }
        
        let sectionView = UIView.loadFromNibNamed("ZajisteniPrijmu")!
        for subview in sectionView.subviews {
            
            if subview.isKindOfClass(UILabel) {
                
                if subview.tag > 0 {
                    
                    let label: UILabel = subview as! UILabel
                    let str = "\(data[label.tag - 1]!)"
                    label.text = str
                    
                }
            }
        }
        
        return sectionView
        
    }
    
    //MARK: - 4. section: bydleni section
    
    func bydleniSection() -> UIView {
        
        if udajeKlienta.chceResitBydleni == false {
            
            return UIView()
            
        }
        
        //prvni sekce
        var str = String()
        var separator = String()
        
        if udajeKlienta.zajisteniBydleniPoznamky != "" {
            
            str = udajeKlienta.zajisteniBydleniPoznamky
            separator = ". "
        }
        
        if udajeKlienta.spokojenostSBydlenimPoznamky != "" {
            
            str = str + separator + udajeKlienta.spokojenostSBydlenimPoznamky
            
        }
        
        var spokojenostSBydlenim = String()
        
        if udajeKlienta.spokojenostSBydlenim == "Ano" {
            
            spokojenostSBydlenim = "Ano"
            
        } else {
            
            spokojenostSBydlenim = "Mám výhrady"
            
            if udajeKlienta.spokojenostSBydlenimPoznamky != "" {
                
                spokojenostSBydlenim = spokojenostSBydlenim + ". " + udajeKlienta.spokojenostSBydlenimPoznamky
            }
        }
        
        var data: [AnyObject?] = [
            
            udajeKlienta.bytCiDum as AnyObject,
            udajeKlienta.vlastniCiNajemnni as AnyObject,
            spokojenostSBydlenim as AnyObject,
            udajeKlienta.planujeVetsi as AnyObject,
            udajeKlienta.zajisteniBydleniCastka?.currencyFormattingWithSymbol(currencySymbol: "Kč") as AnyObject,
            str as AnyObject
            
            ]
        
        var i = 0
        while i < data.count {
            
            let thing = data[i]
            
            if thing == nil {
                
                data[i] = String() as AnyObject
                
            }
            
            i += 1
        }
        
        updateDataBydleni()
        
        let sectionView = UIView.loadFromNibNamed("Bydleni")!
        for subview in sectionView.subviews {
            
            if subview.isKindOfClass(UILabel) {
                
                if subview.tag > 0 {
                    
                    let label: UILabel = subview as! UILabel
                    let str = "\(data[label.tag - 1]!)"
                    label.text = str
                    
                }
            }
            
            if udajeKlienta.chceGrafBydleni {
                
                if subview.isKindOfClass(UIView) && subview.tag == 1000 {
                    
                    //tableview setup
                    var tableViewHeight = CGFloat(20 + (grafArray1.count*14))
                    let tableView = UITableView(frame: CGRectMake(397, 186, 357, tableViewHeight), style: .Plain)
                    tableView.tag = 1
                    tableView.separatorStyle = .None
                    tableView.delegate = self
                    tableView.dataSource = self
                    let headerCellNib = UINib(nibName: "GraphHeaderTableCell", bundle: nil)
                    let cellNib = UINib(nibName: "GraphTableCell", bundle: nil)
                    tableView.registerNib(headerCellNib, forCellReuseIdentifier: "headerCell")
                    tableView.registerNib(cellNib, forCellReuseIdentifier: "cell")
                    sectionView.addSubview(tableView)
                    
                    if grafArray2.count > 4 {
                        
                        tableViewHeight = tableViewHeight - 25
                        
                    }
                    
                    sectionView.frame = CGRectMake(sectionView.frame.origin.x, sectionView.frame.origin.y, sectionView.frame.width, sectionView.frame.height + tableViewHeight)
    
                    let graphView = UIView.loadFromNibNamed("GraphBackground")!
                    let gradientLayer = CAGradientLayer()
                    let color1 = UIColor(red: 15/255, green: 63/255, blue: 10/255, alpha: 1).CGColor
                    let color2 = UIColor(red: 8/255, green: 161/255, blue: 2/255, alpha: 1).CGColor
                    gradientLayer.colors = [color1, color2]
                    gradientLayer.locations = [0.0, 1]
                    gradientLayer.frame = graphView.bounds
                    graphView.layer.insertSublayer(gradientLayer, atIndex: 0)
                    
                    for info in graphView.subviews {
                        
                        if info.isKindOfClass(UILabel) {
                            
                            var labelText = String()
                            
                            if info.tag == 1 {
                                
                                labelText = numberFormatting(bydleniGrafArray1.last!)
                                print(labelText)
                                
                            } else if info.tag == 2 {
                                
                                labelText = numberFormatting(Int(Double(bydleniGrafArray1.last!)*(2/3)))
                                print(labelText)
                                
                            } else if info.tag == 3 {
                                
                                labelText = numberFormatting(Int(Double(bydleniGrafArray1.last!)*(1/3)))
                                print(labelText)
                                
                            } else if info.tag == 4 {
                                
                                let index: Double = round(Double(roky.count)*(1/3))
                                
                                labelText = "\(roky[Int(index)]) rok"
                                
                            } else if info.tag == 5 {
                                
                                let index: Double = round(Double(roky.count)*(2/3))
                                
                                labelText = "\(roky[Int(index)]) rok"
                                
                            } else if info.tag == 6 {
                                
                                labelText = roky.last!
                                
                            } else if info.tag == 9 {
                                
                                labelText = "Jistina"
                                
                            } else if info.tag == 10 {
                                
                                labelText = "Spoření"
                                
                            }
                            
                            let label = info as! UILabel
                            label.text = labelText
                            
                        } else if info.isKindOfClass(JBLineChartView) {
                            
                            let chartView = info as! JBLineChartView
                            chartView.delegate = self
                            chartView.dataSource = self
                            chartView.maximumValue = CGFloat(maxValue)
                            chartView.minimumValue = 0
                            chartView.frame = CGRectMake(34, 5, 315, 113)
                            chartView.reloadData()
                            chartView.setState(.Expanded, animated: false)
                            
                            
                        } else if info.isKindOfClass(UIView) {
                            
                            let view1 = info
                            
                            if view1.tag == 7 {
                                
                                view1.layer.cornerRadius = 2.5
                                view1.layer.backgroundColor = UIColor.greenColor().CGColor
                                
                            } else if view1.tag == 8 {
                                
                                view1.layer.cornerRadius = 2.5
                                view1.layer.backgroundColor = UIColor.blueColor().CGColor
                            }
                            
                        }
                    }
                    
                    let view1 = subview
                    view1.addSubview(graphView)
                    
                }
            }
            
        }
        
        return sectionView
        
    }
    
    
    func updateDataBydleni() {
        
        // 1. roky
        // 2. pole hypoteky
        // 3. pole sporeni
        
        var placeholderArr1 = [String]()
        
        //1. pole
        
        let rok = udajeKlienta.grafBydleniMesicSplaceni/12
        let mesic = udajeKlienta.grafBydleniMesicSplaceni % 12
        
        for i in 1...rok {
            
            placeholderArr1.append("\(i).")
            
        }
        
        if udajeKlienta.grafBydleniMesicSplaceni % 12 != 0 {
            
            placeholderArr1.append("\(rok)./\(mesic)")
            
        }
        
        placeholderArr1.insert("0.", at: 0)
        roky = placeholderArr1
        bydleniRoky = roky
        
        //2. pole
        grafArray1 = udajeKlienta.grafBydleniPoleJistin
        bydleniGrafArray1 = grafArray1
        //3. pole
        grafArray2 = udajeKlienta.grafBydleniPoleSporeni
        bydleniGrafArray2 = grafArray2
        
        maxValue = CGFloat(grafArray1[0])
        
    }
    
    //MARK: - 5. section: deti section
    
    func detiRelevantNumber() -> Int {
        
        if udajeKlienta.pocetDeti != nil && udajeKlienta.pocetDeti != 0 {
            
            return udajeKlienta.pocetDeti!
            
        } else if udajeKlienta.pocetPlanovanychDeti != nil {
            
            return udajeKlienta.pocetPlanovanychDeti!
            
        } else {
            
            return Int()
        }
    }
    
    func detiSection(includeFooter: Bool) -> UIView {
        
        if udajeKlienta.chceResitDeti == false {
            
            return UIView()
        }
        
        let detiJmena = udajeKlienta.detiJmena
        let detiCilovaCastka = udajeKlienta.detiCilovaCastka
        let detiDoKdySporeni = udajeKlienta.detiDoKdySporeni
        let detiMesicneSporeni = udajeKlienta.detiMesicneSporeni
        
        let relevantNumber = detiRelevantNumber()
        
        let sectionView = UIView.loadFromNibNamed("Deti")!
        var sectionHeight = CGFloat()
        
        if relevantNumber == 0 {
            
            sectionHeight = 157
        
        } else {
            
            if relevantNumber > 2 {
                
                sectionHeight = 315
            
            } else {
                
                sectionHeight = 415
                
            }
            
        }
        
        sectionView.frame = CGRectMake(sectionView.frame.origin.x, sectionView.frame.origin.y, sectionView.frame.width, sectionHeight)
        
        //increase sectionView height
        var appendedHeight1 = CGFloat()
        
        if relevantNumber > 0 {
            
            appendedHeight1 = CGFloat(20 + (udajeKlienta.grafArrayUrok1.count*14))
                
            if relevantNumber > 1 && udajeKlienta.grafArrayUrok2.count > udajeKlienta.grafArrayUrok1.count {
                    
                appendedHeight1 = CGFloat(20 + (udajeKlienta.grafArrayUrok2.count*14))
                
            }
            
        }
        
        print(appendedHeight1)
        
        sectionView.frame = CGRectMake(sectionView.frame.origin.x, sectionView.frame.origin.y, sectionView.frame.width, sectionView.frame.height + appendedHeight1 + 10)
        
        for subview in sectionView.subviews {
            
            if subview.isKindOfClass(UIView) && subview.tag > 9 && subview.tag < 666 {
                
                let int = subview.tag/10

                if relevantNumber < int {
                    
                    subview.hidden = true
                
                }
            
            //vynalozena castka label
            } else if subview.tag == 666 {
                
                if includeFooter {
                    
                    for subview1 in subview.subviews {
                        
                        if subview1.tag == 1 || subview1.tag == 2 {
                            
                            let label: UILabel = subview1 as! UILabel
                            var str = String()
                            
                            if subview1.tag == 1 {
                                
                                if udajeKlienta.detiVynalozenaCastka != nil {
                                    
                                    str = udajeKlienta.detiVynalozenaCastka!.currencyFormattingWithSymbol("Kč")
                                    
                                } else {
                                    
                                    str = Int().currencyFormattingWithSymbol("Kč")
                                    
                                }
                                
                            } else if subview1.tag == 2 {
                                
                                str = udajeKlienta.detiPoznamky
                            }
                            
                            label.text = str
                            
                        }
                    }
                    
                    let view1 = subview
                    var footerYPosition = CGFloat()
                    if relevantNumber == 0 {
                        
                        footerYPosition = 47
                        
                    } else {
                        
                        footerYPosition = 305
                    }
                    
                    view1.frame = CGRectMake(view1.frame.origin.x, footerYPosition + appendedHeight1 + 10, view1.frame.width, view1.frame.height)
                    
                } else {
                    
                    subview.hidden = true
                    
                }
                
            }

        }
        
        //labels
        for subview in sectionView.subviews {
            
            if subview.isKindOfClass(UIView) && subview.tag > 9 && subview.tag <= (relevantNumber)*10 && subview.tag <= 20 {
                
                subview.hidden = false
                    
                for subview2 in subview.subviews {
                    
                    let tag = subview2.tag
                    
                    if tag > 0 {
                        
                        let int = subview.tag/10 - 1
                        let label: UILabel = subview2 as! UILabel
                        var str = String()
                        
                        if tag == 1 {
                            
                            str = detiJmena[int]
                            
                        } else if tag == 2 {
                            
                            str = detiCilovaCastka[int].currencyFormattingWithSymbol("Kč")
                            
                        } else if tag == 3 {
                        
                            str = "\(detiDoKdySporeni[int]) let"
                            
                        } else if tag == 4 {
                            
                            str = detiMesicneSporeni[int].currencyFormattingWithSymbol("Kč")
                            
                        }
                        
                        label.text = str
                        
                    }
                    
                }
                
                /*
                if relevantNumber > 2 && subview.tag > 20 {
                    
                    let view1 = subview
                    view1.frame = CGRectMake(view1.frame.origin.x, view1.frame.origin.y + appendedHeight1, view1.frame.width, view1.frame.height)
                    
                }*/
                
            } else if subview.isKindOfClass(UIView) && subview.tag > 999 && subview.tag <= 2000 && subview.tag <= relevantNumber*1000 {
                
                subview.hidden = false
                
                let index = subview.tag/1000
                updateData(index)
                
                //tady spoticam pozici tableview & vysku view & pozici ostatnich elementu
                
                //tableview frame position
                var xPosition = CGFloat()
                let yPosition = CGFloat(136 + 150)
                
                if index == 1 {
                    
                    xPosition = 22
                    
                } else {
                    
                    xPosition = 422
                }
                
                let tableViewHeight = CGFloat(20 + (grafArray1.count*14))
                
                //tableview setup
                let tableView = UITableView()
                tableView.tag = 2 + index
                tableView.frame = CGRectMake(xPosition, yPosition, 357, tableViewHeight)
                tableView.separatorStyle = .None
                tableView.delegate = self
                tableView.dataSource = self
                let headerCellNib = UINib(nibName: "GraphHeaderTableCell", bundle: nil)
                let cellNib = UINib(nibName: "GraphTableCell", bundle: nil)
                tableView.registerNib(headerCellNib, forCellReuseIdentifier: "headerCell")
                tableView.registerNib(cellNib, forCellReuseIdentifier: "cell")
                sectionView.addSubview(tableView)
                
                let graphView = UIView.loadFromNibNamed("GraphBackground")!
                
                let gradientLayer = CAGradientLayer()
                let color1 = UIColor(red: 15/255, green: 63/255, blue: 10/255, alpha: 1).CGColor
                let color2 = UIColor(red: 8/255, green: 161/255, blue: 2/255, alpha: 1).CGColor
                gradientLayer.colors = [color1, color2]
                gradientLayer.locations = [0.0, 1]
                gradientLayer.frame = graphView.bounds
                graphView.layer.insertSublayer(gradientLayer, atIndex: 0)
                
                for info in graphView.subviews {
                    
                    if info.isKindOfClass(UILabel) {
                        
                        var labelText = String()
                        
                        if info.tag == 1 {
                            
                            labelText = numberFormatting(grafArray1.last!)
                            
                        } else if info.tag == 2 {
                            
                            labelText = numberFormatting(Int(Double(grafArray1.last!)*(2/3)))
                            
                        } else if info.tag == 3 {
                            
                            labelText = numberFormatting(Int(Double(grafArray1.last!)*(1/3)))
                        
                        } else if info.tag == 4 {
                            
                            let value: Double = round(Double(udajeKlienta.grafDobaSporeni[index - 1]*1/3))
                        
                            labelText = "\(Int(value)). rok"
                            
                        } else if info.tag == 5 {
                            
                            let value: Double = round(Double(udajeKlienta.grafDobaSporeni[index - 1]*2/3))
                            
                            labelText = "\(Int(value)). rok"
                        
                        } else if info.tag == 6 {
                            
                            let value: Double = round(Double(udajeKlienta.grafDobaSporeni[index - 1]))
                            
                            labelText = "\(Int(value)). rok"
                        
                        } else if info.tag == 9 {
                            
                            labelText = "Celkem naspořeno"
                            
                        } else if info.tag == 10 {
                            
                            labelText = "Úrok"
                            
                        }
                        
                        let label = info as! UILabel
                        label.text = labelText
                    
                    } else if info.isKindOfClass(JBLineChartView) {
                        
                        let chartView = info as! JBLineChartView
                        chartView.delegate = self
                        chartView.dataSource = self
                        chartView.minimumValue = 0
                        chartView.maximumValue = maxValue*1.19
                        graphView.layoutIfNeeded()
                        chartView.reloadData()
                        chartView.setState(.Expanded, animated: true)
                        
                    } else if info.isKindOfClass(UIView) {
                        
                        let view1 = info
                        
                        if view1.tag == 7 {
                        
                            view1.layer.cornerRadius = 2.5
                            view1.layer.backgroundColor = UIColor.greenColor().CGColor
                        
                        } else if view1.tag == 8 {
                            
                            view1.layer.cornerRadius = 2.5
                            view1.layer.backgroundColor = UIColor.blueColor().CGColor
                        }
                    
                    }
                    
                }
                
                let view1 = subview
                
                /*
                if relevantNumber > 2 && index > 2 {
                    
                    view1.frame = CGRectMake(view1.frame.origin.x, view1.frame.origin.y + appendedHeight1, view1.frame.width, view1.frame.height)
                    
                }*/
                
                view1.addSubview(graphView)
                
            }
        }
        
        return sectionView
        
    }
    
    
    func detiSection2(includeSecondPart: Bool) -> UIView {
        
        if includeSecondPart == false {
            
            return UIView()
            
        }
        
        let detiJmena = udajeKlienta.detiJmena
        let detiCilovaCastka = udajeKlienta.detiCilovaCastka
        let detiDoKdySporeni = udajeKlienta.detiDoKdySporeni
        let detiMesicneSporeni = udajeKlienta.detiMesicneSporeni
        
        let relevantNumber = detiRelevantNumber()
        
        let sectionView = UIView.loadFromNibNamed("Deti")!
        let sectionHeight = CGFloat(415)
        
        sectionView.frame = CGRectMake(sectionView.frame.origin.x, sectionView.frame.origin.y, sectionView.frame.width, sectionHeight)
        
        //increase sectionView height
        var appendedHeight1 = CGFloat()
        
        appendedHeight1 = CGFloat(20 + (udajeKlienta.grafArrayUrok3.count*14))
        
        if udajeKlienta.grafArrayUrok4.count > udajeKlienta.grafArrayUrok3.count {
            
            appendedHeight1 = CGFloat(20 + (udajeKlienta.grafArrayUrok4.count*14))
            
        }
        
        sectionView.frame = CGRectMake(sectionView.frame.origin.x, sectionView.frame.origin.y, sectionView.frame.width, sectionView.frame.height + appendedHeight1 + 10)
        
        for subview in sectionView.subviews {
            
            if subview.isKindOfClass(UIView) && subview.tag > 9 && subview.tag < 666 {
                
                let int = subview.tag/10
                
                if relevantNumber < int {
                    
                    subview.hidden = true
                    
                }
                
                //vynalozena castka label
            } else if subview.tag == 666 {
                
                for subview1 in subview.subviews {
                    
                    if subview1.tag == 1 || subview1.tag == 2 {
                        
                        let label: UILabel = subview1 as! UILabel
                        var str = String()
                        
                        if subview1.tag == 1 {
                            
                            if udajeKlienta.detiVynalozenaCastka != nil {
                                
                                str = udajeKlienta.detiVynalozenaCastka!.currencyFormattingWithSymbol("Kč")
                                
                            } else {
                                
                                str = Int().currencyFormattingWithSymbol("Kč")
                                
                            }
                            
                        } else if subview1.tag == 2 {
                            
                            str = udajeKlienta.detiPoznamky
                        }
                        
                        label.text = str
                        
                    }
                }
                
                let view1 = subview
                var footerYPosition = CGFloat()
                if relevantNumber == 0 {
                    
                    footerYPosition = 47
                    
                } else {
                    
                    footerYPosition = 305
                }
                
                view1.frame = CGRectMake(view1.frame.origin.x, footerYPosition + appendedHeight1 + 10, view1.frame.width, view1.frame.height)
                
            }
            
        }
        
        //labels
        for subview in sectionView.subviews {
            
            if subview.isKindOfClass(UIView) && subview.tag > 9 && subview.tag <= 20 && subview.tag <= (relevantNumber - 2)*10 {
                
                subview.hidden = false
                
                for subview2 in subview.subviews {
                    
                    let tag = subview2.tag
                    
                    if tag > 0 {
                        
                        let int = subview.tag/10 - 1 + 2
                        let label: UILabel = subview2 as! UILabel
                        var str = String()
                        
                        if tag == 1 {
                            
                            str = detiJmena[int]
                            
                        } else if tag == 2 {
                            
                            str = detiCilovaCastka[int].currencyFormattingWithSymbol("Kč")
                            
                        } else if tag == 3 {
                            
                            str = "\(detiDoKdySporeni[int]) let"
                            
                        } else if tag == 4 {
                            
                            str = detiMesicneSporeni[int].currencyFormattingWithSymbol("Kč")
                            
                        }
                        
                        label.text = str
                        
                    }
                    
                }
                
                /*
                 if relevantNumber > 2 && subview.tag > 20 {
                 
                 let view1 = subview
                 view1.frame = CGRectMake(view1.frame.origin.x, view1.frame.origin.y + appendedHeight1, view1.frame.width, view1.frame.height)
                 
                 }*/
                
            } else if subview.isKindOfClass(UIView) && subview.tag > 999 && subview.tag <= 2000 && subview.tag <= (relevantNumber - 2)*1000  {
                
                subview.hidden = false
                
                let index = subview.tag/1000 + 2
                updateData(index)
                
                //tady spoticam pozici tableview & vysku view & pozici ostatnich elementu
                
                //tableview frame position
                var xPosition = CGFloat()
                let yPosition = CGFloat(136 + 150)
                
                if index == 3 {
                    
                    xPosition = 22
                    
                } else {
                    
                    xPosition = 422
                }
                
                let tableViewHeight = CGFloat(20 + (grafArray1.count*14))
                
                //tableview setup
                let tableView = UITableView()
                tableView.tag = 2 + index
                tableView.frame = CGRectMake(xPosition, yPosition, 357, tableViewHeight)
                tableView.separatorStyle = .None
                tableView.delegate = self
                tableView.dataSource = self
                let headerCellNib = UINib(nibName: "GraphHeaderTableCell", bundle: nil)
                let cellNib = UINib(nibName: "GraphTableCell", bundle: nil)
                tableView.registerNib(headerCellNib, forCellReuseIdentifier: "headerCell")
                tableView.registerNib(cellNib, forCellReuseIdentifier: "cell")
                sectionView.addSubview(tableView)
                
                let graphView = UIView.loadFromNibNamed("GraphBackground")!
                
                let gradientLayer = CAGradientLayer()
                let color1 = UIColor(red: 15/255, green: 63/255, blue: 10/255, alpha: 1).CGColor
                let color2 = UIColor(red: 8/255, green: 161/255, blue: 2/255, alpha: 1).CGColor
                gradientLayer.colors = [color1, color2]
                gradientLayer.locations = [0.0, 1]
                gradientLayer.frame = graphView.bounds
                graphView.layer.insertSublayer(gradientLayer, atIndex: 0)
                
                for info in graphView.subviews {
                    
                    if info.isKindOfClass(UILabel) {
                        
                        var labelText = String()
                        
                        if info.tag == 1 {
                            
                            labelText = numberFormatting(grafArray1.last!)
                            
                        } else if info.tag == 2 {
                            
                            labelText = numberFormatting(Int(Double(grafArray1.last!)*(2/3)))
                            
                        } else if info.tag == 3 {
                            
                            labelText = numberFormatting(Int(Double(grafArray1.last!)*(1/3)))
                            
                        } else if info.tag == 4 {
                            
                            let value: Double = round(Double(udajeKlienta.grafDobaSporeni[index - 1]*1/3))
                            
                            labelText = "\(Int(value)). rok"
                            
                        } else if info.tag == 5 {
                            
                            let value: Double = round(Double(udajeKlienta.grafDobaSporeni[index - 1]*2/3))
                            
                            labelText = "\(Int(value)). rok"
                            
                        } else if info.tag == 6 {
                            
                            let value: Double = round(Double(udajeKlienta.grafDobaSporeni[index - 1]))
                            
                            labelText = "\(Int(value)). rok"
                            
                        } else if info.tag == 9 {
                            
                            labelText = "Celkem naspořeno"
                            
                        } else if info.tag == 10 {
                            
                            labelText = "Úrok"
                            
                        }
                        
                        let label = info as! UILabel
                        label.text = labelText
                        
                    } else if info.isKindOfClass(JBLineChartView) {
                        
                        let chartView = info as! JBLineChartView
                        chartView.delegate = self
                        chartView.dataSource = self
                        chartView.minimumValue = 0
                        chartView.maximumValue = maxValue*1.19
                        graphView.layoutIfNeeded()
                        chartView.reloadData()
                        chartView.setState(.Expanded, animated: true)
                        
                    } else if info.isKindOfClass(UIView) {
                        
                        let view1 = info
                        
                        if view1.tag == 7 {
                            
                            view1.layer.cornerRadius = 2.5
                            view1.layer.backgroundColor = UIColor.greenColor().CGColor
                            
                        } else if view1.tag == 8 {
                            
                            view1.layer.cornerRadius = 2.5
                            view1.layer.backgroundColor = UIColor.blueColor().CGColor
                        }
                        
                    }
                    
                }
                
                let view1 = subview
                
                /*
                 if relevantNumber > 2 && index > 2 {
                 
                 view1.frame = CGRectMake(view1.frame.origin.x, view1.frame.origin.y + appendedHeight1, view1.frame.width, view1.frame.height)
                 
                 }*/
                
                view1.addSubview(graphView)
                
            }
        }
        
        return sectionView
        
    }

    
    //MARK: - jb chart view
    
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        
        return 2
        
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        
        return UInt(roky.count)
        
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        
        if lineIndex == 0 {
            
            return CGFloat(grafArray1[Int(horizontalIndex)])
            
        } else {
            
            return CGFloat(grafArray2[Int(horizontalIndex)])
        }
        
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        
        if lineIndex == 0 {
            
            return UIColor.green
        
        } else {
            
            return UIColor.blue
        }
        
    }
    
    func lineChartView(lineChartView: JBLineChartView!, widthForLineAtLineIndex lineIndex: UInt) -> CGFloat {
        
        return 1
        
    }
    
    //MARK: - vypocet popisnych labelu
    
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
    
    //MARK: - rovnice vypoctu
    
    func updateData(int: Int) {
        
        if int == 1 {
            
            grafArray2 = udajeKlienta.grafArrayUrok1
            
        } else if int == 2 {
            
            grafArray2 = udajeKlienta.grafArrayUrok2
            
        } else if int == 3 {
            
            grafArray2 = udajeKlienta.grafArrayUrok3
            
        } else {
            
            grafArray2 = udajeKlienta.grafArrayUrok4
            
        }

        
        var placeholderArr = [String]()
        var placeholderArr1 = [Int]()
        
        //for var i = 1; i <= udajeKlienta.grafDobaSporeni[int - 1]; i++ {
        for i in 1...udajeKlienta.grafDobaSporeni[int - 1] {
            
            let value = vypocetKrivkyGrafArray1Deti(rok: i, int: int - 1) + grafArray2[i - 1]
            
            placeholderArr1.append(value)
            placeholderArr.append("\(i).")
        }
        
        grafArray2.insert(0, at: 0)
        
        placeholderArr1.insert(0, at: 0)
        grafArray1 = placeholderArr1
        
        placeholderArr.insert("0.", at: 0)
        roky = placeholderArr
        
        maxValue = CGFloat(grafArray1[grafArray1.count - 1])
        
        if int == 1 {
            
            dite1Roky = roky
            dite1GrafArray1 = grafArray1
            dite1GrafArray2 = grafArray2
            
        } else if int == 2 {
            
            dite2Roky = roky
            dite2GrafArray1 = grafArray1
            dite2GrafArray2 = grafArray2
            
        } else if int == 3 {
            
            dite3Roky = roky
            dite3GrafArray1 = grafArray1
            dite3GrafArray2 = grafArray2

        } else {
            
            dite4Roky = roky
            dite4GrafArray1 = grafArray1
            dite4GrafArray2 = grafArray2

        }

    }
    
    func vypocetKrivkyGrafArray1Deti(rok: Int, int: Int) -> Int {
        
        var mesicniUlozka = udajeKlienta.grafCelkovaUlozka[int]/udajeKlienta.grafDobaSporeni[int]
        mesicniUlozka = mesicniUlozka/12
        
        let vysledek = mesicniUlozka*rok*12
        
        return vysledek
    }
    
    //MARK: - 6. section: duchod
    
    func duchodSection() -> UIView {
        
        if udajeKlienta.chceResitDuchod == false {
            
            return UIView()
        }
        
        var data: [AnyObject?] = [
            
            udajeKlienta.duchodVek as AnyObject,
            udajeKlienta.pripravaNaDuchod as AnyObject,
            udajeKlienta.jakDlouho as AnyObject,
            udajeKlienta.chtelBysteSePripravit as AnyObject,
            udajeKlienta.predstavovanaCastka?.currencyFormattingWithSymbol(currencySymbol: "Kč") as AnyObject,
            udajeKlienta.duchodVynalozenaCastka?.currencyFormattingWithSymbol(currencySymbol: "Kč") as AnyObject,
            udajeKlienta.duchodPoznamky as AnyObject
            
        ]
        
        var i = 0
        while i < data.count {
            
            let thing = data[i]
            
            if thing == nil {
                
                data[i] = String() as AnyObject
                
            }
            
            i += 1
        }
        
        updateDataDuchod()
        
        let sectionView = UIView.loadFromNibNamed("Duchod")!
        for subview in sectionView.subviews {
            
            if subview.isKindOfClass(UILabel) {
                
                if subview.tag > 0 {
                    
                    let label: UILabel = subview as! UILabel
                    let str = "\(data[label.tag - 1]!)"
                    label.text = str
                    
                }
                
            } else if udajeKlienta.chceGrafDuchodu {
                
                if subview.isKindOfClass(UIView) && subview.tag == 1000 {
                    
                    //tableview setup
                    var tableViewHeight = CGFloat(20 + (grafArray1.count*14))
                    let tableView = UITableView(frame: CGRectMake(400, 180, 357, tableViewHeight), style: .Plain)
                    tableView.tag = 2
                    tableView.separatorStyle = .None
                    tableView.delegate = self
                    tableView.dataSource = self
                    let headerCellNib = UINib(nibName: "GraphHeaderTableCell", bundle: nil)
                    let cellNib = UINib(nibName: "GraphTableCell", bundle: nil)
                    tableView.registerNib(headerCellNib, forCellReuseIdentifier: "headerCell")
                    tableView.registerNib(cellNib, forCellReuseIdentifier: "cell")
                    sectionView.addSubview(tableView)
                    
                    if grafArray2.count > 4 {
                        
                        tableViewHeight = tableViewHeight - 25
                        
                    }
                    
                    sectionView.frame = CGRectMake(sectionView.frame.origin.x, sectionView.frame.origin.y, sectionView.frame.width, sectionView.frame.height + tableViewHeight)
                    
                    //graph view setup
                    let graphView = UIView.loadFromNibNamed("GraphBackground")!
                    let gradientLayer = CAGradientLayer()
                    let color1 = UIColor(red: 15/255, green: 63/255, blue: 10/255, alpha: 1).CGColor
                    let color2 = UIColor(red: 8/255, green: 161/255, blue: 2/255, alpha: 1).CGColor
                    gradientLayer.colors = [color1, color2]
                    gradientLayer.locations = [0.0, 1]
                    gradientLayer.frame = graphView.bounds
                    graphView.layer.insertSublayer(gradientLayer, atIndex: 0)
                    
                    for info in graphView.subviews {
                        
                        if info.isKindOfClass(UILabel) {
                            
                            var labelText = String()
                            
                            if info.tag == 1 {
                                
                                labelText = numberFormatting(grafArray1.last!)
                                
                            } else if info.tag == 2 {
                                
                                labelText = numberFormatting(Int(Double(grafArray1.last!)*(2/3)))
                                
                            } else if info.tag == 3 {
                                
                                labelText = numberFormatting(Int(Double(grafArray1.last!)*(1/3)))
                                
                            } else if info.tag == 4 {
                                
                                let index: Double = round(Double(roky.count)*(1/3))
                                
                                labelText = "\(roky[Int(index)]) rok"
                                
                            } else if info.tag == 5 {
                                
                                let index: Double = round(Double(roky.count)*(2/3))
                                
                                labelText = "\(roky[Int(index)]) rok"
                                
                            } else if info.tag == 6 {
                                
                                labelText = roky.last!
                                
                            } else if info.tag == 9 {
                                
                                labelText = "Celkem naspořeno"
                                
                            } else if info.tag == 10 {
                                
                                labelText = "Úrok"
                                
                            }
                            
                            let label = info as! UILabel
                            label.text = labelText
                            
                        } else if info.isKindOfClass(JBLineChartView) {
                            
                            let chartView = info as! JBLineChartView
                            chartView.delegate = self
                            chartView.dataSource = self
                            chartView.maximumValue = CGFloat(maxValue)
                            chartView.minimumValue = 0
                            chartView.frame = CGRectMake(34, 5, 315, 113)
                            chartView.reloadData()
                            chartView.setState(.Expanded, animated: false)
                            
                        } else if info.isKindOfClass(UIView) {
                            
                            let view1 = info
                            
                            if view1.tag == 7 {
                                
                                view1.layer.cornerRadius = 2.5
                                view1.layer.backgroundColor = UIColor.greenColor().CGColor
                                
                            } else if view1.tag == 8 {
                                
                                view1.layer.cornerRadius = 2.5
                                view1.layer.backgroundColor = UIColor.blueColor().CGColor
                            }
                            
                        }
                    }
                    
                    let view1 = subview
                    view1.addSubview(graphView)
                    
                }
            }
            
            
        }
        
        return sectionView
    
    }
    
    //MARK: - tableView data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 1
            
        } else {
            
            if tableView.tag == 1 {
                
                return bydleniRoky.count
                
            } else if tableView.tag == 2 {
                
                return duchodRoky.count
                
            } else if tableView.tag == 3 {
                
                return dite1Roky.count
                
            } else if tableView.tag == 4 {
                
                return dite2Roky.count
                
            } else if tableView.tag == 5 {
                
                return dite3Roky.count
                
            } else {
                
                return dite4Roky.count
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! GraphHeaderTableCell
            
            var label2 = String()
            var label3 = String()
            
            if tableView.tag == 1 {
                
                label2 = "Jistina"
                label3 = "Naspořeno"
                
            } else {
                
                label2 = "Naspořeno"
                label3 = "Úrok"
                
            }
            
            cell.secondLabel.text = label2
            cell.thirdLabel.text = label3
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GraphTableCell
            
            if indexPath.row % 2 == 0 {
                
                cell.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
                
            } else {
                
                cell.backgroundColor = UIColor.white
            }
            
            var string1 = String()
            var string2 = String()
            var string3 = String()
            
            if tableView.tag == 1 {
                
                string1 = bydleniRoky[indexPath.row]
                string2 = bydleniGrafArray1[indexPath.row].currencyFormattingWithSymbol(currencySymbol: "Kč")
                string3 = bydleniGrafArray2[indexPath.row].currencyFormattingWithSymbol(currencySymbol: "Kč")
                
            } else if tableView.tag == 2 {
                
                string1 = duchodRoky[indexPath.row]
                string2 = duchodGrafArray1[indexPath.row].currencyFormattingWithSymbol(currencySymbol: "Kč")
                string3 = duchodGrafArray2[indexPath.row].currencyFormattingWithSymbol(currencySymbol: "Kč")
                
            } else if tableView.tag == 3 {
                
                string1 = dite1Roky[indexPath.row]
                string2 = dite1GrafArray1[indexPath.row].currencyFormattingWithSymbol(currencySymbol: "Kč")
                string3 = dite1GrafArray2[indexPath.row].currencyFormattingWithSymbol(currencySymbol: "Kč")
                
            } else if tableView.tag == 4 {
                
                string1 = dite2Roky[indexPath.row]
                string2 = dite2GrafArray1[indexPath.row].currencyFormattingWithSymbol(currencySymbol: "Kč")
                string3 = dite2GrafArray2[indexPath.row].currencyFormattingWithSymbol(currencySymbol: "Kč")
                
            } else if tableView.tag == 5 {
                
                string1 = dite3Roky[indexPath.row]
                string2 = dite3GrafArray1[indexPath.row].currencyFormattingWithSymbol(currencySymbol: "Kč")
                string3 = dite3GrafArray2[indexPath.row].currencyFormattingWithSymbol(currencySymbol: "Kč")
                
            } else {
                
                string1 = dite4Roky[indexPath.row]
                string2 = dite4GrafArray1[indexPath.row].currencyFormattingWithSymbol(currencySymbol: "Kč")
                string3 = dite4GrafArray2[indexPath.row].currencyFormattingWithSymbol(currencySymbol: "Kč")
                
            }
            
            cell.firstLabel.text = string1
            cell.secondLabel.text = string2
            cell.thirdLabel.text = string3
            
            return cell
            
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 20
            
        } else {
            
            return 14
        }
    }
    
    func updateDataDuchod() {
        
        print("updateDataDuchod")
        
        grafArray2 = udajeKlienta.grafDuchodUroky
        
        var placeholderArr = [String]()
        var placeholderArr1 = [Int]()
        
        print(udajeKlienta.grafDuchodDobaSporeni)
        
        //for var i = 1; i <= udajeKlienta.grafDuchodDobaSporeni; i += 1 {
        for i in 1...udajeKlienta.grafDuchodDobaSporeni {
            
            let value = vypocetKrivkyGrafArray1Duchod(rok: i) + grafArray2[i - 1]
            
            placeholderArr1.append(value)
            placeholderArr.append("\(i).")
        }
        
        grafArray2.insert(0, at: 0)
        duchodGrafArray2 = grafArray2
        
        placeholderArr.insert("0.", at: 0)
        roky = placeholderArr
        duchodRoky = roky
        
        placeholderArr1.insert(0, at: 0)
        grafArray1 = placeholderArr1
        duchodGrafArray1 = grafArray1
        
        maxValue = CGFloat(grafArray1[grafArray1.count - 1])
        
    }
    
    func vypocetKrivkyGrafArray1Duchod(rok: Int) -> Int {
    
        var mesicniUlozka = udajeKlienta.grafDuchodCelkovaUlozka/udajeKlienta.grafDuchodDobaSporeni
        mesicniUlozka = mesicniUlozka/12
    
        let vysledek = mesicniUlozka*rok*12
    
        return vysledek
    }
    
    //MARK: - 7. section: dane
    
    func daneSection() -> UIView {
        
        if udajeKlienta.chceteResitDane == false {
            
            return UIView()
            
        }
        
        var values = [udajeKlienta.danePoznamky]
        
        var str = String()
        
        if udajeKlienta.chceteResitDane {
            
            str = "Ano"
            
        } else {
            
            str = "Ne"
        }
        
        values.insert(str, at: 0)
        
        let sectionView = UIView.loadFromNibNamed("Dane")!
        for subview in sectionView.subviews {
            
            if subview.isKindOfClass(UILabel) && subview.tag > 0 {
                
                let label = subview as! UILabel
                let str = values[subview.tag - 1]
                label.text = str
            }
            
            
        }
        
        return sectionView
    }
    
    //MARK: - 8. section: ostatniPozadavky
    
    func ostatniPozadavkySection() -> UIView {
        
        let value = udajeKlienta.ostatniPozadavky
        
        let sectionView = UIView.loadFromNibNamed("OstatniPozadavky")!
        for subview in sectionView.subviews {
            
            if subview.isKindOfClass(UILabel) && subview.tag == 1 {
                
                let label = subview as! UILabel
                label.text = value
                
            }
        }
        
        return sectionView
        
    }
    
    //MARK: - 9. section: klient nechce resit
    
    func klientNechceResit() -> UIView {
        
        var result: [String] = []
        
        var values =
        [
            udajeKlienta.chceResitZajisteniPrijmu,
            udajeKlienta.chceResitBydleni,
            udajeKlienta.chceResitDeti,
            udajeKlienta.chceResitDuchod,
            udajeKlienta.chceteResitDane,
            
        ]
        
        if udajeKlienta.ostatniPozadavky == "" {
            
            values.append(false)
            
        } else {
            
            values.append(true)
        }
        
        let keys =
        [
            "Zajištění příjmů",
            "Bydlení",
            "Děti",
            "Důchod",
            "Daňové úlevy",
            "Nemá další požadavky"
        ]
        
        for i in 0 ..< values.count {
            
            if values[i] == false {
                
                result.append(keys[i])
            }
        }
        
        if result.count != 6 {
            
            let i = 0
            while i == 0 {
                
                result.append("")
                
                if result.count == 6 {
                    
                    break
                    
                }
            }
        }
        
        let sectionView = UIView.loadFromNibNamed(nibNamed: "KlientNechceResit")!
        for subview in sectionView.subviews {
            
            if subview.isKindOfClass(UILabel) && subview.tag > 0 {
                
                let label = subview as! UILabel
                label.text = result[subview.tag - 1]
            }
            
        }
        
        return sectionView
    }
    
    //MARK: - 10. section: shrnuti section
    
    func shrnutiSection() -> UIView {
        
        var value1 = Int()
        var value2 = Int()
        var value3 = Int()
        var value4 = Int()
        
        var value5 = Int()
        var value6 = Int()
        
        if udajeKlienta.zajisteniPrijmuCastka == nil {
            
            value1 = 0
            
        } else {
            
            value1 = udajeKlienta.zajisteniPrijmuCastka!
    
        }
        
        if udajeKlienta.zajisteniBydleniCastka == nil {
            
            value2 = 0
            
        } else {
            
            value2 = udajeKlienta.zajisteniBydleniCastka!
            
        }
        
        if udajeKlienta.detiVynalozenaCastka == nil {
            
            value3 = 0
            
        } else {
            
            value3 = udajeKlienta.detiVynalozenaCastka!
            
        }
        
        if udajeKlienta.duchodVynalozenaCastka == nil {
            
            value4 = 0
            
        } else {
            
            value4 = udajeKlienta.duchodVynalozenaCastka!
        }
        
        if udajeKlienta.prijmy == nil {
            
            value5 = 0
        
        } else {
            
            value5 = udajeKlienta.prijmy!
            
        }
        
        if udajeKlienta.vydaje == nil {
            
            value6 = 0
            
        } else {
            
            value6 = udajeKlienta.vydaje!
        }
        
        let data = [
            
            value1.currencyFormattingWithSymbol(currencySymbol: "Kč"),
            value2.currencyFormattingWithSymbol(currencySymbol: "Kč"),
            value3.currencyFormattingWithSymbol(currencySymbol: "Kč"),
            value4.currencyFormattingWithSymbol(currencySymbol: "Kč"),
            (value1 + value2 + value3 + value4).currencyFormattingWithSymbol(currencySymbol: "Kč"),
            ((value5 - value6)/2).currencyFormattingWithSymbol(currencySymbol: "Kč"),
            udajeKlienta.realnaCastkaNaProjekt!.currencyFormattingWithSymbol(currencySymbol: "Kč"),
            value5.currencyFormattingWithSymbol(currencySymbol: "Kč"),
            value6.currencyFormattingWithSymbol(currencySymbol: "Kč")
            
        ]
        
        let sectionView = UIView.loadFromNibNamed(nibNamed: "Shrnuti")!
        for subview in sectionView.subviews {
            
            if subview.isKind(of: UILabel.self) && subview.tag > 0 {
                
                let label = subview as! UILabel
                label.text = data[subview.tag - 1]
            }
            
        }
        
        return sectionView
    }
    
    //MARK: - pdf creation
    
    func showPDF(fileName: String) {
        
        let arraysPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let path = arraysPaths[0]
        let pdfFileName = path + "/" + fileName + ".pdf"
        
        filePath = pdfFileName
        
        let url = NSURL.fileURL(withPath: pdfFileName)
        let request = NSURLRequest(URL: url)
        webView.scalesPageToFit = true
        webView.loadRequest(request)
        
    }
    
    func createPdfFromView(views: [UIView], saveToDocumentsWithFileName fileName: String) {
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, views[0].bounds, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return }
        
        for page in views {
            
            UIGraphicsBeginPDFPage()
            page.layer.render(in: pdfContext)
            
        }
        
        UIGraphicsEndPDFContext()
        
        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let documentsFileName = documentDirectories + "/" + fileName + ".pdf"
            debugPrint(documentsFileName)
            pdfData.write(toFile: documentsFileName, atomically: true)
        }
    }
    
    //MARK: - share graph via email
    
    @objc func sendEmail() {
        
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
        mailComposerVC.setSubject("Finanční naplánování projektu")
        //mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        let pdfData = NSData(contentsOfFile: filePath)
        
        mailComposerVC.addAttachmentData(pdfData! as Data, mimeType: "application/pdf", fileName: "pdf1")
        
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

extension UIView {
    
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    func copyView() -> UIView {
        
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self))! as! UIView
        
    }
}



