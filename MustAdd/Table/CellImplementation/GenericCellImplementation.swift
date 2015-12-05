//
//  GenericCellImplementation.swift
//  Surveys
//
//  Created by Rep on 11/4/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import UIKit

// Enumeration containing identifiers of all registered cells
enum CellIdentifiers:String{
    case OneLabelBasic = "OneLabelTableViewCell"
    case TwoLabelRightDetail = "TwoLabelLeftInfoCellImplementation"
    
    case OneLabelImageBasic = "SingleLabelWithImageCell"
    case SubtitelWithImage = "SubtitelWithImageCell"
}

enum CellElementIdentifiers:String{
    case FirstLabel = "firstLabel"
    case SecondLabel = "secondLabel"
    
    case FirstImage = "firstImage"
}

// Generic cell implementation
class GenericCellImplementation:UITableViewCell{

    // Dictionary used to access all cells labels
    var elements:[CellElementIdentifiers:UIView]
    
    required init?(coder aDecoder: NSCoder) {
        elements = [:]
        
        super.init(coder: aDecoder)
    }
    
    // Inits labels dictionary with cell elements
    func initElements(){
    }
    
    // Sets labels text with given data
    // - parameter data: dictionary containing data which is used to init labels
    func setData(data:[CellElementIdentifiers:Any]){
        if elements == [:]{
            initElements()
        }
        
        for (key, value) in data{
            if let element = elements[key]{
                if element is UILabel{
                    (element as! UILabel).text = value as? String ?? ""
                }else if element is UIImageView{
                    if let value = value as? String{
                        (element as! UIImageView).image = UIImage(named: value)
                    }else if let value = value as? UIImage{
        
                        (element as! UIImageView).image = value
                    }
                }
            }
        }
    }
}
