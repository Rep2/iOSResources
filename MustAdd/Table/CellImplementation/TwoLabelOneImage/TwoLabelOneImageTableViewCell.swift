//
//  TwoLabelOneImageCellImplementation.swift
//  Surveys
//
//  Created by Rep on 11/4/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import UIKit

// One label cell implementation
class TwoLabelOneImageTableViewCell:GenericCellImplementation{
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var firstImage: UIImageView!
    
    override func initElements(){
        elements[CellElementIdentifiers.FirstLabel] = firstLabel
        elements[CellElementIdentifiers.SecondLabel] = secondLabel
        elements[CellElementIdentifiers.FirstImage] = firstImage
    }
    
}