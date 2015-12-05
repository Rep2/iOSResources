//
//  CellModel.swift
//  Surveys
//
//  Created by Rep on 11/4/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import UIKit

class CellModel{
    
    /// Basic cell identifiers
    
    /// Identifier used to create cell instance
    let cellIdentifier:String
    
    /// Height of the cell
    let height:CGFloat
    
    /// Accessory type
    var accessoryType:UITableViewCellAccessoryType
    
    
    /// Cell update
    
    /// Data used to populate cell instance. Needs to be set as it used on every will display cell.
    var data:[CellElementIdentifiers:Any]
    
    /// Cell implementation function used to update it
    var cellUpdateFunc:([CellElementIdentifiers:Any] -> Void)?
    
    /// Sets data and updates cell
    func setDataAndUpdateCell(data:[CellElementIdentifiers:Any]){
        self.data = data
        
        if let cellUpdateFunc = cellUpdateFunc{
            cellUpdateFunc(data)
        }
    }
    
    
    /// Post init
    
    /// Any custom initis
    var postInit:((UITableViewCell)->Void)?
    func setPostInitFunc(postInit:((cell:UITableViewCell)->Void)?){
        self.postInit = postInit
    }
    
    
    /// Cell events
    
    var didSelectCellFunc:(() -> Void)?
    
    var cellEventHandler:((Any?) -> Void)?
    
    init(cellIdentifier:String, height:CGFloat = 44, accessoryType:UITableViewCellAccessoryType = .None, data:[CellElementIdentifiers:Any] = [:], postInit:((UITableViewCell)->Void)? = nil, didSelectCellFunc:(()->Void)? = nil, cellEventHandler:((Any?) -> Void)? = nil){
        self.cellIdentifier = cellIdentifier
        self.height = height
        self.accessoryType = accessoryType
        
        self.data = data
        self.postInit = postInit
        
        self.didSelectCellFunc = didSelectCellFunc
        self.cellEventHandler = cellEventHandler
    }
}

class CellSection{
    let title:String?
    var cells:[CellModel]
    
    init(title:String?, cells:[CellModel]){
        self.title = title
        self.cells = cells
    }
}