//
//  ZCarouselView.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/6.
//

import Foundation
import FSPagerView

@objc public protocol ZCarouselViewDataSource : NSObjectProtocol {
    
    func numberOfItems(in carouselView: ZCarouselView) -> Int
    @objc optional func carouselView(_ carouselView: ZCarouselView, textForItemAt index: Int) -> String
    func carouselView(_ carouselView: ZCarouselView, imageForItemAt index: Int) -> UIImage

}

@objc public protocol ZCarouselViewDelegate : NSObjectProtocol {
    
    @objc optional func carouselView(_ carouselView: ZCarouselView, willSlideFrom index: Int)
    @objc optional func carouselView(_ carouselView: ZCarouselView, didSlideTo index: Int)

}

public class ZCarouselView : UIView {
    
    open weak var dataSource2: ZCarouselViewDataSource? = nil {
        didSet {
            _dataSource = dataSource2 == nil ? nil : ZFSPagerViewDataSource(dataSource2!)
            _pagerView.dataSource = _dataSource
            _pagerView.isInfinite = _pagerView.isInfinite // reload
            _pageControl.numberOfPages = _dataSource?.numberOfItems(in: _pagerView) ?? 0
        }
    }
    
    open weak var delegate2: ZCarouselViewDelegate? {
        didSet {
            _delegate.delegate = delegate2
        }
    }
    
    public enum SlideDirection: Int, RawRepresentable, CaseIterable {
        case Horizontal
        case Vertical
    }
    
    open var slideDirection: SlideDirection {
        get { SlideDirection(rawValue: _pagerView.scrollDirection.rawValue)! }
        set { _pagerView.scrollDirection = FSPagerView.ScrollDirection(rawValue: newValue.rawValue)! }
    }
    
    open var slideInterval: CGFloat {
        get { _pagerView.automaticSlidingInterval }
        set { _pagerView.automaticSlidingInterval = newValue }
    }
    
    open var itemSize: CGSize {
        get { _pagerView.itemSize }
        set { _pagerView.itemSize = itemSize }
    }
    
    open var itemSpacing: CGFloat {
        get { _pagerView.interitemSpacing }
        set { _pagerView.interitemSpacing = newValue }
    }
    
    open var manualSlidable: Bool {
        get { _pagerView.isScrollEnabled }
        set { _pagerView.isScrollEnabled = newValue }
    }
    
    open var cyclic: Bool {
        get { _pagerView.isInfinite }
        set { _pagerView.isInfinite = newValue }
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
            _pagerView.transformer = slideAnimType == nil ? nil : FSPagerViewTransformer(type: FSPagerViewTransformerType(rawValue: slideAnimType!.rawValue)!)
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
    
    private let _pagerView = FSPagerView()
    private var _dataSource: FSPagerViewDataSource? = nil
    private var _delegate = ZFSPagerViewDelegate()

    fileprivate let _pageControl = FSPageControl()
    
    private let _style: ZCarouselViewStyle
    
    public init(style: ZCarouselViewStyle = .init()) {
        _style = style
        super.init(frame: .zero)
        _pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "ZCarouselView")
        _pagerView.delegate = _delegate
        addSubview(_pagerView)

        _pageControl.hidesForSinglePage = true
        addSubview(_pageControl)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        _pagerView.frame = bounds
        _pageControl.frame = bounds.bottomCenterPart(ofSize: CGSize(width: bounds.width, height: 16))
    }
}


class ZFSPagerViewDataSource : NSObject, FSPagerViewDataSource {
    
    private let dataSource: ZCarouselViewDataSource
    
    init(_ dataSource: ZCarouselViewDataSource) {
        self.dataSource = dataSource
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return dataSource.numberOfItems(in: pagerView.superview as! ZCarouselView)
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "ZCarouselView", at: index)
        let image = dataSource.carouselView(pagerView.superview as! ZCarouselView, imageForItemAt: index)
        cell.imageView?.image = image
        if let text = dataSource.carouselView?(pagerView.superview as! ZCarouselView, textForItemAt: index) {
            cell.textLabel?.text = text
        }
        return cell
    }
    
}

class ZFSPagerViewDelegate : NSObject, FSPagerViewDelegate {
    
    var delegate: ZCarouselViewDelegate? = nil
    
    func pagerViewWillBeginDragging(_ pagerView: FSPagerView) {
        delegate?.carouselView?(pagerView.superview as! ZCarouselView, willSlideFrom: pagerView.currentIndex)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        if let carouselView = pagerView.superview as? ZCarouselView {
            carouselView._pageControl.currentPage = pagerView.currentIndex
            delegate?.carouselView?(carouselView, didSlideTo: pagerView.currentIndex)
        }
    }
    
}


extension ZCarouselView {
    
    static let square: (_ size: CGFloat) -> UIBezierPath = { size in
        return UIBezierPath(rect: CGRect(x: 0, y: 0, width: size, height: size))
    }
    
    static let circle: (_ size: CGFloat) -> UIBezierPath = { size in
        return UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size, height: size))
    }
    
    static let paths = [square, circle]
}
