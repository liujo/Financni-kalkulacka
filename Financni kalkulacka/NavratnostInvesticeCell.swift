//
//  NavratnostInvesticeCell.swift
//  Financni kalkulacka
//
//  Created by Joseph Liu on 13.05.16.
//  Copyright © 2016 Joseph Liu. All rights reserved.
//

import UIKit

class NavratnostCell: UITableViewCell {
    
    @IBOutlet weak var cenaTextField: UITextField!
    @IBOutlet weak var cenaStepper: UIStepper!
    @IBOutlet weak var cenaSlider: UISlider!
    
    @IBOutlet weak var mesicniPrijemTextField: UITextField!
    @IBOutlet weak var mesicniPrijemStepper: UIStepper!
    @IBOutlet weak var mesicniPrijemSlider: UISlider!
    
    @IBOutlet weak var nakladyTextField: UITextField!
    @IBOutlet weak var nakladyStepper: UIStepper!
    @IBOutlet weak var nakladySlider: UISlider!
    
    @IBOutlet weak var zhodnoceniLabel: UILabel!
    @IBOutlet weak var navratnostLabel: UILabel!
    
}