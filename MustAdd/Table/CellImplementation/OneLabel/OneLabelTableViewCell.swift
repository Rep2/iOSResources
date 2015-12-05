    //
//  File.swift
//  Surveys
//
//  Created by Rep on 11/4/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import UIKit

// One label cell implementation
class OneLabelTableViewCell:GenericCellImplementation{

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    
    override func initElements(){
        elements[CellElementIdentifiers.FirstLabel] = firstLabel
    }

}

