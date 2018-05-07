//
//  PPSCell.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 03.12.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import Foundation
import UIKit

class PPSTableCell: UITableViewCell {
    
    @IBOutlet weak var grafSwitch: UISwitch!
    
    @IBOutlet weak var uverCastkaTextField: UITextField!
    @IBOutlet weak var uverCastkaStepper: UIStepper!
    @IBOutlet weak var uverCastkaSlider: UISlider!
    
    @IBOutlet weak var uverDobaTextField: UITextField!
    @IBOutlet weak var uverDobaStepper: UIStepper!
    @IBOutlet weak var uverDobaSlider: UISlider!
    
    @IBOutlet weak var uverUrokTextField: UITextField!
    @IBOutlet weak var uverUrokStepper: UIStepper!
    @IBOutlet weak var uverUrokSlider: UISlider!
    
    @IBOutlet weak var sporeniMesicniPlatbaTextField: UITextField!
    @IBOutlet weak var sporeniMesicniPlatbaStepper: UIStepper!
    @IBOutlet weak var sporeniMesicniPlatbaSlider: UISlider!
    
    @IBOutlet weak var sporeniDobaTextField: UITextField!
    @IBOutlet weak var sporeniDobaStepper: UIStepper!
    @IBOutlet weak var sporeniDobaSlider: UISlider!
    
    @IBOutlet weak var sporeniUrokTextField: UITextField!
    @IBOutlet weak var sporeniUrokStepper: UIStepper!
    @IBOutlet weak var sporeniUrokSlider: UISlider!
    
    @IBOutlet weak var resultLabel: UILabel!
    
}

class PPSCell: UITableViewCell {
    
    @IBOutlet weak var graphView: JBLineChartView!
    
    //castka napravo od grafu
    @IBOutlet weak var castka1: UILabel!
    @IBOutlet weak var castka2: UILabel!
    @IBOutlet weak var castka3: UILabel!
    @IBOutlet weak var castka4: UILabel!
    
    //roky pod grafem
    @IBOutlet weak var roky1: UILabel!
    @IBOutlet weak var roky2: UILabel!
    @IBOutlet weak var roky3: UILabel!
    @IBOutlet weak var roky4: UILabel!
    
    @IBOutlet weak var jistinaKolecko: UIView!
    @IBOutlet weak var urokKolecko: UIView!
    
    @IBOutlet weak var informationLabel: UILabel!
    
}

class PPSTabulkaCell: UITableViewCell {
    
    @IBOutlet weak var rokyLabel: UILabel!
    @IBOutlet weak var jistinaLabel: UILabel!
    @IBOutlet weak var urokyLabel: UILabel!
}