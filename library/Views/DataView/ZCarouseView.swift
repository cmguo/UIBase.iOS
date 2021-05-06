//
//  ZCarouseView.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/6.
//

import Foundation

@objc public protocol ZCarouseViewDataSource {
    
    func numberOfItems(in carouseView: ZCarouseView) -> Int
    @objc optional func carouseView(_ carouseView: ZCarouseView, textForItemAt index: Int) -> String
    func carouseView(_ carouseView: ZCarouseView, imageForItemAt index: Int) -> UIImage

}

public protocol ZCarouseViewDelegate : FSPagerViewDelegate {
    
}

public class ZCarouseView : FSPagerView {
    
    open weak var dataSource2: ZCarouseViewDataSource? = nil {
        didSet {
            _dataSource = dataSource2 == nil ? nil : ZFSPagerViewDataSource(dataSource2!)
            super.dataSource = _dataSource
            super.isInfinite = isInfinite // reload
        }
    }
    
    open weak var delegate2: ZCarouseViewDelegate? {
        didSet {
            super.delegate = delegate2
        }
    }
    
    public enum SlideDirection: Int, RawRepresentable, CaseIterable {
        case Horizontal
        case Vertical
    }
    
    open var slideDirection: SlideDirection {
        get { SlideDirection(rawValue: scrollDirection.rawValue)! }
        set { scrollDirection = ScrollDirection(rawValue: newValue.rawValue)! }
    }
    
    open var slideInterval: CGFloat {
        get { automaticSlidingInterval }
        set { automaticSlidingInterval = newValue }
    }
    
    open override var itemSize: CGSize {
        didSet {}
    }
    
    open var itemSpacing: CGFloat {
        get { interitemSpacing }
        set { interitemSpacing = newValue }
    }
    
    open var manualSlidable: Bool {
        get { isScrollEnabled }
        set { isScrollEnabled = newValue }
    }
    
    open var cyclic: Bool {
        get { isInfinite }
        set { isInfinite = newValue }
    }
    
    public enum SlideAnimType: Int, RawRepresentable, CaseIterable {
        case CrossFading
        case ZoomOut
        case Depth
        case Overlap
        case Linear
        case CoverFlow
        case FerrisWheel
        case InvertedFerrisWheel
        case Cubic
    }
    
    open var slideAnimType: SlideAnimType? = nil {
        didSet {
            transformer = slideAnimType == nil ? nil : FSPagerViewTransformer(type: FSPagerViewTransformerType(rawValue: slideAnimType!.rawValue)!)
        }
    }
    
    /* private properties */
    
    private var _dataSource: FSPagerViewDataSource? = nil
    
    public init(style: ZCarouseViewStyle = .init()) {
        super.init(frame: .zero)
        super.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "ZCarouseView")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class ZFSPagerViewDataSource : NSObject, FSPagerViewDataSource {
    
    private let dataSource: ZCarouseViewDataSource
    
    init(_ dataSource: ZCarouseViewDataSource) {
        self.dataSource = dataSource
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return dataSource.numberOfItems(in: pagerView as! ZCarouseView)
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "ZCarouseView", at: index)
        let image = dataSource.carouseView(pagerView as! ZCarouseView, imageForItemAt: index)
        cell.imageView?.image = image
        if let text = dataSource.carouseView?(pagerView as! ZCarouseView, textForItemAt: index) {
            cell.textLabel?.text = text
        }
        return cell
    }
    
}
