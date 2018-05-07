//
//  PPSTableViewController.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 13.05.16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import UIKit

class PPSTableViewController: UITableViewController, UITextFieldDelegate {
    
    //MARK: - global variables to pass
    //uverova cast
    var uverPocetRokuGlobal = Int()
    var uverPujcenyObnosGlobal = Int()
    var uverCelkemUrokGlobal = Int()
    var uverMesicniUrokGlobal = Float()
    var uverMesicniPlatbaVcetneUrokuGlobal = Int()
    
    var isSegueFromKartaKlienta = Bool()
    var num = Int()
    var poleJistin:[Int] = []
    var sections = [3, 3, 1]
    
    //sporici cast
    var sporeniMesicniUrokGlobal = Float()
    var sporeniDobaGlobal = Int()
    var sporeniPoleSporeni:[Int] = []
    
    //holding variables
    var sporeniPoleSegue:[Int] = []
    var jistinaPoleSegue:[Int] = []
    
    //segue variables
    var sporeniSegue:[Int] = []
    var jistinaSegue:[Int] = []
    var mesicSplaceniSegue = Int()
    var hlaskaSplaceni = String()
    
    //MARK: - local variables
    
    var textField1Value = "3 000 000 Kč"
    var textField2Value = "25 let"
    var textField3Value = "1,8 %"
    var textField4Value = "1 500 Kč"
    var textField5Value = "20 let"
    var textField6Value = "5 %"
    
    var slider1Value: Float = 30
    var slider2Value: Float = 25
    var slider3Value: Float = 18
    var slider4Value: Float = 15
    var slider5Value: Float = 20
    var slider6Value: Float = 50
    
    var stepper1Value: Double = 3000000
    var stepper2Value: Double = 25
    var stepper3Value: Double = 18
    var stepper4Value: Double = 1500
    var stepper5Value: Double = 20
    var stepper6Value: Double = 50
    
    var resultLabel = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "PPS"
        
        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Graf", style: .plain, target: self, action: #selector(PPSTableViewController.segueToGraph))
        
        if isSegueFromKartaKlienta {
            num = 1
            sections.insert(1, at: 0)
        } else {
            num = 0
        }
        
        let value1 = udajeKlienta.grafBydleniUverCastka
        
        if value1 != Int() {
            
            textField1Value = value1.currencyFormattingWithSymbol(currencySymbol: "Kč")
            slider1Value = Float(value1)/100000
            stepper1Value = Double(value1)
            
        }
        
        let value2 = udajeKlienta.grafBydleniUverDoba
        
        if value2 != Int() {
            
            textField2Value = value2.currencyFormattingWithSymbol(currencySymbol: "let")
            slider2Value = Float(value2)
            stepper2Value = Double(value2)
            
        }
        
        let value3 = udajeKlienta.grafBydleniUverUrok
        
        if value3 != Float() {
            
            textField3Value = value3.currencyFormattingWithSymbol(currencySymbol: "%")
            slider3Value = Float(value3)*10
            stepper3Value = Double(value3)*10
            
        }
        
        let value4 = udajeKlienta.grafBydleniSporeniMesicniPlatba
        
        if value4 != Int() {
            
            textField4Value = value4.currencyFormattingWithSymbol(currencySymbol: "Kč")
            slider4Value = Float(value4)/100
            stepper4Value = Double(value4)
            
        }
        
        let value5 = udajeKlienta.grafBydleniSporeniDoba
        
        if value5 != Int() {
            
            textField5Value = value5.currencyFormattingWithSymbol(currencySymbol: "let")
            slider5Value = Float(value5)
            stepper5Value = Double(value5)
            
        }
        
        let value6 = udajeKlienta.grafBydleniSporeniUrok
        
        if value6 != Float() {
            
            textField6Value = value6.currencyFormattingWithSymbol(currencySymbol: "%")
            slider6Value = Float(value6)*10
            stepper6Value = Double(value6)*10
            
        }

        pocitani()


    }
    
    //MARK: - rovnice vypoctu
    
    func pocitani() {
        
        //preformatovat pujcenou castku
        let castkaBezMezerCelkem = textField1Value.condenseWhitespace()
        //formatovani urokove sazby
        //MARK: - to be resolved
        let urokCarka = textField3Value.stringByReplacingOccurrencesOfString(",", withString: ".", options: [], range: nil)
        
        let castkaCelkem = Float((castkaBezMezerCelkem as NSString).floatValue) //jistina
        let doba = Float((textField2Value as NSString).floatValue)*12 //celkem doba prevedena na mesice
        let mesicniUrok = Float((urokCarka as NSString).floatValue)/12*0.01 //mesicni urok. mesicniUrok = rocniUrok/12
        
        //tady spocitam: mesicni platbu vc. uroku, celkovy urok, celkovou zaplacenou castku vc. uroku
        //rovnice
        let vDole = 1+mesicniUrok
        let v = 1/vDole
        let aNahore = castkaCelkem*mesicniUrok
        let aDole = 1-pow(v, doba)
        let a = aNahore/aDole
        
        //vysledky
        let zaplatit = a*doba //castka, kteoru klient zaplati (jistina + urok)
        let celkemUrok = zaplatit - castkaCelkem
        let prumernaMesicniPlatba = a
        
        //Prevedeni z floatu na Int
        let prumernaMesicniPlatbaInt:Int = Int(round(prumernaMesicniPlatba))
        let celkemUrokInt:Int = Int(round(celkemUrok))
        
        //defaults data
        udajeKlienta.grafBydleniUverCastka = Int(castkaCelkem)
        udajeKlienta.grafBydleniUverDoba = Int(doba)/12
        udajeKlienta.grafBydleniUverUrok = Float((urokCarka as NSString).floatValue)
        
        //segue variables
        uverPocetRokuGlobal = Int(doba)/12
        uverPujcenyObnosGlobal = Int(castkaCelkem)
        uverCelkemUrokGlobal = celkemUrokInt
        uverMesicniUrokGlobal = mesicniUrok
        uverMesicniPlatbaVcetneUrokuGlobal = prumernaMesicniPlatbaInt
        
        //tady vytvorim pole jistin, tzn. kolik zbyva zaplatit po kazdem mesici z dluzne castky (neni v tom zapocitany urok)
        
        var jistina:Float = Float(uverPujcenyObnosGlobal)
        let mesicniPlatba:Float = Float(uverMesicniPlatbaVcetneUrokuGlobal)
        let dobaMesice = uverPocetRokuGlobal*12
        
        
        var snizeniJistiny = Float() //variable ktery urcuje o kolik se realne mesicne splati dluh
        
        var i = 1
        while i <= dobaMesice {
            
            snizeniJistiny = Float(mesicniPlatba) - Float(Float(jistina)*Float(mesicniUrok))
            jistina = Float(jistina) - snizeniJistiny
            
            if jistina < 0 {
                
                jistina = 0
            }
            
            poleJistin.append(Int(round(jistina)))
            i += 1
        }
        
        //tady vypocitam pole se sporenim po kazdem mesici (ulozka + urok)
        
        let dobaSporeni = Int(((textField5Value.chopSuffix(count: 3).condenseWhitespace()) as NSString).intValue)*12 //doba na mesice
        let mesicniUlozkaSporeni = Float(((textField4Value.chopSuffix(count: 2).condenseWhitespace()) as NSString).floatValue) //mesicni castka co si klient spori
        let mesicniUrokSporeni = Float(0.01*Float(((textField6Value.chopSuffix(count: 1).condenseWhitespace()) as NSString).floatValue))/12 //mesicniurok
        
        var sporeniCelkemNasporenaCastka = Float() //castka: ulozky + jejich zhodnoceni urokem
        
        //defaults data
        udajeKlienta.grafBydleniSporeniMesicniPlatba = Int(mesicniUlozkaSporeni)
        udajeKlienta.grafBydleniSporeniDoba = dobaSporeni/12
        udajeKlienta.grafBydleniSporeniUrok = mesicniUrokSporeni*12/0.01
        
        var ii = 1
        while ii <= dobaSporeni {
            
            sporeniCelkemNasporenaCastka = sporeniCelkemNasporenaCastka + mesicniUlozkaSporeni + sporeniCelkemNasporenaCastka*mesicniUrokSporeni
            
            sporeniPoleSporeni.append(Int(round(sporeniCelkemNasporenaCastka)))
            ii += 1
        }
        
        sporeniCelkemNasporenaCastka = 0
        
        
        //tady vyrovnam pocet elementu v array - 'sporeniPoleSporeni' a 'poleJistin'
        if poleJistin.count > sporeniPoleSporeni.count {
            
            let rozdil = poleJistin.count - sporeniPoleSporeni.count
            var iii = 1
            while iii <= rozdil {
                sporeniPoleSporeni.append(sporeniPoleSporeni[sporeniPoleSporeni.count - 1])
                iii += 1
            }
            
        } else if poleJistin.count < sporeniPoleSporeni.count {
            
            let rozdil = sporeniPoleSporeni.count - poleJistin.count
            
            var iii = 1
            while iii <= rozdil {
                sporeniPoleSporeni.removeLast()
                iii += 1
            }
        }
        
        
        //tady zjistim v kolikatym mesici se splati uver
        var iii = 0
        while iii < poleJistin.count {
            
            if sporeniPoleSporeni[a] >= poleJistin[a] {
                mesicSplaceniSegue = a
                break
            }
            iii += 1
        }
        
        if mesicSplaceniSegue % 12 == 0 {
            
            var iiii = 11
            while iiii < mesicSplaceniSegue {
                sporeniPoleSegue.append(sporeniPoleSporeni[i])
                jistinaPoleSegue.append(poleJistin[i])
                iiii += 12
            }
            
            resultLabel = "Úvěr bude splacen po uplynutí \(mesicSplaceniSegue/12) let. Více informací naleznet v grafu."
            
            hlaskaSplaceni = "Úvěr bude splacen po uplynutí \(mesicSplaceniSegue/12) let."
            
        } else {
            
            var iiii = 11
            while iiii < mesicSplaceniSegue {
                
                jistinaPoleSegue.append(poleJistin[i])
                sporeniPoleSegue.append(sporeniPoleSporeni[i])
                
                if (i + 12) > mesicSplaceniSegue {
                    
                    jistinaPoleSegue.append(poleJistin[mesicSplaceniSegue])
                    sporeniPoleSegue.append(sporeniPoleSporeni[mesicSplaceniSegue])
                    break
                }
                iiii += 12
            }
            
            resultLabel = "Úvěr bude splacen po uplynutí \(mesicSplaceniSegue/12) let a \(mesicSplaceniSegue % 12) měsíců. Více informací naleznete v grafu."
            hlaskaSplaceni = "Úvěr bude splacen po uplynutí \(mesicSplaceniSegue/12) let a \(mesicSplaceniSegue % 12) měsíců."
        }
        
        
        sporeniSegue = sporeniPoleSegue
        jistinaSegue = jistinaPoleSegue
        
        sporeniSegue.insert(0, at: 0)
        jistinaSegue.insert(Int(castkaCelkem), at: 0)
        
        //defaults data
        udajeKlienta.grafBydleniPoleSporeni = sporeniSegue
        udajeKlienta.grafBydleniPoleJistin = jistinaSegue
        udajeKlienta.grafBydleniMesicSplaceni = mesicSplaceniSegue
        udajeKlienta.grafBydleniHlaskaSplaceni = hlaskaSplaceni
        
        poleJistin = []
        sporeniPoleSporeni = []
        sporeniPoleSegue = []
        jistinaPoleSegue = []
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3 + num
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return sections[section]
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 + num {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "uverCastka") as! PPSTableCell
                
                cell.uverCastkaTextField.delegate = self
                cell.uverCastkaTextField.tag = 1
                cell.uverCastkaTextField.text = textField1Value
                
                cell.uverCastkaSlider.addTarget(self, action: #selector(PPSTableViewController.uverCastkaSliderAction(_:)), for: .ValueChanged)
                cell.uverCastkaSlider.value = slider1Value
                
                cell.uverCastkaStepper.addTarget(self, action: #selector(PPSTableViewController.uverCastkaStepperAction(_:)), forControlEvents: .ValueChanged)
                cell.uverCastkaStepper.value = stepper1Value
                
                return cell

            } else if indexPath.row == 1 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "uverDoba") as! PPSTableCell
                
                cell.uverDobaTextField.delegate = self
                cell.uverDobaTextField.tag = 2
                cell.uverDobaTextField.text = textField2Value
                
                cell.uverDobaSlider.addTarget(self, action: #selector(PPSTableViewController.uverDobaSliderAction(_:)), for: .ValueChanged)
                cell.uverDobaSlider.value = slider2Value
                
                cell.uverDobaStepper.addTarget(self, action: #selector(PPSTableViewController.uverDobaStepperAction(_:)), for: .ValueChanged)
                cell.uverDobaStepper.value = stepper2Value
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "uverUrok") as! PPSTableCell
                
                cell.uverUrokTextField.delegate = self
                cell.uverUrokTextField.tag = 3
                cell.uverUrokTextField.text = textField3Value
                
                cell.uverUrokSlider.addTarget(self, action: #selector(PPSTableViewController.uverUrokSliderAction(_:)), forControlEvents: .ValueChanged)
                cell.uverUrokSlider.value = slider3Value
                
                cell.uverUrokStepper.addTarget(self, action: #selector(PPSTableViewController.uverUrokStepperAction(_:)), forControlEvents: .ValueChanged)
                cell.uverUrokStepper.value = stepper3Value
                
                return cell
                
            }
            
        } else if indexPath.section == 1 + num {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "sporeniMesicniPlatba") as! PPSTableCell
                
                cell.sporeniMesicniPlatbaTextField.delegate = self
                cell.sporeniMesicniPlatbaTextField.tag = 4
                cell.sporeniMesicniPlatbaTextField.text = textField4Value
                
                cell.sporeniMesicniPlatbaSlider.addTarget(self, action: #selector(PPSTableViewController.sporeniMesicniPlatbaSliderAction(_:)), forControlEvents: .ValueChanged)
                cell.sporeniMesicniPlatbaSlider.value = slider4Value
                
                cell.sporeniMesicniPlatbaStepper.addTarget(self, action: #selector(PPSTableViewController.sporeniMesicniPlatbaStepperAction(_:)), forControlEvents: .ValueChanged)
                cell.sporeniMesicniPlatbaStepper.value = stepper4Value
                
                return cell
                
            } else if indexPath.row == 1 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "sporeniDoba") as! PPSTableCell
                
                cell.sporeniDobaTextField.delegate = self
                cell.sporeniDobaTextField.tag = 5
                cell.sporeniDobaTextField.text = textField5Value
                
                cell.sporeniDobaSlider.addTarget(self, action: #selector(PPSTableViewController.sporeniDobaSliderAction(_:)), for: .ValueChanged)
                cell.sporeniDobaSlider.value = slider5Value
                
                cell.sporeniDobaStepper.addTarget(self, action: #selector(PPSTableViewController.sporeniDobaStepperAction(_:)), for: .ValueChanged)
                cell.sporeniDobaStepper.value = stepper5Value
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "sporeniUrok") as! PPSTableCell
                
                cell.sporeniUrokTextField.delegate = self
                cell.sporeniUrokTextField.tag = 6
                cell.sporeniUrokTextField.text = textField6Value
                
                cell.sporeniUrokSlider.addTarget(self, action: #selector(PPSTableViewController.sporeniUrokSliderAction(_:) as (PPSTableViewController) -> (UISlider) -> ()), for: .ValueChanged)
                cell.sporeniUrokSlider.value = slider6Value
                
                cell.sporeniUrokStepper.addTarget(self, action: #selector(PPSTableViewController.sporeniUrokStepperAction(_:)), for: .ValueChanged)
                cell.sporeniUrokStepper.value = stepper6Value
                
                return cell
            }
            
        } else if indexPath.section == 2 + num {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultLabel") as! PPSTableCell
            
            cell.resultLabel.text = resultLabel
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "pridatGraf") as! PPSTableCell
            
            cell.grafSwitch.addTarget(self, action: #selector(PPSTableViewController.grafSwitchAction(_:)), for: .ValueChanged)
            
            if udajeKlienta.chceGrafBydleni {
                
                cell.grafSwitch.isOn = true
                
            } else {
                
                cell.grafSwitch.isOn = false
                
            }
            
            return cell
            
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 + num || indexPath.section == 1 + num {
            
            return 75
            
        } else if indexPath.section == 2 + num {
            
            return 66
        
        } else {
            
            return 44
        }
        
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 + num {
            
            return "Úvěrová část"
            
        } else if section == 1 + num {
            
            return "Spořící část"
            
        } else if section == 2 + num {
            
            return "Výsledek"
            
        }
        
        return nil
        
    }
    
    //MARK: - uiswitch
    
    func grafSwitchAction(sender: UISwitch) {
        
        if sender.isOn == true {
            
            udajeKlienta.chceGrafBydleni = true
            
        } else {
            
            udajeKlienta.chceGrafBydleni = false
            
        }
        
        tableView.reloadData()
    }
    
    //MARK: slider ibactions
    
    func uverCastkaSliderAction(sender: UISlider) {
        
        let a = Int(sender.value)*100000
        
        textField1Value = a.currencyFormattingWithSymbol(currencySymbol: "Kč")
        stepper1Value = Double(a)
        slider1Value = sender.value
        
        pocitani()
        
    }
    
    func uverDobaSliderAction(sender: UISlider) {
        
        let b = Int(sender.value)
        
        textField2Value = b.currencyFormattingWithSymbol(currencySymbol: "let")
        stepper2Value = Double(b)
        slider2Value = sender.value
        
        pocitani()
        
    }
    
    func uverUrokSliderAction(sender: UISlider) {
        
        var c = Float(sender.value)
        c = round(c)
        c = c * 0.1
        
        textField3Value = c.currencyFormattingWithSymbol(currencySymbol: "%")
        stepper3Value = Double(sender.value)
        slider3Value = sender.value
        
        pocitani()
        
    }

    func sporeniMesicniPlatbaSliderAction(sender: UISlider) {
        
        let a = Int(sender.value)*100
        
        textField4Value = a.currencyFormattingWithSymbol(currencySymbol: "Kč")
        stepper4Value = Double(a)
        slider4Value = sender.value
        
        pocitani()
        
    }
    
    func sporeniDobaSliderAction(sender: UISlider) {
        
        let b = Int(sender.value)
        
        textField5Value = b.currencyFormattingWithSymbol(currencySymbol: "let")
        stepper5Value = Double(b)
        slider5Value = sender.value
        
        pocitani()
        
    }
    
    func sporeniUrokSliderAction(sender: UISlider) {
        
        var c = Float(sender.value)
        c = round(c)
        c = c * 0.1
        
        textField6Value = c.currencyFormattingWithSymbol(currencySymbol: "%")
        stepper6Value = Double(sender.value)
        slider6Value = sender.value
        
        pocitani()
        
    }
    
    //MARK: - stepper ibactions
    
    func uverCastkaStepperAction(sender: UIStepper) {
        
        let a = Int(sender.value)
        
        textField1Value = a.currencyFormattingWithSymbol(currencySymbol: "Kč")
        slider1Value = Float(sender.value)/100000
        stepper1Value = sender.value
        
        pocitani()
        
    }
    
    func uverDobaStepperAction(sender: UIStepper) {
        
        let b = Int(sender.value)
        
        textField2Value = b.currencyFormattingWithSymbol(currencySymbol: "let")
        slider2Value = Float(sender.value)
        stepper2Value = sender.value
        
        pocitani()
        
    }
    
    func uverUrokStepperAction(sender: UIStepper) {
        
        var c = Float(sender.value)
        
        c = round(c)
        
        c = c * 0.1
        
        textField3Value = c.currencyFormattingWithSymbol(currencySymbol: "%")
        slider3Value = Float(sender.value)
        stepper3Value = sender.value
        
        pocitani()
        
    }
    
    func sporeniMesicniPlatbaStepperAction(sender: UIStepper) {
        
        let a = Int(sender.value)
        
        textField4Value = a.currencyFormattingWithSymbol(currencySymbol: "Kč")
        slider4Value = Float(sender.value)/100
        stepper4Value = sender.value
        
        pocitani()
        
    }
    
    func sporeniDobaStepperAction(sender: UIStepper) {
        
        let b = Int(sender.value)
        
        textField5Value = b.currencyFormattingWithSymbol(currencySymbol: "let")
        slider5Value = Float(sender.value)
        stepper5Value = sender.value
        
        pocitani()
        
    }
    
    func sporeniUrokStepperAction(sender: UIStepper) {
        
        var c = Float(sender.value)
        c = round(c)
        c = c * 0.1
        
        textField6Value = c.currencyFormattingWithSymbol(currencySymbol: "%")
        slider6Value = Float(sender.value)
        stepper6Value = sender.value
        
        pocitani()
        
    }
    
    //MARK: - text field actions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.text != "" {
            
            var int = Int()
            
            if textField.tag == 3 || textField.tag == 6 {
                
                int = 1
                
            } else {
                
                int = 3
            }
            
            textField.text = textField.text?.chopSuffix(count: int).condenseWhitespace()
            
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 1 {
            
            var num = Int((textField.text! as NSString).intValue)
            
            if num > 50000000 {
                
                num = 50000000
            }
            
            if num < 100000 || textField.text == "" {
                
                num = 100000
            }
            
            slider1Value = Float(num)/100000
            stepper1Value = Double(num)
            textField1Value = num.currencyFormattingWithSymbol(currencySymbol: "Kč")
            
            pocitani()
            
        } else if textField.tag == 2 {
            
            var num = Int((textField.text! as NSString).intValue)
            
            if num > 50 {
                
                num = 50
            }
            
            if num < 1 || textField.text == "" {
                
                num = 1
                
            }
            
            slider2Value = Float(num)
            stepper2Value = Double(num)
            textField2Value = num.currencyFormattingWithSymbol(currencySymbol: "let")
            
            pocitani()
            
        } else if textField.tag == 3 {
            
            let str = textField.text?.replacingOccurrences(of: ",", with: ".")
            var num = Float((str! as NSString).floatValue)
            
            if num > 20 {
                
                num = 20
            }
            
            if num < 1.3 || textField.text == "" {
                
                num = 1.3
            }
            
            slider3Value = num*10
            stepper3Value = Double(num)*10
            textField3Value = num.currencyFormattingWithSymbol(currencySymbol: "%")
            
            pocitani()
        
        } else if textField.tag == 4 {
            
            var num = Int((textField.text! as NSString).intValue)
            
            if num > 10000 {
                
                num = 10000
            }
            
            if num < 500 || textField.text == "" {
                
                num = 500
            }
            
            slider4Value = Float(num)/100
            stepper4Value = Double(num)
            textField4Value = num.currencyFormattingWithSymbol(currencySymbol: "Kč")
            
            pocitani()
            
        } else if textField.tag == 5 {
            
            var num = Int((textField.text! as NSString).intValue)
            
            if num > 50 {
                
                num = 50
            }
            
            if num < 1 || textField.text == "" {
                
                num = 1
                
            }
            
            slider5Value = Float(num)
            stepper5Value = Double(num)
            textField5Value = num.currencyFormattingWithSymbol(currencySymbol: "let")
            
            pocitani()
            
        } else if textField.tag == 6 {
            
            let str = textField.text?.replacingOccurrences(of: ",", with: ".")
            var num = Float((str! as NSString).floatValue)
            
            if num > 20 {
                
                num = 20
            }
            
            if num < 1 || textField.text == "" {
                
                num = 1
            }
            
            slider6Value = num*10
            stepper6Value = Double(num)*10
            textField6Value = num.currencyFormattingWithSymbol(currencySymbol: "%")
            
            pocitani()
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result = true
        let prospectiveText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if string.count > 0 {
            
            var int = Int()
            
            if textField.tag == 1 {
                
                int = 8
                
            } else if textField.tag == 2 || textField.tag == 5 {
                
                int = 2
                
            } else if textField.tag == 3 || textField.tag == 6 {
                
                int = 4
                
            } else {
                
                int = 5
                
            }
            
            let resultingStringLengthIsLegal = prospectiveText.count <= int
            
            let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789.,").inverted
            let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
            
            let scanner = Scanner.localizedScanner(with: prospectiveText) as! Scanner
            let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.isAtEnd
            
            result = replacementStringIsLegal && resultingStringLengthIsLegal && resultingTextIsNumeric
            
        }
        
        return result
        
    }
    
    //MARK: - schovat klavesnici
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let toolbar = UIToolbar()
        textField.inputAccessoryView = toolbar.hideKeyboardToolbar()
        
        return true
    }
    
    //MARK: - segue
    
    @objc func segueToGraph() {
        
        self.performSegue(withIdentifier: "grafPPS", sender: self)
    }
    
    func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        
        if segue.identifier == "grafPPS" {
            
            let svc = segue.destination as! PPSGrafTableViewController
            
            svc.poleSporeni = sporeniSegue
            svc.poleJistin = jistinaSegue
            svc.mesicSplaceni = mesicSplaceniSegue
            svc.hlaskaSplaceni = hlaskaSplaceni
        }
    }
}
