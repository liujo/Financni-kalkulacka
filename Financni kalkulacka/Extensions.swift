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
        
        let components = self.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).filter({!$0.characters.isEmpty})
        
        return components.joinWithSeparator("")
    }
    
    func chopSuffix(count: Int = 1) -> String {
        
        if self.characters.count < count {
            
            return self
        
        } else {
        
            return self.substringToIndex(self.endIndex.advancedBy(-count))
        
        }
        
    }
    
}

extension Int {
    
    func currencyFormattingWithSymbol(currencySymbol: String) -> String {
        
        let customFormatter = NSNumberFormatter()
        
        customFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        customFormatter.locale = NSLocale.init(localeIdentifier: "cs")
        customFormatter.currencySymbol = currencySymbol
        customFormatter.maximumFractionDigits = 0
        
        return customFormatter.stringFromNumber(self)!
        
    }
}

extension Float {
    
    func currencyFormattingWithSymbol(currencySymbol: String) -> String {
        
        let customFormatter = NSNumberFormatter()
        
        customFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        customFormatter.locale = NSLocale.currentLocale()
        customFormatter.currencySymbol = currencySymbol
        customFormatter.maximumFractionDigits = 1
        
        return customFormatter.stringFromNumber(self)!
    }
}

extension UIToolbar {
    
    func hideKeyboardToolbar() -> UIToolbar {
        
        // Create a button bar for the number pad
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        
        // Setup the buttons to be put in the system.
        let item1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let item2 = UIBarButtonItem(image: UIImage(named: "down.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UIViewController.endEditingNow))
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
    
    func endEditingNow(){
        
        self.view.endEditing(true)
        
    }
    
    //MARK: - priorities management
    
    func prioritiesUpdate(label: String, chceResit: Bool) {
        
        let index = udajeKlienta.priority.indexOf(label)
        
        if index == nil {
            
            if chceResit {
            
                udajeKlienta.priority.append(label)
            
            }
            
        } else {
            
            if chceResit == false {
                
                udajeKlienta.priority.removeAtIndex(index!)

            }
            
        }
        
        print(udajeKlienta.priority)
        
    }
    
    //MARK: - data management
    
    func exportData() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
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
            
            var clientsArray = defaults.arrayForKey("clientsArray") as! [Int]
            clientsArray.insert(num, atIndex: 0)
            defaults.setObject(clientsArray, forKey: "clientsArray")
        }
    
        
        //tady vytvorim dictionary do kteryho dam udaje klienta
    
        var dictionary: Dictionary<String, AnyObject> = [:]
        
        dictionary["clientID"] = udajeKlienta.clientID
        
        //zakladni udaje
        dictionary["krestniJmeno"] = udajeKlienta.krestniJmeno
        dictionary["prijmeni"] = udajeKlienta.prijmeni
        dictionary["vek"] = udajeKlienta.vek
        dictionary["povolani"] = udajeKlienta.povolani
        dictionary["pocetDeti"] = udajeKlienta.pocetDeti
        dictionary["rodinnyStav"] = udajeKlienta.rodinnyStav
        dictionary["zdravotniStav"] = udajeKlienta.zdravotniStav
        dictionary["sport"] = udajeKlienta.sport
        
        dictionary["jeVyplnenoUdaje"] = udajeKlienta.jeVyplnenoUdaje
        
        //zajisteni prijmu
        dictionary["jeVyplnenoZajisteniPrijmu"] = udajeKlienta.jeVyplnenoZajisteniPrijmu
        dictionary["chceResitZajisteniPrijmu"] = udajeKlienta.chceResitZajisteniPrijmu
        
        dictionary["pracovniPomer"] = udajeKlienta.pracovniPomer
        dictionary["prijmy"] = udajeKlienta.prijmy
        dictionary["denniPrijmy"] = udajeKlienta.denniPrijmy
        dictionary["vydaje"] = udajeKlienta.vydaje
        dictionary["denniVydaje"] = udajeKlienta.denniVydaje
        
        dictionary["maUver"] = udajeKlienta.maUver
        dictionary["mesicniSplatkaUveru"] = udajeKlienta.mesicniSplatkaUveru
        dictionary["dluznaCastkaUver"] = udajeKlienta.dluznaCastka
        dictionary["rokFixaceUver"] = udajeKlienta.rokFixace
        
        dictionary["pracovniPomerPartner"] = udajeKlienta.pracovniPomerPartner
        dictionary["prijmyPartner"] = udajeKlienta.prijmyPartner
        dictionary["denniPrijmyPartner"] = udajeKlienta.denniPrijmyPartner
        dictionary["vydajePartner"] = udajeKlienta.vydajePartner
        dictionary["denniVydajePartner"] = udajeKlienta.denniVydajePartner
        
        dictionary["zajisteniPrijmuCastka"] = udajeKlienta.zajisteniPrijmuCastka
        dictionary["zajisteniPrijmuPoznamky"] = udajeKlienta.zajisteniPrijmuPoznamky
        
        //bydleni
        dictionary["chceResitBydleni"] = udajeKlienta.chceResitBydleni
        dictionary["jeVyplnenoBydleni"] = udajeKlienta.jeVyplnenoBydleni
        
        dictionary["bytCiDum"] = udajeKlienta.bytCiDum
        dictionary["vlastniCiNajemni"] = udajeKlienta.vlastniCiNajemnni
        dictionary["najemne"] = udajeKlienta.najemne
        
        dictionary["spokojenostSBydlenim"] = udajeKlienta.spokojenostSBydlenim
        dictionary["spokojenostSBydlenimPoznamky"] = udajeKlienta.spokojenostSBydlenimPoznamky
        dictionary["planujeVetsiNemovitost"] = udajeKlienta.planujeVetsi
        dictionary["planujeVetsiNemovitostPoznamky"] = udajeKlienta.planujeVetsiPoznamky
        
        dictionary["chceGrafBydleni"] = udajeKlienta.chceGrafBydleni
        dictionary["grafBydleniPoleSporeni"] = udajeKlienta.grafBydleniPoleSporeni
        dictionary["grafBydleniPoleJistin"] = udajeKlienta.grafBydleniPoleJistin
        dictionary["grafBydleniMesicSplaceni"] = udajeKlienta.grafBydleniMesicSplaceni
        dictionary["grafBydleniHlaskaSplaceni"] = udajeKlienta.grafBydleniHlaskaSplaceni
        
        dictionary["bydleniVynalozenaCastka"] = udajeKlienta.zajisteniBydleniCastka
        dictionary["bydleniPoznamky"] = udajeKlienta.zajisteniBydleniPoznamky
        
        //deti
        dictionary["chceResitDeti"] = udajeKlienta.chceResitDeti
        dictionary["jeVyplnenoDeti"] = udajeKlienta.jeVyplnenoDeti
        
        dictionary["planujeteDeti"] = udajeKlienta.planujeteDeti
        dictionary["pocetPlanovanychDeti"] = udajeKlienta.pocetPlanovanychDeti
        dictionary["otazka1"] = udajeKlienta.otazka1
        dictionary["otazka2"] = udajeKlienta.otazka2
        
        dictionary["detiJmena"] = udajeKlienta.detiJmena
        
        dictionary["detiCilovaCastka"] = udajeKlienta.detiCilovaCastka
        dictionary["detiDoKdySporeni"] = udajeKlienta.detiDoKdySporeni
        dictionary["detiMesicneSporeni"] = udajeKlienta.detiMesicneSporeni
        dictionary["detiUrok"] = udajeKlienta.detiUrok
        dictionary["detiJeVyplneno"] = udajeKlienta.detiJeVyplneno
        
        dictionary["grafCelkovaUlozka"] = udajeKlienta.grafCelkovaUlozka
        dictionary["grafDobaSporeni"] = udajeKlienta.grafDobaSporeni
        
        dictionary["grafArrayUrok1"] = udajeKlienta.grafArrayUrok1
        dictionary["grafArrayUrok2"] = udajeKlienta.grafArrayUrok2
        dictionary["grafArrayUrok3"] = udajeKlienta.grafArrayUrok3
        dictionary["grafArrayUrok4"] = udajeKlienta.grafArrayUrok4
        
        dictionary["detiVynalozenaCastka"] = udajeKlienta.detiVynalozenaCastka
        dictionary["detiPoznamky"] = udajeKlienta.detiPoznamky
        
        //duchod
        dictionary["chceResitDuchod"] = udajeKlienta.chceResitDuchod
        dictionary["jeVyplnenoDuchod"] = udajeKlienta.jeVyplnenoDuchod
        
        dictionary["duchodVek"] = udajeKlienta.duchodVek
        
        dictionary["pripravaNaDuchod"] = udajeKlienta.pripravaNaDuchod
        dictionary["jakDlouho"] = udajeKlienta.jakDlouho
        
        dictionary["chtelBysteSePripravitNaDuchod"] = udajeKlienta.chtelBysteSePripravit
        dictionary["predstavovanaCastkaVDuchodu"] = udajeKlienta.predstavovanaCastka
        
        dictionary["chceGrafDuchodu"] = udajeKlienta.chceGrafDuchodu
        dictionary["grafDuchodCelkovaUlozka"] = udajeKlienta.grafDuchodCelkovaUlozka
        dictionary["grafDuchodDobaSporeni"] = udajeKlienta.grafDuchodDobaSporeni
        dictionary["grafDuchodUroky"] = udajeKlienta.grafDuchodUroky
        
        dictionary["duchodVynalozenaCastka"] = udajeKlienta.duchodVynalozenaCastka
        dictionary["duchodPoznamky"] = udajeKlienta.duchodPoznamky
        
        //dane
        dictionary["chceteResitDane"] = udajeKlienta.chceteResitDane
        dictionary["jeVyplnenoDane"] = udajeKlienta.jeVyplnenoDane
        dictionary["danePoznamky"] = udajeKlienta.danePoznamky
        
        //ostatni pozadavky
        dictionary["ostatniPozadavky"] = udajeKlienta.ostatniPozadavky
        dictionary["chceResitOstatniPozadavky"] = udajeKlienta.chceResitOstatniPozadavky
        dictionary["jeVyplnenoOstatniPozadavky"] = udajeKlienta.jeVyplnenoOstatniPozadavky
        
        //priority
        dictionary["priority"] = udajeKlienta.priority
        dictionary["jeVyplnenoPriority"] = udajeKlienta.jeVyplnenoPriority
        
        //shrnuti
        dictionary["realnaCastkaNaProjekt"] = udajeKlienta.realnaCastkaNaProjekt
        
        //ulozim dictionary do appky
        let arr = defaults.arrayForKey("clientsArray") as! [Int]
        if arr.contains(udajeKlienta.clientID) {
            
            defaults.removeObjectForKey("\(udajeKlienta.clientID)")
            
        }
        defaults.setObject(dictionary, forKey: "\(udajeKlienta.clientID)")
        
        resetStruct()
        
    }
    
    func fillStruct(clientID: Int) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let clientInfo = defaults.objectForKey("\(clientID)")
        
        udajeKlienta.clientID = clientID
        
        //prvni screen: zakladni udaje
        udajeKlienta.krestniJmeno = clientInfo!["krestniJmeno"] as? String
        udajeKlienta.prijmeni = clientInfo!["prijmeni"] as? String
        udajeKlienta.vek = clientInfo!["vek"] as? Int
        udajeKlienta.povolani = clientInfo!["povolani"] as? String
        udajeKlienta.pocetDeti = clientInfo!["pocetDeti"] as? Int
        udajeKlienta.rodinnyStav = clientInfo!["rodinnyStav"] as! String
        udajeKlienta.zdravotniStav = clientInfo!["zdravotniStav"] as! String
        udajeKlienta.sport = clientInfo!["sport"] as? String
        
        udajeKlienta.jeVyplnenoUdaje = clientInfo!["jeVyplnenoUdaje"] as! Bool
        
        //druhy screen: zabezpeceni rodiny a prijmu
        udajeKlienta.jeVyplnenoZajisteniPrijmu = clientInfo!["jeVyplnenoZajisteniPrijmu"] as! Bool
        udajeKlienta.chceResitZajisteniPrijmu = clientInfo!["chceResitZajisteniPrijmu"] as! Bool

        udajeKlienta.pracovniPomer = clientInfo!["pracovniPomer"] as! String
        udajeKlienta.prijmy = clientInfo!["prijmy"] as? Int
        udajeKlienta.denniPrijmy = clientInfo!["denniPrijmy"] as? Int
        udajeKlienta.vydaje = clientInfo!["vydaje"] as? Int
        udajeKlienta.denniVydaje = clientInfo!["denniVydaje"] as? Int
        
        udajeKlienta.maUver = clientInfo!["maUver"] as! Bool
        udajeKlienta.mesicniSplatkaUveru = clientInfo!["mesicniSplatkaUveru"] as? Int
        udajeKlienta.dluznaCastka = clientInfo!["dluznaCastkaUver"] as? Int
        udajeKlienta.rokFixace = clientInfo!["rokFixaceUver"] as! Int
        
        udajeKlienta.pracovniPomerPartner = clientInfo!["pracovniPomerPartner"] as! String
        udajeKlienta.prijmyPartner = clientInfo!["prijmyPartner"] as? Int
        udajeKlienta.denniPrijmyPartner = clientInfo!["denniPrijmyPartner"] as? Int
        udajeKlienta.vydajePartner = clientInfo!["vydajePartner"] as? Int
        udajeKlienta.denniVydajePartner = clientInfo!["denniVydajePartner"] as? Int
        
        udajeKlienta.zajisteniPrijmuCastka = clientInfo!["zajisteniPrijmuCastka"] as? Int
        udajeKlienta.zajisteniPrijmuPoznamky = clientInfo!["zajisteniPrijmuPoznamky"] as! String
        
        //treti screen: bydleni
        udajeKlienta.chceResitBydleni = clientInfo!["chceResitBydleni"] as! Bool
        udajeKlienta.jeVyplnenoBydleni = clientInfo!["jeVyplnenoBydleni"] as! Bool
        
        udajeKlienta.bytCiDum = clientInfo!["bytCiDum"] as! String
        udajeKlienta.vlastniCiNajemnni = clientInfo!["vlastniCiNajemni"] as! String
        udajeKlienta.najemne = clientInfo!["najemne"] as! Int
        
        udajeKlienta.spokojenostSBydlenim = clientInfo!["spokojenostSBydlenim"] as! String
        udajeKlienta.spokojenostSBydlenimPoznamky = clientInfo!["spokojenostSBydlenimPoznamky"] as! String
        udajeKlienta.planujeVetsi = clientInfo!["planujeVetsiNemovitost"] as! String
        udajeKlienta.planujeVetsiPoznamky = clientInfo!["planujeVetsiNemovitostPoznamky"] as! String
        
        udajeKlienta.chceGrafBydleni = clientInfo!["chceGrafBydleni"] as! Bool
        udajeKlienta.grafBydleniPoleSporeni = clientInfo!["grafBydleniPoleSporeni"] as! [Int]
        udajeKlienta.grafBydleniPoleJistin = clientInfo!["grafBydleniPoleJistin"] as! [Int]
        udajeKlienta.grafBydleniMesicSplaceni = clientInfo!["grafBydleniMesicSplaceni"] as! Int
        udajeKlienta.grafBydleniHlaskaSplaceni = clientInfo!["grafBydleniHlaskaSplaceni"] as! String
        
        udajeKlienta.zajisteniBydleniCastka = clientInfo!["bydleniVynalozenaCastka"] as? Int
        udajeKlienta.zajisteniBydleniPoznamky = clientInfo!["bydleniPoznamky"] as! String
        
        //ctvrty screen: deti
        udajeKlienta.chceResitDeti = clientInfo!["chceResitDeti"] as! Bool
        udajeKlienta.jeVyplnenoDeti = clientInfo!["jeVyplnenoDeti"] as! Bool

        udajeKlienta.planujeteDeti = clientInfo!["planujeteDeti"] as! String
        udajeKlienta.pocetPlanovanychDeti = clientInfo!["pocetPlanovanychDeti"] as? Int
        udajeKlienta.otazka1 = clientInfo!["otazka1"] as! Bool
        udajeKlienta.otazka2 = clientInfo!["otazka2"] as! Bool
        
        udajeKlienta.detiJmena = clientInfo!["detiJmena"] as! [String]
        
        udajeKlienta.detiCilovaCastka = clientInfo!["detiCilovaCastka"] as! [Int]
        udajeKlienta.detiDoKdySporeni = clientInfo!["detiDoKdySporeni"] as! [Int]
        udajeKlienta.detiMesicneSporeni = clientInfo!["detiMesicneSporeni"] as! [Int]
        udajeKlienta.detiUrok = clientInfo!["detiUrok"] as! [Float]
        udajeKlienta.detiJeVyplneno = clientInfo!["detiJeVyplneno"] as! [Bool]
        
        udajeKlienta.grafCelkovaUlozka = clientInfo!["grafCelkovaUlozka"] as! [Int]
        udajeKlienta.grafDobaSporeni = clientInfo!["grafDobaSporeni"] as! [Int]
        
        udajeKlienta.grafArrayUrok1 = clientInfo!["grafArrayUrok1"] as! [Int]
        udajeKlienta.grafArrayUrok2 = clientInfo!["grafArrayUrok2"] as! [Int]
        udajeKlienta.grafArrayUrok3 = clientInfo!["grafArrayUrok3"] as! [Int]
        udajeKlienta.grafArrayUrok4 = clientInfo!["grafArrayUrok4"] as! [Int]
        
        udajeKlienta.detiVynalozenaCastka = clientInfo!["detiVynalozenaCastka"] as? Int
        udajeKlienta.detiPoznamky = clientInfo!["detiPoznamky"] as! String
        
        //paty screen: duchod
        udajeKlienta.chceResitDuchod = clientInfo!["chceResitDuchod"] as! Bool
        udajeKlienta.jeVyplnenoDuchod = clientInfo!["jeVyplnenoDuchod"] as! Bool

        udajeKlienta.duchodVek = clientInfo!["duchodVek"] as? Int //vek odchodu do duchodu
        
        udajeKlienta.pripravaNaDuchod = clientInfo!["pripravaNaDuchod"] as! String
        udajeKlienta.jakDlouho = clientInfo!["jakDlouho"] as? Int
        
        udajeKlienta.chtelBysteSePripravit = clientInfo!["chtelBysteSePripravitNaDuchod"] as! String
        udajeKlienta.predstavovanaCastka = clientInfo!["predstavovanaCastkaVDuchodu"] as? Int //celkem castka na cely duchod, napr 4M
        
        udajeKlienta.chceGrafDuchodu = clientInfo!["chceGrafDuchodu"] as! Bool
        udajeKlienta.grafDuchodCelkovaUlozka = clientInfo!["grafDuchodCelkovaUlozka"] as! Int
        udajeKlienta.grafDuchodDobaSporeni = clientInfo!["grafDuchodDobaSporeni"] as! Int
        udajeKlienta.grafDuchodUroky = clientInfo!["grafDuchodUroky"] as! [Int]
        
        udajeKlienta.duchodVynalozenaCastka = clientInfo!["duchodVynalozenaCastka"] as? Int
        udajeKlienta.duchodPoznamky = clientInfo!["duchodPoznamky"] as! String
        
        //sesty screen
        
        udajeKlienta.chceteResitDane = clientInfo!["chceteResitDane"] as! Bool
        udajeKlienta.jeVyplnenoDane = clientInfo!["jeVyplnenoDane"] as! Bool
        udajeKlienta.danePoznamky = clientInfo!["danePoznamky"] as! String
        
        //sedmy screen
        
        udajeKlienta.ostatniPozadavky = clientInfo!["ostatniPozadavky"] as! String
        udajeKlienta.chceResitOstatniPozadavky = clientInfo!["chceResitOstatniPozadavky"] as! Bool
        udajeKlienta.jeVyplnenoOstatniPozadavky = clientInfo!["jeVyplnenoOstatniPozadavky"] as! Bool
        
        //osmy screen
        
        udajeKlienta.priority = clientInfo!["priority"] as! [String]
        udajeKlienta.jeVyplnenoPriority = clientInfo!["jeVyplnenoPriority"] as! Bool
        
        //devaty screen
        
        udajeKlienta.realnaCastkaNaProjekt = clientInfo!["realnaCastkaNaProjekt"] as? Int
        
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
