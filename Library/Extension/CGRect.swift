//
//  CGRect.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/8.
//

import Foundation

extension CGRect {
    
    /* Points, modify points not change size */
    
    public var left: CGFloat {
        get { origin.x }
        set { origin.x = newValue }
    }
    
    public var top: CGFloat {
        get { origin.y }
        set { origin.y = newValue }
    }
    
    public var right: CGFloat {
        get { origin.x + size.width }
        set { origin.x = newValue - size.width }
    }
    
    public var bottom: CGFloat {
        get { origin.y + size.height }
        set { origin.y = newValue - size.height }
    }
    
    public var leftTop: CGPoint {
        get { origin }
        set { origin = newValue }
    }
    
    public var rightTop: CGPoint {
        get { CGPoint(x: origin.x + size.width, y: origin.y) }
        set { left = newValue.x; top = newValue.y }
    }
    
    public var leftBottom: CGPoint {
        get { CGPoint(x: origin.x, y: origin.y + size.height) }
        set { left = newValue.x; bottom = newValue.y }
    }
    
    public var rightBottom: CGPoint {
        get { CGPoint(x: origin.x + size.width, y: origin.y + size.height) }
        set { right = newValue.x; bottom = newValue.y }
    }
    
    public var center: CGPoint {
        get { CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2) }
        set { origin = CGPoint(x: newValue.x - size.width / 2, y: newValue.y - size.height / 2) }
    }
    
    public var centerX: CGFloat {
        get { origin.x + size.width / 2 }
        set { origin.x = newValue - size.width / 2 }
    }
    
    public var centerY: CGFloat {
        get { origin.y + size.height / 2 }
        set { origin.y = newValue - size.height / 2 }
    }
    
    /* Modify sizes direct */
    
    public var width2: CGFloat {
        get { size.width }
        set { size.width = newValue }
    }
    
    public var height2: CGFloat {
        get { size.height }
        set { size.height = newValue }
    }
    
    /* move edges or corners, not change other edges or corners */
    
    public mutating func moveLeftTo(_ value: CGFloat) {
        size.width = right - value
        origin.x = value
    }
    
    public mutating func moveTopTo(_ value: CGFloat) {
        size.height = bottom - value
        origin.y = value
    }
    
    public mutating func moveRightTo(_ value: CGFloat) {
        size.width = value - left
    }
    
    public mutating func moveBottomTo(_ value: CGFloat) {
        size.height = value - top
    }
    
    public mutating func moveLeftTopTo(_ value: CGPoint) {
        moveLeftTo(value.x)
        moveTopTo(value.y)
    }
    
    public mutating func moveRightTopTo(_ value: CGPoint) {
        moveRightTo(value.x)
        moveTopTo(value.y)
    }
    
    public mutating func moveRightBottomTo(_ value: CGPoint) {
        moveRightTo(value.x)
        moveBottomTo(value.y)
    }
    
    public mutating func moveLeftBottomTo(_ value: CGPoint) {
        moveLeftTo(value.x)
        moveBottomTo(value.y)
    }
    
    /* Adjust to size from diffirenct directions */
    
    public mutating func moveLeftTop(toSize size: CGSize) {
        left = right - size.width
        top = bottom - size.height
    }
    
    public mutating func moveRightTop(toSize size: CGSize) {
        width2 = size.width
        top = bottom - size.height
    }
    
    public mutating func moveRightBottom(toSize size: CGSize) {
        self.size = size
    }
    
    public mutating func moveLeftBottom(toSize size: CGSize) {
        left = right - size.width
        height2 = size.height
    }
    
    public mutating func moveLeftCenter(toSize size: CGSize) {
        left = right - size.width
        width2 = size.width
        top = center.y - size.height / 2
        height2 = size.height
    }
    
    public mutating func moveRightCenter(toSize size: CGSize) {
        width2 = size.width
        top = center.y - size.height / 2
        height2 = size.height
    }
    
    public mutating func moveTopCenter(toSize size: CGSize) {
        left = center.x - size.width / 2
        width2 = size.width
        top = bottom - size.height
        height2 = size.height
    }
    
    public mutating func moveBottomCenter(toSize size: CGSize) {
        left = center.x - size.width / 2
        width2 = size.width
        height2 = size.height
    }
    
    /* Sub rect of diffirenct corners with specific size */
    
    public func leftTopPart(ofSize size: CGSize) -> CGRect {
        var rect = self
        rect.moveRightBottom(toSize: size)
        return rect
    }
    
    public func rightTopPart(ofSize size: CGSize) -> CGRect {
        var rect = self
        rect.moveLeftBottom(toSize: size)
        return rect
    }
    
    public func rightBottomPart(ofSize size: CGSize) -> CGRect {
        var rect = self
        rect.moveLeftTop(toSize: size)
        return rect
    }
    
    public func leftBottomPart(ofSize size: CGSize) -> CGRect {
        var rect = self
        rect.moveRightTop(toSize: size)
        return rect
    }
    
    public func leftCenterPart(ofSize size: CGSize) -> CGRect {
        var rect = self
        rect.moveRightCenter(toSize: size)
        return rect
    }
    
    public func rightCenterPart(ofSize size: CGSize) -> CGRect {
        var rect = self
        rect.moveLeftCenter(toSize: size)
        return rect
    }
    
    public func topCenterPart(ofSize size: CGSize) -> CGRect {
        var rect = self
        rect.moveBottomCenter(toSize: size)
        return rect
    }
    
    public func bottomCenterPart(ofSize size: CGSize) -> CGRect {
        var rect = self
        rect.moveTopCenter(toSize: size)
        return rect
    }
    
    public func centerPart(ofSize size: CGSize) -> CGRect {
        var rect = CGRect(origin: CGPoint.zero, size: size)
        rect.center = center
        return rect
    }
    
    public func centerBounding() -> CGRect {
        var rect = CGRect.zero
        rect.right = center.x * 2
        rect.bottom = center.y * 2
        return rect
    }
    
    public func centerBoundingSize() -> CGSize {
        return CGSize(width: center.x * 2, height: center.y * 2)
    }
    
    /* Adjust */
    
    public mutating func adjust(_ left: CGFloat, _ top: CGFloat, _ right: CGFloat, _ bottom: CGFloat) {
        origin.x += left
        origin.y += top
        size.width += right - left
        size.height += bottom - top
    }
    
    public func adjusted(_ left: CGFloat, _ top: CGFloat, _ right: CGFloat, _ bottom: CGFloat) -> CGRect {
        return CGRect(x: origin.x + left, y: origin.y + top, width: size.width + right - left, height: size.height + bottom - top)
    }
    
    public mutating func inflate(width: CGFloat, height: CGFloat) {
        origin.x -= width
        origin.y -= height
        size.width += width + width
        size.height += height + height
    }
    
    public mutating func inflate(size: CGSize) {
        inflate(width: size.width, height: size.height)
    }
    
    public mutating func inflate(_ value: CGFloat) {
        inflate(width: value, height: value)
    }
    
    public mutating func deflate(width: CGFloat, height: CGFloat) {
        origin.x += width
        origin.y += height
        size.width -= width + width
        size.height -= height + height
    }
    
    public mutating func deflate(size: CGSize) {
        deflate(width: size.width, height: size.height)
    }
    
    public mutating func deflate(_ value: CGFloat) {
        deflate(width: value, height: value)
    }
    
    public func centeredAt(_ center: CGPoint) -> CGRect {
        var rect = self
        rect.center = center
        return rect
    }
    
    public mutating func cutLeft(_ value: CGFloat) -> CGRect {
        var rect = self
        moveLeftTo(left + value)
        rect.width2 = value
        return rect
    }
    
    public mutating func cutTop(_ value: CGFloat) -> CGRect {
        var rect = self
        moveTopTo(top + value)
        rect.height2 = value
        return rect
    }
    
    public mutating func cutRight(_ value: CGFloat) -> CGRect {
        var rect = self
        width2 -= value
        rect.moveLeftTo(right)
        return rect
    }
    
    public mutating func cutBottom(_ value: CGFloat) -> CGRect {
        var rect = self
        height2 -= value
        rect.moveTopTo(bottom)
        return rect
    }
}
