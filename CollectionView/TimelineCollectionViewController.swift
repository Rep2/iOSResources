//
//  ViewController.swift
//  EducationalProjectIvanRep
//
//  Created by Undabot Rep on 04/07/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import UIKit
import RxSwift
import CBStoreHouseRefreshControl

protocol TimelineCollectionDelegate: ListLayoutDelegate, PagerLayoutDelegate {
    var numberOfItems: Int { get }
    
    func itemForIndex(index: Int) -> TweetSummary
}

enum CollectionCellTypes: String{
    case ListLayout = "TweetViewListLayoutCollectionCell"
    case PagerLayout = "TweetViewPagerLayoutCollectionCell"
    
    static func changeLayout(layout: CollectionCellTypes) -> CollectionCellTypes{
        switch layout{
        case .ListLayout:
            return .PagerLayout
        case .PagerLayout:
            return .ListLayout
        }
    }
    
    func layout(presenter: TimelineCollectionDelegate) -> UICollectionViewLayout{
        switch self{
        case .ListLayout:
            return ListCollectionLayout(scrollDirection: .Horizontal, delegate: presenter)
        case .PagerLayout:
            return PageCollectionLayout(scrollDirection: .Vertical, delegate: presenter)
        }
    }
    
    func scrollPosition() -> UICollectionViewScrollPosition{
        switch self{
        case .ListLayout:
            return .Top
        case .PagerLayout:
            return .Left
        }
    }
}

class TimelineCollectionViewController: UIViewController{
 
    @IBOutlet weak var collectionView: UICollectionView!
    
    static var tweets = [TweetSummary]()
    
    var eventHandler: TimelineEventHander!
    
    var currentLayout = CollectionCellTypes.ListLayout
    
    var leftButton: UIBarButtonItem!
    var activityIndicator: CBStoreHouseRefreshControl!
    var initialActivityIndicator: CBStoreHouseRefreshControl!
    
    var scrollIsAnimationg = false
    
    func setEventHandler(eventHandler: TimelineEventHander){
        self.eventHandler = eventHandler
    }
    
    var delegate: TimelineCollectionDelegate!
    func setDelegte(delegate: TimelineCollectionDelegate){
        self.delegate = delegate
    }
    
    let disposeBag = DisposeBag()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (collectionView.collectionViewLayout as! ListCollectionLayout).setDelegate(delegate)
        
        delegate.footerNeededObserver().subscribeNext { _ in
            let context = UICollectionViewFlowLayoutInvalidationContext()
            context.invalidateFlowLayoutDelegateMetrics = true
            
            self.collectionView.collectionViewLayout.invalidateLayoutWithContext(context)
        }.addDisposableTo(disposeBag)
        
        leftButton = UIBarButtonItem(image: UIImage(named: "RefreshWhite"), style: .Plain, target: self, action: #selector(TimelineCollectionViewController.changeLayout))
        navigationItem.leftBarButtonItem = leftButton
        
        collectionView.registerNib(UINib(nibName: "CollectionViewHeader", bundle: nil), forSupplementaryViewOfKind: "ActivityIndicator", withReuseIdentifier: "CollectionViewHeader")
   
        collectionView.registerNib(UINib(nibName: "ActivityIndicatorFooter", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "ActivityIndicatorFooter")
   
        initActivityIndicator()
    }
    
    func initActivityIndicator(){
        let activityIndicatorWidth:CGFloat = 200.0
        
        initialActivityIndicator = CBStoreHouseRefreshControl.attachToScrollView(collectionView, target: self, refreshAction: nil, plist: "undabot", point: CGPoint(x: (view.bounds.size.width - activityIndicatorWidth)/2.0, y: view.bounds.size.height/2 - 120))
        
        initialActivityIndicator.scrollViewDidScroll(-(activityIndicatorWidth/2 + 1.0))
        initialActivityIndicator.scrollViewDidEndDragging(-(activityIndicatorWidth/2 + 1.0))
        
        collectionView.backgroundView = initialActivityIndicator
    }
    
    func pullToRefreshStarted(){
        eventHandler.updateTimeline()
    }
    
    func changeLayout(){
        currentLayout = CollectionCellTypes.changeLayout(currentLayout)
        let layout = currentLayout.layout(delegate)
        
        let index = firstVisibleRowIndex()
        
        self.collectionView.alwaysBounceVertical = currentLayout == .ListLayout
        self.collectionView.alwaysBounceHorizontal = currentLayout == .PagerLayout
        
        leftButton.enabled = false
        collectionView.performBatchUpdates({
            if let index = index{
                self.collectionView.reloadItemsAtIndexPaths([index])
            }
            
            self.collectionView.setCollectionViewLayout(layout, animated: false)
            
            if let index = index{
                self.collectionView.scrollToItemAtIndexPath(index, atScrollPosition: self.currentLayout.scrollPosition(), animated: false)
            }
            
            self.collectionView.pagingEnabled = self.currentLayout == .PagerLayout
       
            }, completion: { completed in
                self.leftButton.enabled = true
        })
    }
    
    func firstVisibleRowIndex() -> NSIndexPath?{
        var index = collectionView.indexPathsForVisibleItems().first
        
        if let controller = collectionView.collectionViewLayout as? ListCollectionLayout{
            index = controller.firstVisibleItem()
        }
        
        return index
    }
    
    func updateImage(image: UIImage, atRow: Int){
        if atRow < delegate.numberOfItems{
            if let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: atRow, inSection: 0)) as? TweetViewCollectionCell{
                cell.setImage(image)
            }
        }
    }
    
    func setData(tweets: [TweetSummary]){
        (collectionView.collectionViewLayout as! AttributesCollectionLayout).resetAttributes()
        collectionView.reloadData()
        
        endAnimation()
    }
    
    func endAnimation(){
        if activityIndicator == nil{
            initialActivityIndicator.removeFromSuperview()
            initialActivityIndicator.hidden = true
            activityIndicator = CBStoreHouseRefreshControl.attachToScrollView(collectionView, target: self, refreshAction: #selector(TimelineCollectionViewController.pullToRefreshStarted), plist: "undabot", point: CGPoint(x: 0, y: 0))
        }
        
        let offset = currentLayout == .ListLayout ? collectionView.contentOffset.y : collectionView.contentOffset.x
        
        if offset < 0 && !collectionView.dragging{
            collectionView.setContentOffset(
                currentLayout == .ListLayout ? CGPoint(x: collectionView.contentOffset.x, y: 0) : CGPoint(x: 0, y: collectionView.contentOffset.y), animated: true)
        }
        
        activityIndicator.finishingLoading()
    }
}

// UICollectionView
extension TimelineCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
   
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(currentLayout.rawValue, forIndexPath: indexPath)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = cell as? TweetViewCollectionCell{
            cell.setData(delegate.itemForIndex(indexPath.row))
        }
        
        if indexPath.row > delegate.numberOfItems - 3{
            eventHandler.collectionViewNearBottom()
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate.numberOfItems
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var reusableView:UICollectionReusableView
        
        if kind == UICollectionElementKindSectionFooter{
            reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "ActivityIndicatorFooter", forIndexPath: indexPath)
        }else{
            reusableView = collectionView.dequeueReusableSupplementaryViewOfKind("ActivityIndicator", withReuseIdentifier: "CollectionViewHeader", forIndexPath: indexPath)
            
            if let activityIndicator = activityIndicator{
                (reusableView as! CollectionViewHeader).bottomView.addSubview(activityIndicator)
            }
            
            // Rotate header view for PagerLayout
            if currentLayout == .PagerLayout{
                reusableView.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI_2))
                reusableView.frame = CGRect(x: -200, y: 0, width: 200, height: collectionView.bounds.size.height/2 + 160)
            }
        }
        
        return reusableView
    }
}

// Pull to refresh animation
extension TimelineCollectionViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = currentLayout == .ListLayout ? scrollView.contentOffset.y : scrollView.contentOffset.x

        if let activityIndicator = activityIndicator{
            activityIndicator.scrollViewDidScroll(offset)
        }
        
        if offset < -100.0 && !scrollView.dragging && !scrollIsAnimationg{
            scrollIsAnimationg = true
            
            scrollView.setContentOffset( currentLayout == .ListLayout ? CGPoint(x: 0, y: -100) : CGPoint(x: -100, y: 0) , animated: true)
            
            if let activityIndicator = activityIndicator{
                activityIndicator.scrollViewDidEndDragging(offset)
            }
            
            delay(0.4, closure: {
                self.scrollIsAnimationg = false
            })
        }
    }
}

