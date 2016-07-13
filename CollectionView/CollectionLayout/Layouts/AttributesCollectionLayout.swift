//
//  AttributesCollectionLayout.swift
//  EducationalProjectIvanRep
//
//  Created by Undabot Rep on 11/07/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import UIKit

class AttributesCollectionLayout: UICollectionViewFlowLayout{
    
    internal var attributes = [NSIndexPath : UICollectionViewLayoutAttributes]()
    
    init(scrollDirection: UICollectionViewScrollDirection){
        super.init()
        
        self.scrollDirection = scrollDirection
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for (_, attribute) in attributes {
            if CGRectIntersectsRect(attribute.frame, rect) {
                layoutAttributes.append(attribute)
            }
        }
        
        for attribute in aditionalAttributes(){
            if let attribute = attribute{
                if CGRectIntersectsRect(attribute.frame, rect) {
                    layoutAttributes.append(attribute)
                }
            }
        }
        
        return layoutAttributes
    }
    
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes?
    {
        for (_, attribute) in attributes {
            if attribute.indexPath == indexPath {
                return attribute
            }
        }
        
        return nil
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return attributes[NSIndexPath(index: 0)]
    }
    
    func updateAttributes(){
    }
    
    func aditionalAttributes() -> [UICollectionViewLayoutAttributes?]{
        return []
    }
    
    func resetAttributes(){
        attributes.removeAll()
    }
}

func headerViewAttribute(inRect: CGRect, index: NSIndexPath) -> UICollectionViewLayoutAttributes{
    
    let attribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: "ActivityIndicator", withIndexPath: index)
    attribute.frame = inRect
    
    return attribute
}

func footerViewAttribute(inRect: CGRect, index: NSIndexPath) -> UICollectionViewLayoutAttributes{
    
    let attribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withIndexPath: index)
    attribute.frame = inRect
    
    return attribute
}