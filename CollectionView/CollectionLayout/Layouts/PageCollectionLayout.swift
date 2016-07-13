//
//  PageCollectionLayout.swift
//  EducationalProjectIvanRep
//
//  Created by Undabot Rep on 11/07/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import UIKit
import RxSwift

protocol PagerLayoutDelegate{
    var footerNeeded: Bool { get }
    var numberOfItems: Int { get }
    
    func footerHeight() -> CGFloat
    
    func footerNeededObserver() -> Observable<Bool>
}

class PageCollectionLayout: AttributesCollectionLayout{
    
    var height: CGFloat{
        return collectionView!.bounds.size.height
    }
    
    var width: CGFloat{
        return collectionView!.bounds.size.width
    }
    
    let headerWidth:CGFloat = 200
    
    var headerAttribute: UICollectionViewLayoutAttributes!
    var footerAttribute: UICollectionViewLayoutAttributes!
    
    var delegate: PagerLayoutDelegate!
    
    
    init(scrollDirection: UICollectionViewScrollDirection, delegate: PagerLayoutDelegate){
        self.delegate = delegate
        
        super.init(scrollDirection: scrollDirection)
        
        observeFooter()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.delegate = nil
        
        super.init(coder: aDecoder)
    }
    
    func setDelegate(delegate: PagerLayoutDelegate){
        self.delegate = delegate
        
        observeFooter()
    }
    
    override func prepareLayout() {
        if headerAttribute == nil{
            let index = NSIndexPath(index: 0)
            headerAttribute = headerViewAttribute(CGRect(x: -headerWidth, y: 0, width: headerWidth, height: height), index: index)
        }
        
        if footerAttribute == nil{
            let index = NSIndexPath(index: 1)
            footerAttribute = footerViewAttribute(CGRect(x: 0, y: 0, width: 60, height: height), index: index)
            footerAttribute.hidden = true
        }
        
        updateAttributes()
    }
    
    override func updateAttributes(){
        
        let currentCount = attributes.count
        
        for item in currentCount ..< delegate.numberOfItems {
            let indexPath = NSIndexPath(forItem: item, inSection: 0)
            
            let frame = CGRect(x: CGFloat(item) * width, y: 0, width: width, height: height)
            
            let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            attribute.frame = frame
            attributes[indexPath] = attribute
        }
        
        footerAttribute.frame = CGRect(x: width * CGFloat(delegate.numberOfItems), y: 0, width: 60, height: height)
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
        guard collectionView?.numberOfSections() > 0 else { return CGSize(width: 0, height: 0) }
        
        return CGSize(width: CGFloat(delegate.numberOfItems) * width + delegate.footerHeight(), height: height)
    }
    
    override func aditionalAttributes() -> [UICollectionViewLayoutAttributes?]{
        return [headerAttribute, footerAttribute]
    }
}