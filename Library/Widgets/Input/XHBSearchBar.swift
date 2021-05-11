//
//  XHBSearchBar.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/4.
//

import Foundation

public class XHBSearchBar : UISearchBar
{
    
    public override var placeholder: String? {
        didSet {
            syncOffset()
        }
    }
    
    public override var delegate: UISearchBarDelegate? {
        didSet {
            _delegate.delegate = delegate
            super.delegate = oldValue
        }
    }

    private let _style: XHBSearchBarStyle
    private let _delegate = XHBSearchBarDelegate()
        
    public init(style: XHBSearchBarStyle = .init()) {
        _style = style
        super.init(frame: .zero)
        super.viewStyle = style
        super.delegate = _delegate
        
        placeholder = "搜索"
        searchBarStyle = .prominent
        if let tf = subview(ofType: UITextField.self) {
            tf.textAppearance = style.textAppearance
            tf.layer.cornerRadius = style.cornerRadius
            tf.clipsToBounds = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) {
        super.setShowsCancelButton(showsCancelButton, animated: animated)
        syncOffset(animated: animated)
    }
    
    private var _hasSyncOffset = false
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if !_hasSyncOffset {
            _hasSyncOffset = true
            DispatchQueue.main.async { [weak self] in
                self?.syncOffset()
            }
        }
    }
    
    private func syncOffset(animated: Bool = false) {
        guard let tf = subview(ofType: UITextField.self) else {
            return
        }
        var d = positionAdjustment(for: .search)
        if showsCancelButton {
            d.horizontal = 0
        } else {
            let bounds = tf.bounds
            let l = tf.leftViewRect(forBounds: bounds).left
            let r = tf.placeholderRect(forBounds: bounds).right
            d.horizontal += bounds.centerX - (r + l) / 2
        }
        self.setPositionAdjustment(d, for: .search)
    }
    

}


public class UISearchBarDelegateWrapper : NSObject, UISearchBarDelegate {

    var delegate: UISearchBarDelegate?
    
    @available(iOS 2.0, *)
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool { // return NO to not become first responder
        return delegate?.searchBarShouldBeginEditing?(searchBar) ?? true
    }

    @available(iOS 2.0, *)
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) { // called when text starts editing
        delegate?.searchBarTextDidBeginEditing?(searchBar)
    }

    @available(iOS 2.0, *)
    public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool { // return NO to not resign first responder
        return delegate?.searchBarShouldEndEditing?(searchBar) ?? true
    }

    @available(iOS 2.0, *)
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) { // called when text ends editing
        delegate?.searchBarTextDidEndEditing?(searchBar)
    }

    @available(iOS 2.0, *)
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { // called when text changes (including clear)
        delegate?.searchBar?(searchBar, textDidChange: searchText)
    }

    @available(iOS 3.0, *)
    public func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool { // called before text changes
        return delegate?.searchBar?(searchBar, shouldChangeTextIn: range, replacementText: text) ?? true
    }
    
    @available(iOS 2.0, *)
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { // called when keyboard search button pressed
        delegate?.searchBarSearchButtonClicked?(searchBar)
    }

    @available(iOS 2.0, *)
    public func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) { // called when bookmark button pressed
        delegate?.searchBarBookmarkButtonClicked?(searchBar)
    }
    
    @available(iOS 2.0, *)
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) { // called when cancel button pressed
        delegate?.searchBarCancelButtonClicked?(searchBar)
    }

    @available(iOS 3.2, *)
    public func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) { // called when search results button pressed
        delegate?.searchBarResultsListButtonClicked?(searchBar)
    }
    
    @available(iOS 3.0, *)
    public func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        delegate?.searchBar?(searchBar, selectedScopeButtonIndexDidChange: selectedScope)
    }
}

class XHBSearchBarDelegate : UISearchBarDelegateWrapper {
    
    public override func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) { // called when text starts editing
        super.searchBarTextDidBeginEditing(searchBar)
        if let sb = searchBar as? XHBSearchBar {
            sb.setShowsCancelButton(true, animated: true)
        }
    }
    
    override func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        super.searchBarTextDidEndEditing(searchBar)
        if let sb = searchBar as? XHBSearchBar {
            sb.setShowsCancelButton(false, animated: true)
        }
    }
    
    override func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        super.searchBarCancelButtonClicked(searchBar)
        if let sb = searchBar as? XHBSearchBar {
            sb.endEditing(true)
            sb.text = ""
        }
    }
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        super.searchBar(searchBar, textDidChange: searchText)
        if let sb = searchBar as? XHBSearchBar {
            sb.showsSearchResultsButton = !searchText.isEmpty
        }
    }
    
    override func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        super.searchBarResultsListButtonClicked(searchBar)
    }

}
