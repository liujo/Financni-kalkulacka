//
//  8.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 27.10.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import UIKit

//MARK: - 1. Zakladni udaje

class KrestniJmeno: UITableViewCell {
    
    @IBOutlet weak var krestniJmeno: UITextField!
    
}

class Prijmeni: UITableViewCell {
    
    @IBOutlet weak var prijmeni: UITextField!
    
}

class Vek: UITableViewCell {
    
    @IBOutlet weak var vek: UITextField!
    
}

class Povolani: UITableViewCell {
    
    @IBOutlet weak var povolani: UITextField!
    
}

class Deti: UITableViewCell {
    
    @IBOutlet weak var deti: UITextField!
        
}

class RodinnyStav: UITableViewCell {
    
    @IBOutlet weak var rodinnyStav: UILabel!
}

class Sport: UITableViewCell {
    
    @IBOutlet weak var sport: UITextField!
    
}

class ZdravotniStav: UITableViewCell {
    
    @IBOutlet weak var zdravotniStav: UILabel!
    
}

//MARK: - 2. Zabezpeceni prijmu

class ChceResitZabezpeceniPrijmu: UITableViewCell {
    
    @IBOutlet weak var switcher: UISwitch!
}

class PracovniPomer: UITableViewCell {
    
    @IBOutlet weak var pracovniPomer: UILabel!
    
}

class Prijmy: UITableViewCell {
    
    @IBOutlet weak var prijem: UITextField!
    
    @IBOutlet weak var denniPrijem: UILabel!
}

class Vydaje: UITableViewCell {
    
    @IBOutlet weak var vydaje: UITextField!
    
    @IBOutlet weak var denniVydaje: UILabel!
}

class Uver: UITableViewCell {
    
    @IBOutlet weak var uver: UILabel!
    
    @IBOutlet weak var uverCastka: UITextField!
    
    @IBOutlet weak var dluznaCastka: UITextField!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var rokFixace: UILabel!
    
}

class ZabezpeceniPrijmu: UITableViewCell {
    
    @IBOutlet weak var zabezpeceniPrijmu: UITextField!
    
}

class ZabezpeceniPrijmuPoznamky: UITableViewCell {
    
    @IBOutlet weak var zabezpeceniPrijmuPoznamky: UITextView!
    
}


//MARK: - 3. Bydleni

class ChceResitBydleni: UITableViewCell {
    
    @IBOutlet weak var switcher: UISwitch!
    
}

class BytCiDum: UITableViewCell {
    
    @IBOutlet weak var bytCiDum: UILabel!
    
}

class VlastniCiNajemni: UITableViewCell {
    
    @IBOutlet weak var vlastniCiNajemni: UILabel!
    
    @IBOutlet weak var najemne: UITextField!
    
}

class PropocetNajmu: UITableViewCell {
    
    @IBOutlet weak var propocetNajmuPopisek: UILabel!
    
    @IBOutlet weak var propocetNajmuVysledek: UILabel!
    
}

class SpokojenostSNemovitosti: UITableViewCell{
    
    @IBOutlet weak var spokojenostSBydlenim: UILabel!
    
    @IBOutlet weak var poznamky: UITextView!
}

class PlanujeVetsi: UITableViewCell {
    
    @IBOutlet weak var planujeVetsi: UILabel!
}

class ZajisteniBydleni: UITableViewCell {
    
    @IBOutlet weak var zajisteniBydleni: UITextField!
    
}

class ProgramPredcasnehoSplaceni: UITableViewCell {
    
    
}

class ZajisteniBydleniPoznamky: UITableViewCell {
    
    @IBOutlet weak var zajisteniBydleniPoznamky: UITextView!
}


//MARK: - 4. Deti

class ChceResitDeti: UITableViewCell {
    
    @IBOutlet weak var switcher: UISwitch!
}

class mateDeti: UITableViewCell {
    
    @IBOutlet weak var mateDeti: UILabel!
    
    @IBOutlet weak var otazka1: UILabel!
    
    @IBOutlet weak var otazka2: UILabel!
    
}

class planujeteDeti: UITableViewCell {
    
    @IBOutlet weak var planujeteDeti: UILabel!
    
}

class kolikDeti: UITableViewCell {
    
    @IBOutlet weak var kolikDeti: UITextField!
    
}

class diteJmeno: UITableViewCell {
    
    @IBOutlet weak var diteJmeno: UITextField!
    
}

class diteSporeni: UITableViewCell {
    
    @IBOutlet weak var diteLabel: UILabel!
    
}

class detiMesicniPlatba: UITableViewCell {
    
    @IBOutlet weak var mesicniPlatbaTextField: UITextField!
    @IBOutlet weak var mesicniPlatbaStepper: UIStepper!
    @IBOutlet weak var mesicniPlatbaSlider: UISlider!
    
}

class detiDoba: UITableViewCell {
    
    @IBOutlet weak var dobaTextField: UITextField!
    @IBOutlet weak var dobaStepper: UIStepper!
    @IBOutlet weak var dobaSlider: UISlider!
    
}

class rocniUrok: UITableViewCell {
    
    @IBOutlet weak var urokTextField: UITextField!
    @IBOutlet weak var urokStepper: UIStepper!
    @IBOutlet weak var urokSlider: UISlider!
    
}

class detiLabels: UITableViewCell {
    
    @IBOutlet weak var celkemNasporenoLabel: UILabel!
    @IBOutlet weak var vyplacenyUrokLabel: UILabel!
    
}

class DetiVynalozenaCastka: UITableViewCell {
    
    @IBOutlet weak var detiVynalozenaCastka: UITextField!
    
}

class DetiPoznamky: UITableViewCell {
    
    @IBOutlet weak var detiPoznamky: UITextView!
    
}


//MARK: - 5. Duchod

class ChceResitDuchod: UITableViewCell {
    
    @IBOutlet weak var switcher: UISwitch!
    
}

class PredstavaDuchodu: UITableViewCell {
    
    @IBOutlet weak var predstavaDuchodu: UITextField!
}

class PripravaNaDuchod: UITableViewCell {
    
    @IBOutlet weak var pripravaNaDuchod: UILabel!
    
    @IBOutlet weak var predstavovanaCastka: UITextField!
    
}

class JakDlouho: UITableViewCell {
    
    @IBOutlet weak var jakDlouho: UITextField!
}

class ChtelBysteSePripravit: UITableViewCell {
    
    @IBOutlet weak var chtelBysteSePripravit: UILabel!
}

class DuchodVynalozenaCastka: UITableViewCell {
    
    @IBOutlet weak var duchodVynalozenaCastka: UITextField!
}

class DuchodPoznamky: UITableViewCell {
    
    @IBOutlet weak var duchodPoznamky: UITextView!
}


//MARK: - 6. danove ulevy a statni dotace

class ChceteResitDane: UITableViewCell {
    
    @IBOutlet weak var switcher: UISwitch!
    
}

class DanePoznamky: UITableViewCell {
    
    @IBOutlet weak var danePoznamky: UITextView!
}

//MARK: - 7. Ostatni pozadavky

class OstatniPozadavky: UITableViewCell {
    
    @IBOutlet weak var ostatniPozadavky: UITextView!
}

//MARK: - 8. priority

class Priority: UITableViewCell {
    
    @IBOutlet weak var polozka: UILabel!
}

//MARK: - 9. shrnuti

class CelkovePrijmyDomacnosti: UITableViewCell {
    
    @IBOutlet weak var celkovePrijmyDomacnosti: UILabel!

}

class CelkoveVydajeDomacnosti: UITableViewCell {
    
    @IBOutlet weak var celkoveVydajeDomacnosti: UILabel!
    
}

class RozdilMeziPrijmyAVydaji: UITableViewCell {
    
    @IBOutlet weak var rozdilMeziPrijmyAVydaji: UILabel!

}

class CelkovaCastkaNaProjekt: UITableViewCell {
    
    @IBOutlet weak var celkovaCastkaNaProjekt: UILabel!

}

class PulkaRozdilu: UITableViewCell {
    
    @IBOutlet weak var pulkaRozdilu: UILabel!

}

class RealnaCastkaNaProjekt: UITableViewCell {
    
    @IBOutlet weak var realnaCastkaNaProjekt: UITextField!

}

class CastkaNaPredmet: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var castka: UILabel!
}

class OstatniPozadavkyRekapitulace: UITableViewCell {
    
    @IBOutlet weak var ostatniPozadavkyRekapitulace: UITextView!

}

class PriorityRekapitulace: UITableViewCell {
    
    @IBOutlet weak var priority: UILabel!
}

class ExportDoEmailu: UITableViewCell {
    
    
}
