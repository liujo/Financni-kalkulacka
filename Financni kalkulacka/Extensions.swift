//
//  Number formatting.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 03.11.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import UIKit

extension String {
    
    func condenseWhitespace() -> String {
        
        let components = self.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter({!$0.isEmpty})
        
        return components.joined(separator: "")
    }
    
    func chopSuffix(count: Int = 1) -> String {
        
        if self.count < count {
            
            return self
        
        } else {
            
            let index = self.index(self.endIndex, offsetBy: -count)
            let substring = self[..<index]
            return String(substring)
        
        }
        
    }
    
}

extension Int {
    
    func currencyFormattingWithSymbol(currencySymbol: String) -> String {
        
        let customFormatter = NumberFormatter()
        
        customFormatter.numberStyle = .currency
        customFormatter.locale = Locale.init(identifier: "cs")
        customFormatter.currencySymbol = currencySymbol
        customFormatter.maximumFractionDigits = 0
        
        return customFormatter.string(from: NSNumber(value: self))!
        
    }
}

extension Float {
    
    func currencyFormattingWithSymbol(currencySymbol: String) -> String {
        
        let customFormatter = NumberFormatter()
        
        customFormatter.numberStyle = .currency
        customFormatter.locale = Locale.autoupdatingCurrent
        customFormatter.currencySymbol = currencySymbol
        customFormatter.maximumFractionDigits = 1
        
        return customFormatter.string(from: NSNumber(value: self))!
    }
}

extension UIToolbar {
    
    func hideKeyboardToolbar() -> UIToolbar {
        
        // Create a button bar for the number pad
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        
        // Setup the buttons to be put in the system.
        let item1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let item2 = UIBarButtonItem(image: UIImage(named: "down.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(UIViewController.endEditingNow))
        let toolbarButtons = [item1, item2]
        
        //Put the buttons into the ToolBar and display the tool bar
        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
        
        return keyboardDoneButtonView
    }
}

extension UIImage {
    
    func background(height: CGFloat) -> UIImage {
        
        let int = Int(height)
        let bg = UIImage(named: "background\(int)")
        
        return bg!
    }

}

extension Array {
    
    func actionSheetStrings() -> [String] {
        
        let title = String()
        let message = "Opravdu chcete ukončit Kartu Klienta? Veškerá data budou uložena."
        let alertTitle1 = "Ukončit Kartu Klienta"
        let alertTitle2 = "Zrušit"
        
        let arr = [title, message, alertTitle1, alertTitle2]
        
        return arr
        
    }
    
}

extension UIViewController {
    
    @objc func endEditingNow(){
        
        self.view.endEditing(true)
        
    }
    
    //MARK: - priorities management
    
    func prioritiesUpdate(label: String, chceResit: Bool) {
        
        let index = udajeKlienta.priority.index(of: label)
        
        if index == nil {
            
            if chceResit {
            
                udajeKlienta.priority.append(label)
            
            }
            
        } else {
            
            if chceResit == false {
                
                udajeKlienta.priority.remove(at: index!)

            }
            
        }
        
        print(udajeKlienta.priority)
        
    }
    
    //MARK: - data management
    
    func exportData() {
        
        let defaults = UserDefaults.standard
        var clientID = UInt32()

        print("clientId", udajeKlienta.clientID)
        
        if udajeKlienta.clientID == 0 {
            
            //klientID
            
            var i = 10000
            
            while i < 100000 {
                
                clientID = arc4random_uniform(90999) + 10000
                
                if defaults.dictionaryRepresentation().keys.contains("\(clientID)") != true {
                    
                    break
                    
                }
                
                i += 1
                
            }
            
            //clients array = pole IDs klientu do prvniho screenu karty klienta
            let num = Int(clientID)
            print("new client ID", num)
            udajeKlienta.clientID = num
            
            var clientsArray = defaults.array(forKey: "clientsArray") as! [Int]
            clientsArray.insert(num, at: 0)
            defaults.set(clientsArray, forKey: "clientsArray")
        }
    
        
        //tady vytvorim dictionary do kteryho dam udaje klienta
    
        var dictionary: Dictionary<String, AnyObject> = [:]
        
        dictionary["clientID"] = udajeKlienta.clientID as AnyObject
        
        //zakladni udaje
        dictionary["krestniJmeno"] = udajeKlienta.krestniJmeno as AnyObject
        dictionary["prijmeni"] = udajeKlienta.prijmeni as AnyObject
        dictionary["vek"] = udajeKlienta.vek as AnyObject
        dictionary["povolani"] = udajeKlienta.povolani as AnyObject
        dictionary["pocetDeti"] = udajeKlienta.pocetDeti as AnyObject
        dictionary["rodinnyStav"] = udajeKlienta.rodinnyStav as AnyObject
        dictionary["zdravotniStav"] = udajeKlienta.zdravotniStav as AnyObject
        dictionary["sport"] = udajeKlienta.sport as AnyObject
        
        dictionary["jeVyplnenoUdaje"] = udajeKlienta.jeVyplnenoUdaje as AnyObject
        
        //zajisteni prijmu
        dictionary["jeVyplnenoZajisteniPrijmu"] = udajeKlienta.jeVyplnenoZajisteniPrijmu as AnyObject
        dictionary["chceResitZajisteniPrijmu"] = udajeKlienta.chceResitZajisteniPrijmu as AnyObject
        
        dictionary["pracovniPomer"] = udajeKlienta.pracovniPomer as AnyObject
        dictionary["prijmy"] = udajeKlienta.prijmy as AnyObject
        dictionary["denniPrijmy"] = udajeKlienta.denniPrijmy as AnyObject
        dictionary["vydaje"] = udajeKlienta.vydaje as AnyObject
        dictionary["denniVydaje"] = udajeKlienta.denniVydaje as AnyObject
        
        dictionary["maUver"] = udajeKlienta.maUver as AnyObject
        dictionary["mesicniSplatkaUveru"] = udajeKlienta.mesicniSplatkaUveru as AnyObject
        dictionary["dluznaCastkaUver"] = udajeKlienta.dluznaCastka as AnyObject
        dictionary["rokFixaceUver"] = udajeKlienta.rokFixace as AnyObject
        
        dictionary["pracovniPomerPartner"] = udajeKlienta.pracovniPomerPartner as AnyObject
        dictionary["prijmyPartner"] = udajeKlienta.prijmyPartner as AnyObject
        dictionary["denniPrijmyPartner"] = udajeKlienta.denniPrijmyPartner as AnyObject
        dictionary["vydajePartner"] = udajeKlienta.vydajePartner as AnyObject
        dictionary["denniVydajePartner"] = udajeKlienta.denniVydajePartner as AnyObject
        
        dictionary["zajisteniPrijmuCastka"] = udajeKlienta.zajisteniPrijmuCastka as AnyObject
        dictionary["zajisteniPrijmuPoznamky"] = udajeKlienta.zajisteniPrijmuPoznamky as AnyObject
        
        //bydleni
        dictionary["chceResitBydleni"] = udajeKlienta.chceResitBydleni as AnyObject
        dictionary["jeVyplnenoBydleni"] = udajeKlienta.jeVyplnenoBydleni as AnyObject
        
        dictionary["bytCiDum"] = udajeKlienta.bytCiDum as AnyObject
        dictionary["vlastniCiNajemni"] = udajeKlienta.vlastniCiNajemnni as AnyObject
        dictionary["najemne"] = udajeKlienta.najemne as AnyObject
        
        dictionary["spokojenostSBydlenim"] = udajeKlienta.spokojenostSBydlenim as AnyObject
        dictionary["spokojenostSBydlenimPoznamky"] = udajeKlienta.spokojenostSBydlenimPoznamky as AnyObject
        dictionary["planujeVetsiNemovitost"] = udajeKlienta.planujeVetsi as AnyObject
        dictionary["planujeVetsiNemovitostPoznamky"] = udajeKlienta.planujeVetsiPoznamky as AnyObject
        
        dictionary["chceGrafBydleni"] = udajeKlienta.chceGrafBydleni as AnyObject
        dictionary["grafBydleniPoleSporeni"] = udajeKlienta.grafBydleniPoleSporeni as AnyObject
        dictionary["grafBydleniPoleJistin"] = udajeKlienta.grafBydleniPoleJistin as AnyObject
        dictionary["grafBydleniMesicSplaceni"] = udajeKlienta.grafBydleniMesicSplaceni as AnyObject
        dictionary["grafBydleniHlaskaSplaceni"] = udajeKlienta.grafBydleniHlaskaSplaceni as AnyObject
        
        dictionary["bydleniVynalozenaCastka"] = udajeKlienta.zajisteniBydleniCastka as AnyObject
        dictionary["bydleniPoznamky"] = udajeKlienta.zajisteniBydleniPoznamky as AnyObject
        
        //deti
        dictionary["chceResitDeti"] = udajeKlienta.chceResitDeti as AnyObject
        dictionary["jeVyplnenoDeti"] = udajeKlienta.jeVyplnenoDeti as AnyObject
        
        dictionary["planujeteDeti"] = udajeKlienta.planujeteDeti as AnyObject
        dictionary["pocetPlanovanychDeti"] = udajeKlienta.pocetPlanovanychDeti as AnyObject
        dictionary["otazka1"] = udajeKlienta.otazka1 as AnyObject
        dictionary["otazka2"] = udajeKlienta.otazka2 as AnyObject
        
        dictionary["detiJmena"] = udajeKlienta.detiJmena as AnyObject
        
        dictionary["detiCilovaCastka"] = udajeKlienta.detiCilovaCastka as AnyObject
        dictionary["detiDoKdySporeni"] = udajeKlienta.detiDoKdySporeni as AnyObject
        dictionary["detiMesicneSporeni"] = udajeKlienta.detiMesicneSporeni as AnyObject
        dictionary["detiUrok"] = udajeKlienta.detiUrok as AnyObject
        dictionary["detiJeVyplneno"] = udajeKlienta.detiJeVyplneno as AnyObject
        
        dictionary["grafCelkovaUlozka"] = udajeKlienta.grafCelkovaUlozka as AnyObject
        dictionary["grafDobaSporeni"] = udajeKlienta.grafDobaSporeni as AnyObject
        
        dictionary["grafArrayUrok1"] = udajeKlienta.grafArrayUrok1 as AnyObject
        dictionary["grafArrayUrok2"] = udajeKlienta.grafArrayUrok2 as AnyObject
        dictionary["grafArrayUrok3"] = udajeKlienta.grafArrayUrok3 as AnyObject
        dictionary["grafArrayUrok4"] = udajeKlienta.grafArrayUrok4 as AnyObject
        
        dictionary["detiVynalozenaCastka"] = udajeKlienta.detiVynalozenaCastka as AnyObject
        dictionary["detiPoznamky"] = udajeKlienta.detiPoznamky as AnyObject
        
        //duchod
        dictionary["chceResitDuchod"] = udajeKlienta.chceResitDuchod as AnyObject
        dictionary["jeVyplnenoDuchod"] = udajeKlienta.jeVyplnenoDuchod as AnyObject
        
        dictionary["duchodVek"] = udajeKlienta.duchodVek as AnyObject
        
        dictionary["pripravaNaDuchod"] = udajeKlienta.pripravaNaDuchod as AnyObject
        dictionary["jakDlouho"] = udajeKlienta.jakDlouho as AnyObject
        
        dictionary["chtelBysteSePripravitNaDuchod"] = udajeKlienta.chtelBysteSePripravit as AnyObject
        dictionary["predstavovanaCastkaVDuchodu"] = udajeKlienta.predstavovanaCastka as AnyObject
        
        dictionary["chceGrafDuchodu"] = udajeKlienta.chceGrafDuchodu as AnyObject
        dictionary["grafDuchodCelkovaUlozka"] = udajeKlienta.grafDuchodCelkovaUlozka as AnyObject
        dictionary["grafDuchodDobaSporeni"] = udajeKlienta.grafDuchodDobaSporeni as AnyObject
        dictionary["grafDuchodUroky"] = udajeKlienta.grafDuchodUroky as AnyObject
        
        dictionary["duchodVynalozenaCastka"] = udajeKlienta.duchodVynalozenaCastka as AnyObject
        dictionary["duchodPoznamky"] = udajeKlienta.duchodPoznamky as AnyObject
        
        //dane
        dictionary["chceteResitDane"] = udajeKlienta.chceteResitDane as AnyObject
        dictionary["jeVyplnenoDane"] = udajeKlienta.jeVyplnenoDane as AnyObject
        dictionary["danePoznamky"] = udajeKlienta.danePoznamky as AnyObject
        
        //ostatni pozadavky
        dictionary["ostatniPozadavky"] = udajeKlienta.ostatniPozadavky as AnyObject
        dictionary["chceResitOstatniPozadavky"] = udajeKlienta.chceResitOstatniPozadavky as AnyObject
        dictionary["jeVyplnenoOstatniPozadavky"] = udajeKlienta.jeVyplnenoOstatniPozadavky as AnyObject
        
        //priority
        dictionary["priority"] = udajeKlienta.priority as AnyObject
        dictionary["jeVyplnenoPriority"] = udajeKlienta.jeVyplnenoPriority as AnyObject
        
        //shrnuti
        dictionary["realnaCastkaNaProjekt"] = udajeKlienta.realnaCastkaNaProjekt as AnyObject
        
        //ulozim dictionary do appky
        let arr = defaults.array(forKey: "clientsArray") as! [Int]
        if arr.contains(udajeKlienta.clientID) {
            
            defaults.removeObject(forKey: "\(udajeKlienta.clientID)")
            
        }
        defaults.set(dictionary, forKey: "\(udajeKlienta.clientID)")
        
        resetStruct()
        
    }
    
    func fillStruct(clientID: Int) {
        
        let defaults = UserDefaults.standard
        let clientInfo = defaults.object(forKey: "\(clientID)") as! Dictionary<String, AnyObject>

        udajeKlienta.clientID = clientID
        
        //prvni screen: zakladni udaje
        udajeKlienta.krestniJmeno = clientInfo["krestniJmeno"] as? String
        udajeKlienta.prijmeni = clientInfo["prijmeni"] as? String
        udajeKlienta.vek = clientInfo["vek"] as? Int
        udajeKlienta.povolani = clientInfo["povolani"] as? String
        udajeKlienta.pocetDeti = clientInfo["pocetDeti"] as? Int
        udajeKlienta.rodinnyStav = clientInfo["rodinnyStav"] as! String
        udajeKlienta.zdravotniStav = clientInfo["zdravotniStav"] as! String
        udajeKlienta.sport = clientInfo["sport"] as? String
        
        udajeKlienta.jeVyplnenoUdaje = clientInfo["jeVyplnenoUdaje"] as! Bool
        
        //druhy screen: zabezpeceni rodiny a prijmu
        udajeKlienta.jeVyplnenoZajisteniPrijmu = clientInfo["jeVyplnenoZajisteniPrijmu"] as! Bool
        udajeKlienta.chceResitZajisteniPrijmu = clientInfo["chceResitZajisteniPrijmu"] as! Bool

        udajeKlienta.pracovniPomer = clientInfo["pracovniPomer"] as! String
        udajeKlienta.prijmy = clientInfo["prijmy"] as? Int
        udajeKlienta.denniPrijmy = clientInfo["denniPrijmy"] as? Int
        udajeKlienta.vydaje = clientInfo["vydaje"] as? Int
        udajeKlienta.denniVydaje = clientInfo["denniVydaje"] as? Int
        
        udajeKlienta.maUver = clientInfo["maUver"] as! Bool
        udajeKlienta.mesicniSplatkaUveru = clientInfo["mesicniSplatkaUveru"] as? Int
        udajeKlienta.dluznaCastka = clientInfo["dluznaCastkaUver"] as? Int
        udajeKlienta.rokFixace = clientInfo["rokFixaceUver"] as! Int
        
        udajeKlienta.pracovniPomerPartner = clientInfo["pracovniPomerPartner"] as! String
        udajeKlienta.prijmyPartner = clientInfo["prijmyPartner"] as? Int
        udajeKlienta.denniPrijmyPartner = clientInfo["denniPrijmyPartner"] as? Int
        udajeKlienta.vydajePartner = clientInfo["vydajePartner"] as? Int
        udajeKlienta.denniVydajePartner = clientInfo["denniVydajePartner"] as? Int
        
        udajeKlienta.zajisteniPrijmuCastka = clientInfo["zajisteniPrijmuCastka"] as? Int
        udajeKlienta.zajisteniPrijmuPoznamky = clientInfo["zajisteniPrijmuPoznamky"] as! String
        
        //treti screen: bydleni
        udajeKlienta.chceResitBydleni = clientInfo["chceResitBydleni"] as! Bool
        udajeKlienta.jeVyplnenoBydleni = clientInfo["jeVyplnenoBydleni"] as! Bool
        
        udajeKlienta.bytCiDum = clientInfo["bytCiDum"] as! String
        udajeKlienta.vlastniCiNajemnni = clientInfo["vlastniCiNajemni"] as! String
        udajeKlienta.najemne = clientInfo["najemne"] as! Int
        
        udajeKlienta.spokojenostSBydlenim = clientInfo["spokojenostSBydlenim"] as! String
        udajeKlienta.spokojenostSBydlenimPoznamky = clientInfo["spokojenostSBydlenimPoznamky"] as! String
        udajeKlienta.planujeVetsi = clientInfo["planujeVetsiNemovitost"] as! String
        udajeKlienta.planujeVetsiPoznamky = clientInfo["planujeVetsiNemovitostPoznamky"] as! String
        
        udajeKlienta.chceGrafBydleni = clientInfo["chceGrafBydleni"] as! Bool
        udajeKlienta.grafBydleniPoleSporeni = clientInfo["grafBydleniPoleSporeni"] as! [Int]
        udajeKlienta.grafBydleniPoleJistin = clientInfo["grafBydleniPoleJistin"] as! [Int]
        udajeKlienta.grafBydleniMesicSplaceni = clientInfo["grafBydleniMesicSplaceni"] as! Int
        udajeKlienta.grafBydleniHlaskaSplaceni = clientInfo["grafBydleniHlaskaSplaceni"] as! String
        
        udajeKlienta.zajisteniBydleniCastka = clientInfo["bydleniVynalozenaCastka"] as? Int
        udajeKlienta.zajisteniBydleniPoznamky = clientInfo["bydleniPoznamky"] as! String
        
        //ctvrty screen: deti
        udajeKlienta.chceResitDeti = clientInfo["chceResitDeti"] as! Bool
        udajeKlienta.jeVyplnenoDeti = clientInfo["jeVyplnenoDeti"] as! Bool

        udajeKlienta.planujeteDeti = clientInfo["planujeteDeti"] as! String
        udajeKlienta.pocetPlanovanychDeti = clientInfo["pocetPlanovanychDeti"] as? Int
        udajeKlienta.otazka1 = clientInfo["otazka1"] as! Bool
        udajeKlienta.otazka2 = clientInfo["otazka2"] as! Bool
        
        udajeKlienta.detiJmena = clientInfo["detiJmena"] as! [String]
        
        udajeKlienta.detiCilovaCastka = clientInfo["detiCilovaCastka"] as! [Int]
        udajeKlienta.detiDoKdySporeni = clientInfo["detiDoKdySporeni"] as! [Int]
        udajeKlienta.detiMesicneSporeni = clientInfo["detiMesicneSporeni"] as! [Int]
        udajeKlienta.detiUrok = clientInfo["detiUrok"] as! [Float]
        udajeKlienta.detiJeVyplneno = clientInfo["detiJeVyplneno"] as! [Bool]
        
        udajeKlienta.grafCelkovaUlozka = clientInfo["grafCelkovaUlozka"] as! [Int]
        udajeKlienta.grafDobaSporeni = clientInfo["grafDobaSporeni"] as! [Int]
        
        udajeKlienta.grafArrayUrok1 = clientInfo["grafArrayUrok1"] as! [Int]
        udajeKlienta.grafArrayUrok2 = clientInfo["grafArrayUrok2"] as! [Int]
        udajeKlienta.grafArrayUrok3 = clientInfo["grafArrayUrok3"] as! [Int]
        udajeKlienta.grafArrayUrok4 = clientInfo["grafArrayUrok4"] as! [Int]
        
        udajeKlienta.detiVynalozenaCastka = clientInfo["detiVynalozenaCastka"] as? Int
        udajeKlienta.detiPoznamky = clientInfo["detiPoznamky"] as! String
        
        //paty screen: duchod
        udajeKlienta.chceResitDuchod = clientInfo["chceResitDuchod"] as! Bool
        udajeKlienta.jeVyplnenoDuchod = clientInfo["jeVyplnenoDuchod"] as! Bool

        udajeKlienta.duchodVek = clientInfo["duchodVek"] as? Int //vek odchodu do duchodu
        
        udajeKlienta.pripravaNaDuchod = clientInfo["pripravaNaDuchod"] as! String
        udajeKlienta.jakDlouho = clientInfo["jakDlouho"] as? Int
        
        udajeKlienta.chtelBysteSePripravit = clientInfo["chtelBysteSePripravitNaDuchod"] as! String
        udajeKlienta.predstavovanaCastka = clientInfo["predstavovanaCastkaVDuchodu"] as? Int //celkem castka na cely duchod, napr 4M
        
        udajeKlienta.chceGrafDuchodu = clientInfo["chceGrafDuchodu"] as! Bool
        udajeKlienta.grafDuchodCelkovaUlozka = clientInfo["grafDuchodCelkovaUlozka"] as! Int
        udajeKlienta.grafDuchodDobaSporeni = clientInfo["grafDuchodDobaSporeni"] as! Int
        udajeKlienta.grafDuchodUroky = clientInfo["grafDuchodUroky"] as! [Int]
        
        udajeKlienta.duchodVynalozenaCastka = clientInfo["duchodVynalozenaCastka"] as? Int
        udajeKlienta.duchodPoznamky = clientInfo["duchodPoznamky"] as! String
        
        //sesty screen
        
        udajeKlienta.chceteResitDane = clientInfo["chceteResitDane"] as! Bool
        udajeKlienta.jeVyplnenoDane = clientInfo["jeVyplnenoDane"] as! Bool
        udajeKlienta.danePoznamky = clientInfo["danePoznamky"] as! String
        
        //sedmy screen
        
        udajeKlienta.ostatniPozadavky = clientInfo["ostatniPozadavky"] as! String
        udajeKlienta.chceResitOstatniPozadavky = clientInfo["chceResitOstatniPozadavky"] as! Bool
        udajeKlienta.jeVyplnenoOstatniPozadavky = clientInfo["jeVyplnenoOstatniPozadavky"] as! Bool
        
        //osmy screen
        
        udajeKlienta.priority = clientInfo["priority"] as! [String]
        udajeKlienta.jeVyplnenoPriority = clientInfo["jeVyplnenoPriority"] as! Bool
        
        //devaty screen
        
        udajeKlienta.realnaCastkaNaProjekt = clientInfo["realnaCastkaNaProjekt"] as? Int
        
    }
    
    func resetStruct() {
        
        udajeKlienta.clientID = Int()
        
        //resetnu struct udajeKlientu do defaultu
        //prvni screen: zakladni udaje
        udajeKlienta.krestniJmeno = nil
        udajeKlienta.prijmeni = nil
        udajeKlienta.vek = nil
        udajeKlienta.povolani = nil
        udajeKlienta.pocetDeti = nil
        udajeKlienta.rodinnyStav = "Svobodný"
        udajeKlienta.zdravotniStav = "Plně zdravý"
        udajeKlienta.sport = nil
        
        udajeKlienta.jeVyplnenoUdaje = false
        
        //druhy screen: zabezpeceni rodiny a prijmu
        udajeKlienta.jeVyplnenoZajisteniPrijmu = false
        udajeKlienta.chceResitZajisteniPrijmu = true
        
        udajeKlienta.pracovniPomer = "Zaměstnanec"
        
        udajeKlienta.prijmy = nil
        udajeKlienta.denniPrijmy = nil
        udajeKlienta.vydaje = nil
        udajeKlienta.denniVydaje = nil
        
        udajeKlienta.maUver = false
        udajeKlienta.mesicniSplatkaUveru = nil
        udajeKlienta.dluznaCastka = nil
        udajeKlienta.rokFixace = 2015
        
        udajeKlienta.pracovniPomerPartner = "Zaměstnanec"
        udajeKlienta.prijmyPartner = nil
        udajeKlienta.denniPrijmyPartner = nil
        udajeKlienta.vydaje = nil
        udajeKlienta.denniVydaje = nil
        
        udajeKlienta.zajisteniPrijmuCastka = nil
        udajeKlienta.zajisteniPrijmuPoznamky = String()
        
        //treti screen: bydleni
        udajeKlienta.chceResitBydleni = true
        udajeKlienta.jeVyplnenoBydleni = false
        
        udajeKlienta.bytCiDum = "Byt"
        udajeKlienta.vlastniCiNajemnni = "Vlastní"
        udajeKlienta.najemne = 0
        
        udajeKlienta.spokojenostSBydlenim = "Ano"
        udajeKlienta.spokojenostSBydlenimPoznamky = ""
        udajeKlienta.planujeVetsi = "Ne"
        udajeKlienta.planujeVetsiPoznamky = ""
        
        udajeKlienta.chceGrafBydleni = false
        udajeKlienta.grafBydleniPoleSporeni = [Int]()
        udajeKlienta.grafBydleniPoleJistin = [Int]()
        udajeKlienta.grafBydleniMesicSplaceni = Int()
        udajeKlienta.grafBydleniHlaskaSplaceni = String()
        
        udajeKlienta.zajisteniBydleniCastka = nil
        udajeKlienta.zajisteniBydleniPoznamky = ""
        
        //ctvrty screen: deti
        udajeKlienta.chceResitDeti = true
        udajeKlienta.jeVyplnenoDeti = false

        udajeKlienta.planujeteDeti = "Ano"
        udajeKlienta.pocetPlanovanychDeti = nil
        udajeKlienta.otazka1 = true
        udajeKlienta.otazka2 = true
        
        udajeKlienta.detiJmena = [String(), String(), String(), String()]
        
        udajeKlienta.detiCilovaCastka = [Int(), Int(), Int(), Int()]
        udajeKlienta.detiDoKdySporeni = [Int(), Int(), Int(), Int()]
        udajeKlienta.detiMesicneSporeni = [Int(), Int(), Int(), Int()]
        udajeKlienta.detiUrok = [Float(), Float(), Float(), Float()]
        udajeKlienta.detiJeVyplneno = [Bool(), Bool(), Bool(), Bool()]
        
        udajeKlienta.grafCelkovaUlozka = [Int(), Int(), Int(), Int()]
        udajeKlienta.grafDobaSporeni = [Int(), Int(), Int(), Int()]
        
        udajeKlienta.grafArrayUrok1 = [Int]()
        udajeKlienta.grafArrayUrok2 = [Int]()
        udajeKlienta.grafArrayUrok3 = [Int]()
        udajeKlienta.grafArrayUrok4 = [Int]()
        
        udajeKlienta.detiVynalozenaCastka = nil
        udajeKlienta.detiPoznamky = ""
        
        //paty screen: duchod
        udajeKlienta.chceResitDuchod = true
        udajeKlienta.jeVyplnenoDuchod = false
        
        udajeKlienta.duchodVek = nil//vek odchodu do duchodu
        
        udajeKlienta.pripravaNaDuchod = "Ano"
        udajeKlienta.jakDlouho = nil//jak dlouho se pripravujete na duchod?
        
        udajeKlienta.chtelBysteSePripravit = "Ano"
        udajeKlienta.predstavovanaCastka = nil //celkem castka na cely duchod, napr 4M
        
        udajeKlienta.chceGrafDuchodu = false
        udajeKlienta.grafDuchodCelkovaUlozka = Int()
        udajeKlienta.grafDuchodDobaSporeni = Int()
        udajeKlienta.grafDuchodUroky = [Int]()
        
        udajeKlienta.duchodVynalozenaCastka = nil
        udajeKlienta.duchodPoznamky = String()
        
        //sesty screen
        
        udajeKlienta.chceteResitDane = true
        udajeKlienta.jeVyplnenoDane = false
        udajeKlienta.danePoznamky = ""
        
        //sedmy screen
        
        udajeKlienta.ostatniPozadavky = ""
        udajeKlienta.chceResitOstatniPozadavky = false
        udajeKlienta.jeVyplnenoOstatniPozadavky = false
        
        //osmy screen
        
        udajeKlienta.priority = ["Zabezpečení příjmů a rodiny", "Bydlení", "Děti", "Důchod", "Daňové úlevy a státní dotace"]
        udajeKlienta.jeVyplnenoPriority = false
        
        //devaty screen
        
        udajeKlienta.realnaCastkaNaProjekt = nil
    }
    
}
