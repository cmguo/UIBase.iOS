//
//  XHBCarouseView.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/6.
//

import Foundation

@objc public protocol XHBCarouseViewDataSource {
    
    func numberOfItems(in carouseView: XHBCarouseView) -> Int
    @objc optional func carouseView(_ carouseView: XHBCarouseView, textForItemAt index: Int) -> String
    func carouseView(_ carouseView: XHBCarouseView, imageForItemAt index: Int) -> UIImage

}

@objc public protocol XHBCarouseViewDelegate {
    
    @objc optional func carouseView(_ carouseView: XHBCarouseView, willSlideFrom index: Int)
    @objc optional func carouseView(_ carouseView: XHBCarouseView, didSlideTo index: Int)

}

public class XHBCarouseView : FSPagerView {
    
    open weak var dataSource2: XHBCarouseViewDataSource? = nil {
        didSet {
            _dataSource = dataSource2 == nil ? nil : XHBFSPagerViewDataSource(dataSource2!)
            super.dataSource = _dataSource
            super.isInfinite = isInfinite // reload
            _pageControl.numberOfPages = _dataSource?.numberOfItems(in: self) ?? 0
        }
    }
    
    open weak var delegate2: XHBCarouseViewDelegate? {
        didSet {
            _delegate.delegate = delegate2
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
    
    public enum IndicatorType: Int, RawRepresentable, CaseIterable {
        case Square
        case Circle
    }
    
    open var indicatorColor: StateListColor = .bluegrey_800_selected {
        didSet {
            _pageControl.setStrokeColor(indicatorColor.normalColor(), for: .normal)
            _pageControl.setStrokeColor(indicatorColor.color(for: .selected), for: .selected)
            _pageControl.setFillColor(.clear, for: .normal)
            _pageControl.setFillColor(indicatorColor.color(for: .selected), for: .selected)
        }
    }
    
    open var indicatorSize: CGFloat = 6 {
        didSet {
            _pageControl.itemSpacing = indicatorSize
        }
    }
    
    open var indicatorType: IndicatorType = .Square {
        didSet {
            let path: UIBezierPath = Self.paths[indicatorType.rawValue](indicatorSize)
            _pageControl.setPath(path, for: .normal)
            _pageControl.setPath(path, for: .selected)
        }
    }
    
    public enum IndicatorPosition: Int, RawRepresentable, CaseIterable {
        case Left
        case Center
        case Right
    }
    
    open var indicatorPosition: IndicatorPosition = .Center {
        didSet {
            _pageControl.contentHorizontalAlignment = [.left, .center, .right][indicatorPosition.rawValue]
        }
    }
    
    /* private properties */
    
    private var _dataSource: FSPagerViewDataSource? = nil
    private var _delegate = XHBFSPagerViewDelegate()

    fileprivate let _pageControl = FSPageControl()
    
    private let _style: XHBCarouseViewStyle
    
    public init(style: XHBCarouseViewStyle = .init()) {
        _style = style
        super.init(frame: .zero)
        super.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "XHBCarouseView")
        super.delegate = _delegate
        
        _pageControl.hidesForSinglePage = true
        addSubview(_pageControl)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        _pageControl.frame = bounds.bottomCenterPart(ofSize: CGSize(width: bounds.width, height: 16))
    }
}


class XHBFSPagerViewDataSource : NSObject, FSPagerViewDataSource {
    
    private let dataSource: XHBCarouseViewDataSource
    
    init(_ dataSource: XHBCarouseViewDataSource) {
        self.dataSource = dataSource
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return dataSource.numberOfItems(in: pagerView as! XHBCarouseView)
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "XHBCarouseView", at: index)
        let image = dataSource.carouseView(pagerView as! XHBCarouseView, imageForItemAt: index)
        cell.imageView?.image = image
        if let text = dataSource.carouseView?(pagerView as! XHBCarouseView, textForItemAt: index) {
            cell.textLabel?.text = text
        }
        return cell
    }
    
}

class XHBFSPagerViewDelegate : NSObject, FSPagerViewDelegate {
    
    var delegate: XHBCarouseViewDelegate? = nil
    
    func pagerViewWillBeginDragging(_ pagerView: FSPagerView) {
        delegate?.carouseView?(pagerView as! XHBCarouseView, willSlideFrom: pagerView.currentIndex)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        if let carouseView = pagerView as? XHBCarouseView {
            carouseView._pageControl.currentPage = pagerView.currentIndex
            delegate?.carouseView?(carouseView, didSlideTo: pagerView.currentIndex)
        }
    }
    
}


extension XHBCarouseView {
    
    static let square: (_ size: CGFloat) -> UIBezierPath = { size in
        return UIBezierPath(rect: CGRect(x: 0, y: 0, width: size, height: size))
    }
    
    static let circle: (_ size: CGFloat) -> UIBezierPath = { size in
        return UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size, height: size))
    }
    
    static let paths = [square, circle]
}
