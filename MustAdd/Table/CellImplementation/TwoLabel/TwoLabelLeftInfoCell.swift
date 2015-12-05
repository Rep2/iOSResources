//
//  TwoLabelLeftInfoCell.swift
//  Surveys
//
//  Created by Rep on 11/13/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import UIKit

class TwoLabelLeftInfoCell:GenericCellImplementation{

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var secondLabelRightConstraint: NSLayoutConstraint!
    
    override func initElements(){
        elements[CellElementIdentifiers.FirstLabel] = firstLabel
        elements[CellElementIdentifiers.SecondLabel] = secondLabel
    }    
}