//
//  ListCollectionLayout.swift
//  EducationalProjectIvanRep
//
//  Created by Undabot Rep on 11/07/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import UIKit
import RxSwift

protocol ListLayoutDelegate{
    var contentHeight: CGFloat { get }
    var footerNeeded: Bool { get }
    var numberOfItems: Int { get }
    
    func heightForItemAtIndex(index: Int) -> CGFloat
    func footerNeededObserver() -> Observable<Bool>
}

class ListCollectionLayout: AttributesCollectionLayout{
    
    var delegate: ListLayoutDelegate!
    
    var heights = [CGFloat]()
    
    var width: CGFloat{
        return collectionView!.bounds.size.width
    }
    
    let headerHeight:CGFloat = 200
    
    var headerAttribute: UICollectionViewLayoutAttributes!
    var footerAttribute: UICollectionViewLayoutAttributes!
    
    
    init(scrollDirection: UICollectionViewScrollDirection, delegate: ListLayoutDelegate){
        self.delegate = delegate
        
        super.init(scrollDirection: scrollDirection)
        
        observeFooter()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.delegate = nil
        
        super.init(coder: aDecoder)
    }
    
    func setDelegate(delegate: ListLayoutDelegate){
        self.delegate = delegate
        
        observeFooter()
    }
    
    func firstVisibleItem() -> NSIndexPath?{
        guard delegate.numberOfItems > 0 else { return nil }
        
        var height:CGFloat = 0
        
        for row in 0..<delegate.numberOfItems{
            height += heights[row]
            
            if height > (collectionView!.contentOffset.y + CGFloat(1 * row)){
                return NSIndexPath(forRow: Int(row), inSection: 0)
            }
        }
        
        return NSIndexPath(forRow: Int(delegate.numberOfItems - 1), inSection: 0)
    }
    
    override func prepareLayout() {
        if headerAttribute == nil{
            let index = NSIndexPath(index: 0)
            headerAttribute = headerViewAttribute(CGRect(x: 0, y: -headerHeight, width: width, height: headerHeight), index: index)
        }
        
        if footerAttribute == nil{
            let index = NSIndexPath(index: 1)
            footerAttribute = footerViewAttribute(CGRect(x: 0, y: self.heights.reduce(0, combine: {$0 + $1}), width: self.width, height: 60), index: index)
            footerAttribute.hidden = true
        }
        
         updateAttributes()
    }
    
    override func updateAttributes(){

        let currentCount = attributes.count
        
        for item in currentCount ..< delegate.numberOfItems {
            let indexPath = NSIndexPath(forItem: item, inSection: 0)
            
            let height = delegate.heightForItemAtIndex(item)
            
            let frame = CGRect(x: CGFloat(0), y: heights.reduce(CGFloat(0), combine: {$0 + $1}), width: width, height: height)
            
            heights.append(height)
            
            let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            attribute.frame = frame
            attributes[indexPath] = attribute
        }
        
        footerAttribute.frame = CGRect(x: 0, y: self.heights.reduce(0, combine: {$0 + $1}), width: self.width, height: 60)
        footerAttribute.indexPath = NSIndexPath(forRow: delegate.numberOfItems, inSection: 0)
    }
    
    let disposeBag = DisposeBag()
    
    func observeFooter(){
        delegate.footerNeededObserver()
            .subscribeNext { (footerNeeded) in
                if let footerAttribute = self.footerAttribute{
                    footerAttribute.hidden = !footerNeeded
                }
        }.addDisposableTo(disposeBag)
    }
    
    override func collectionViewContentSize() -> CGSize {
        return  CGSize(width: width, height: delegate.contentHeight)
    }
    
    override func aditionalAttributes() -> [UICollectionViewLayoutAttributes?]{
        return [headerAttribute, footerAttribute]
    }
    
    override func resetAttributes(){
        super.resetAttributes()
        
        heights.removeAll()
    }
}
