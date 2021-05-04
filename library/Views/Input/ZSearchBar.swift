//
//  ZSearchBar.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/4.
//

import Foundation

public class ZSearchBar : UISearchBar
{
    
    public override var delegate: UISearchBarDelegate? {
        didSet {
            _delegate.delegate = delegate
            super.delegate = oldValue
        }
    }

    private let _style: ZSearchBarStyle
    private let _delegate = ZSearchBarDelegate()
    
    public init(style: ZSearchBarStyle = .init()) {
        _style = style
        super.init(frame: .zero)
        super.viewStyle = style
        super.delegate = _delegate
        
        placeholder = "搜索"
        searchBarStyle = .prominent
        if let tf = subview(ofType: UITextField.self) {
            tf.textAppearance = style.textAppearance
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

class ZSearchBarDelegate : UISearchBarDelegateWrapper {
    
    public override func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) { // called when text starts editing
        super.searchBarTextDidBeginEditing(searchBar)
        if let sb = searchBar as? ZSearchBar {
            sb.setShowsCancelButton(true, animated: true)
        }
    }
    
    override func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        super.searchBarTextDidEndEditing(searchBar)
        if let sb = searchBar as? ZSearchBar {
            sb.setShowsCancelButton(false, animated: true)
        }
    }
    
    override func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        super.searchBarCancelButtonClicked(searchBar)
        if let sb = searchBar as? ZSearchBar {
            sb.endEditing(true)
            sb.text = ""
        }
    }
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        super.searchBar(searchBar, textDidChange: searchText)
        if let sb = searchBar as? ZSearchBar {
            sb.showsSearchResultsButton = !searchText.isEmpty
        }
    }
    
    override func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        super.searchBarResultsListButtonClicked(searchBar)
    }

}
