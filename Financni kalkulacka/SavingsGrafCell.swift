//
//  SavingsGraphCell.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 01.12.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import Foundation
import UIKit

class SavingsCell: UITableViewCell {
    
    @IBOutlet weak var grafSwitch: UISwitch!
    
    @IBOutlet weak var mesicniPlatbaTextField: UITextField!
    @IBOutlet weak var mesicniPlatbaStepper: UIStepper!
    @IBOutlet weak var mesicniPlatbaSlider: UISlider!
    
    @IBOutlet weak var dobaTextField: UITextField!
    @IBOutlet weak var dobaStepper: UIStepper!
    @IBOutlet weak var dobaSlider: UISlider!
    
    @IBOutlet weak var urokTextField: UITextField!
    @IBOutlet weak var urokStepper: UIStepper!
    @IBOutlet weak var urokSlider: UISlider!
    
    @IBOutlet weak var celkemNasporenoLabel: UILabel!
    @IBOutlet weak var vyplacenyUrokLabel: UILabel!
    
}

class SavingsGrafCell: UITableViewCell {
    
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
    
    @IBOutlet weak var celkemNasporenoKolecko: UIView!
    @IBOutlet weak var urokKolecko: UIView!
    
    @IBOutlet weak var informationLabel: UILabel!
    
}

class SavingsTabulkaCell: UITableViewCell {
    
    @IBOutlet weak var rokyLabel: UILabel!
    @IBOutlet weak var celkemNasporenoLabel: UILabel!
    @IBOutlet weak var urokyLabel: UILabel!
}