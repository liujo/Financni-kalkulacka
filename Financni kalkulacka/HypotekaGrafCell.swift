//
//  GrafCell.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 30.11.15.
//  Copyright © 2015 Joseph Liu. All rights reserved.
//

import Foundation
import UIKit

class HypoCell: UITableViewCell {
    
    @IBOutlet weak var castkaTextField: UITextField!
    @IBOutlet weak var castkaSlider: UISlider!
    @IBOutlet weak var castkaStepper: UIStepper!
    
    @IBOutlet weak var dobaTextField: UITextField!
    @IBOutlet weak var dobaSlider: UISlider!
    @IBOutlet weak var dobaStepper: UIStepper!
    
    @IBOutlet weak var urokTextField: UITextField!
    @IBOutlet weak var urokSlider: UISlider!
    @IBOutlet weak var urokStepper: UIStepper!
    
    @IBOutlet weak var mesicniPlatbaLabel: UILabel!
    @IBOutlet weak var celkemUrokLabel: UILabel!
    @IBOutlet weak var klientCelkemZaplatiLabel: UILabel!
    
}

class GrafCell: UITableViewCell {
    
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
    
    @IBOutlet weak var jistinaView: UIView!
    @IBOutlet weak var urokView: UIView!
    
    @IBOutlet weak var informationLabel: UILabel!

}

class TabulkaCell: UITableViewCell {
    
    @IBOutlet weak var rokyLabel: UILabel!
    @IBOutlet weak var jistinaLabel: UILabel!
    @IBOutlet weak var urokyLabel: UILabel!
    
}
