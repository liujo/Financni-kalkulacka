//
//  Zdravi struct.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 27.10.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import Foundation
import UIKit

struct udajeKlienta {
    
    static var clientID = Int()
    
    //prvni screen: zakladni udaje
    static var krestniJmeno: String?
    static var prijmeni: String?
    static var vek: Int?
    static var povolani: String?
    static var pocetDeti: Int?
    static var rodinnyStav = "Svobodný"
    static var zdravotniStav = "Plně zdravý"
    static var sport: String?
    
    static var jeVyplnenoUdaje = false

    //druhy screen: zabezpeceni rodiny a prijmu
    static var jeVyplnenoZajisteniPrijmu = false
    static var chceResitZajisteniPrijmu = true
    
    //klient
    static var pracovniPomer = "Zaměstnanec"
    static var prijmy: Int?
    static var denniPrijmy: Int?
    static var vydaje: Int?
    static var denniVydaje: Int?
    
    static var maUver = false
    static var mesicniSplatkaUveru: Int?
    static var dluznaCastka: Int?
    static var rokFixace = 2015
    
    //partnerka Partnerka
    static var pracovniPomerPartner = "Zaměstnanec"
    static var prijmyPartner: Int?
    static var denniPrijmyPartner: Int?
    static var vydajePartner: Int?
    static var denniVydajePartner: Int?
    
    static var zajisteniPrijmuCastka: Int?
    static var zajisteniPrijmuPoznamky = String()
    
    //treti screen: bydleni
    static var chceResitBydleni = true
    static var jeVyplnenoBydleni = false

    static var bytCiDum = "Byt"
    static var vlastniCiNajemnni = "Vlastní"
    static var najemne = 0
    
    static var spokojenostSBydlenim = "Ano"
    static var spokojenostSBydlenimPoznamky = ""
    static var planujeVetsi = "Ne"
    static var planujeVetsiPoznamky = ""
    
    static var chceGrafBydleni = false
    static var grafBydleniPoleSporeni = [Int]()
    static var grafBydleniPoleJistin = [Int]()
    static var grafBydleniMesicSplaceni = Int()
    static var grafBydleniHlaskaSplaceni = String()
    
    static var grafBydleniUverCastka = Int()
    static var grafBydleniUverDoba = Int()
    static var grafBydleniUverUrok = Float()
    static var grafBydleniSporeniMesicniPlatba = Int()
    static var grafBydleniSporeniDoba = Int()
    static var grafBydleniSporeniUrok = Float()
    
    static var zajisteniBydleniCastka: Int?
    static var zajisteniBydleniPoznamky = ""
    
    //ctvrty screen: deti
    static var chceResitDeti = true
    static var jeVyplnenoDeti = false
    
    static var planujeteDeti = "Ano"
    static var pocetPlanovanychDeti: Int?
    static var otazka1 = true
    static var otazka2 = true
    
    static var detiJmena: [String] = [String(), String(), String(), String()]
    
    static var detiCilovaCastka :[Int] = [Int(), Int(), Int(), Int()]
    static var detiDoKdySporeni: [Int] = [Int(), Int(), Int(), Int()]
    static var detiMesicneSporeni: [Int] = [Int(), Int(), Int(), Int()]
    static var detiUrok: [Float] = [Float(), Float(), Float(), Float()]
    static var detiJeVyplneno: [Bool] = [Bool(), Bool(), Bool(), Bool()]
    
    //info pro grafy
    static var grafCelkovaUlozka = [Int(), Int(), Int(), Int()]
    static var grafDobaSporeni = [Int(), Int(), Int(), Int()]
    
    static var grafArrayUrok1 = [Int]()
    static var grafArrayUrok2 = [Int]()
    static var grafArrayUrok3 = [Int]()
    static var grafArrayUrok4 = [Int]()
    
    static var detiVynalozenaCastka: Int?
    static var detiPoznamky = ""
    
    //paty screen: duchod
    static var chceResitDuchod = true
    static var jeVyplnenoDuchod = false

    static var duchodVek: Int? //vek odchodu do duchodu
    
    static var pripravaNaDuchod = "Ano"
    static var jakDlouho: Int? //jak dlouho se pripravujete na duchod?
    
    static var chtelBysteSePripravit = "Ano"
    static var predstavovanaCastka: Int? //celkem castka na cely duchod, napr 4M
    
    static var chceGrafDuchodu = false
    static var grafDuchodCelkovaUlozka = Int()
    static var grafDuchodDobaSporeni = Int()
    static var grafDuchodUroky = [Int]()
    
    static var grafDuchodMesicniPlatba = Int()
    static var grafDuchodDoba = Int()
    static var grafDuchodRocniUrok = Float()
    
    static var duchodVynalozenaCastka: Int?
    static var duchodPoznamky = String()
    
    //sesty screen
    
    static var chceteResitDane = true
    static var danePoznamky = ""
    static var jeVyplnenoDane = false
    
    //sedmy screen
    
    static var ostatniPozadavky = ""
    static var chceResitOstatniPozadavky = false
    static var jeVyplnenoOstatniPozadavky = false
    
    //osmy screen
    
    static var priority = ["Zabezpečení příjmů a rodiny", "Bydlení", "Děti", "Důchod", "Daňové úlevy a státní dotace", "Ostatní požadavky"]
    static var jeVyplnenoPriority = false
    
    //devaty screen
    
    static var realnaCastkaNaProjekt: Int?

}