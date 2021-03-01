//
//  NotificationHelper.swift
//  SkinManager
//
//  Created by 宋昌鹏 on 2020/6/1.
//

import Foundation

public enum WeexNotification: String {
    case refreshInstance = "RefreshInstance"
    case statusBarAction = "StatusBarAction"
    case closeXpApp
    case listenBasePoint

    public var stringValue: String {
        return  rawValue
    }

    public var notificationName: NSNotification.Name {
        return NSNotification.Name(stringValue)
    }

}

public enum TestPaperNotificationName: String {
    case testPaperPublishSucess
    case testPaperOvertime
    case testPaperRespondSucess
    case testPaperRespondBreakoff

    public var stringValue: String {
        return "GoodFuture" + rawValue
    }

    public var notificationName: NSNotification.Name {
        return NSNotification.Name(stringValue)
    }
}

public enum NotificationNameOption: String {
    case newGrowthRecordKey
    case changeSkinKey
    case collectionTypeKey
    case growthRecordCollectionKey
    case musicPlayerPlayKey
    case musicPlayerStopKey
    case homeTapToTop
    case moveFileSuccess
    case homeworkComment
    case homeworkCorrect
    case homeworkPass
    case homeworkMark
    case homeworkNextPageData
    case firstPublishTimingMessage
    case childChangedSuccess

    public var stringValue: String {
        return "XHB" + rawValue
    }

    public var notificationName: NSNotification.Name {
        return NSNotification.Name(stringValue)
    }
}

public extension NotificationCenter {
    public func post(customNotification name: NotificationNameOption, object anObject: Any?, userInfo aUserInfo: [AnyHashable: Any]? = nil) {
        self.post(name: name.notificationName, object: anObject, userInfo: aUserInfo)
    }

    public func post(testPaperNotificaiton name: TestPaperNotificationName, object anObject: Any?, iserInfo auserInfo: [AnyHashable: Any]? = nil) {
        self.post(name: name.notificationName, object: anObject, userInfo: auserInfo)
    }

    public func post(WeexNotification name: WeexNotification, object anObject: Any?, userInfo auserInfo: [AnyHashable: Any]? = nil) {
        self.post(name: name.notificationName, object: anObject, userInfo: auserInfo)
    }
}
