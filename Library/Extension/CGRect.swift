//
//  CGRect.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/8.
//

import Foundation

extension CGRect {
    
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
        set { size.width = newValue - origin.x }
    }
    
    public var bottom: CGFloat {
        get { origin.y + size.height }
        set { size.height = newValue - origin.y }
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
    }
    
    public mutating func moveLeft(_ value: CGFloat) {
        origin.x = value
    }
    
    public mutating func moveTop(_ value: CGFloat) {
        origin.y = value
    }
    
    public mutating func moveRight(_ value: CGFloat) {
        origin.x = value - size.width
    }
    
    public mutating func moveBottom(_ value: CGFloat) {
        origin.y = value - size.height
    }
    
    public mutating func moveLeftTop(_ value: CGPoint) {
        origin = value
    }
    
    public mutating func moveRightTop(_ value: CGPoint) {
        moveRight(value.x)
        moveTop(value.y)
    }
    
    public mutating func moveRightBottom(_ value: CGPoint) {
        moveRight(value.x)
        moveBottom(value.y)
    }
    
    public mutating func moveLeftBottom(_ value: CGPoint) {
        moveLeft(value.x)
        moveBottom(value.y)
    }
    
    public mutating func moveLeftTop(toSize: CGSize) {
        left = right - toSize.width
        top = bottom - toSize.height
    }
    
    public mutating func moveRightTop(toSize: CGSize) {
        width2 = toSize.width
        top = bottom - toSize.height
    }
    
    public mutating func moveRightBottom(toSize: CGSize) {
        size = toSize
    }
    
    public mutating func moveLeftBottom(toSize: CGSize) {
        left = right - toSize.width
        height2 = toSize.height
    }
    
    public mutating func moveCenter(_ value: CGPoint) {
        origin.x = value.x - size.width / 2
        origin.y = value.y - size.height / 2
    }
    
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
    
    public mutating func moveLeftCenter(toSize: CGSize) {
        left = right - toSize.width
        width2 = toSize.width
        top = center.y - toSize.height / 2
        height2 = toSize.height
    }
    
    public mutating func moveRightCenter(toSize: CGSize) {
        width2 = toSize.width
        top = center.y - toSize.height / 2
        height2 = toSize.height
    }
    
    public mutating func moveTopCenter(toSize: CGSize) {
        left = center.x - toSize.width / 2
        width2 = toSize.width
        top = bottom - toSize.height
        height2 = toSize.height
    }
    
    public mutating func moveBottomCenter(toSize: CGSize) {
        left = center.x - toSize.width / 2
        width2 = toSize.width
        height2 = toSize.height
    }
    
    public var width2: CGFloat {
        get { size.width }
        set { size.width = newValue }
    }
    
    public var height2: CGFloat {
        get { size.height }
        set { size.height = newValue }
    }
    
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
        rect.moveCenter(center)
        return rect
    }
    
    public mutating func cutLeft(_ value: CGFloat) -> CGRect {
        var rect = self
        moveLeftTo(left + value)
        rect.right = left
        return rect
    }
    
    public mutating func cutTop(_ value: CGFloat) -> CGRect {
        var rect = self
        moveTopTo(top + value)
        rect.bottom = top
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
