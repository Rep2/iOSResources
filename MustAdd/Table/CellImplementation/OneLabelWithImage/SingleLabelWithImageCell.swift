//
//  SingleLabelWithImageCell.swift
//  Surveys
//
//  Created by Rep on 11/20/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import UIKit

class SingleLabelWithImageCell:GenericCellImplementation{

    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    
    override func initElements(){
        elements[CellElementIdentifiers.FirstLabel] = firstLabel
        elements[CellElementIdentifiers.FirstImage] = firstImage
    }
}