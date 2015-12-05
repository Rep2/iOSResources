//
//  BasicTable.swift
//  Surveys
//
//  Created by Rep on 11/4/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import UIKit

protocol BasicTableEventHandler{
    func didSelectCell(indexPath:NSIndexPath)
}

class BasicTable:UITableView, UITableViewDataSource, UITableViewDelegate{

    var sections:[CellSection]
    var eventHandler:BasicTableEventHandler?
    
    var messageLabel:UILabel!
    
    init(frame:CGRect, sections:[CellSection] = []){
        self.sections = sections
        
        super.init(frame: frame, style: .Grouped)
        
        postInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        sections = []
        
        super.init(coder: aDecoder)
        
        postInit()
    }
    
    func postInit(){
        delegate = self
        dataSource = self
        
        messageLabel = UILabel(frame: CGRectMake(0, 0, bounds.size.width, bounds.size.height))
        
        messageLabel.text = "No data currently available"
        messageLabel.textColor = UIColor.darkGrayColor()
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignment.Center
        messageLabel.font = UIFont(name:"HelveticaNeue", size:14)
        messageLabel.sizeToFit()
    }
    
    // Events
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let eventHandler = eventHandler{
            eventHandler.didSelectCell(indexPath)
        }
        
        if let modelsDidSelect = sections[indexPath.section].cells[indexPath.row].didSelectCellFunc{
            modelsDidSelect()
        }
        
        deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // Data source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = sections[indexPath.section].cells[indexPath.row].cellIdentifier
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        
        if cell == nil{
            tableView.registerNib(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        }
        
        sections[indexPath.section].cells[indexPath.row].cellUpdateFunc = (cell as! GenericCellImplementation).setData
        
        return cell!
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.accessoryType = sections[indexPath.section].cells[indexPath.row].accessoryType
        (cell as! GenericCellImplementation).setData(sections[indexPath.section].cells[indexPath.row].data)
        
        if let postInit = sections[indexPath.section].cells[indexPath.row].postInit{
            postInit(cell)
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    
    var noDataShow:(AnyObject)->Bool = {(sections:AnyObject) -> Bool in
        return (sections as! [CellSection]).count == 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if noDataShow(sections){
            backgroundView = messageLabel
        }else{
            backgroundView = nil
        }
        
        return sections.count
    }
    
    // Section style
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if sections[section].title == nil{
            return 0.001
        }else{
            return 34
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return sections[indexPath.section].cells[indexPath.row].height
        
    }
    

}