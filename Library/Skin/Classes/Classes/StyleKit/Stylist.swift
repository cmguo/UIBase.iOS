import UIKit
//import XCGLogger

extension NSObject {
    func exeFunction(_ selector: Selector, with value: AnyObject?) {
        if self.responds(to: selector) {
            self.perform(selector, with: value)
        }
    }

    func exeFunction(_ selector: Selector) {
        if self.responds(to: selector) {
            self.perform(selector)
        }
    }
}

class Stylist {
    typealias Style = [String: AnyObject]
    typealias SetValueForControlState = @convention(c) (AnyObject, Selector, AnyObject, UInt) -> Void

    let data: Style
    let aliases: Style
    let styleParser: StyleParsable
    var currentComponent: AnyClass?
    var viewStack = [UIAppearanceContainer.Type]()

    init(data: Style, styleParser: StyleParsable?) {
        self.styleParser = styleParser ?? StyleParser()

        var tmpAlias = Style()
        var tmpData = Style()

        for (key, value) in data {
            if key.hasPrefix("@") {
                tmpAlias[key] = value
            } else {
                tmpData[key] = value
            }
        }

        self.data = tmpData
        aliases = tmpAlias
    }

    func apply() {
        SKTryCatch.try({
            self.validateAndApply(self.data)
        }, catch: { exception in
//            log.error("There was an error while applying styles: \(exception.debugDescription)")
        }, finallyBlock: nil)
    }

    private func validateAndApply(_ data: Style) {
        for (key, value) in data {
            if key == "Custom" {
                continue
            }
            if let value = value as? Style, NSClassFromString(key) != nil {
                if selectCurrentComponent(key), let appearanceContainer = self.currentComponent! as? UIAppearanceContainer.Type {
                    viewStack.append(appearanceContainer)
                }
                validateAndApply(value)
                _ = viewStack.popLast()
                if viewStack.count > 0 {
                    currentComponent = viewStack.last
                }
            } else {
                SKTryCatch.try({
                    if let currentComponent = self.currentComponent {
                        self.applyStyle(key, object: value, currentComponent: currentComponent)
                    } else {
//                        log.error("Style \(value) not applied on \(key) for \(self.currentComponent.debugDescription)")
                    }
                }, catch: { _ in
//                    log.error("Style \(value) not applied on \(key) for \(self.currentComponent.debugDescription) Error \(exception.debugDescription)")
                }, finallyBlock: nil)
            }
        }
    }

    private func selectCurrentComponent(_ name: String) -> Bool {
//        log.debug("Switching to: \(name)")

        guard let currentComponent = NSClassFromString(name) else {
//            log.debug("Component \(name) cannot be selected")
            return false
        }
        self.currentComponent = currentComponent
        return true
    }

    private func applyStyle(_ name: String, object: AnyObject, currentComponent _: AnyClass) {
        var selectorName = name
        let nameState = name.components(separatedBy: ":")
        var state: AnyObject?
        if nameState.count == 2 {
            selectorName = "\(nameState.first!):forState"
            state = ControlStateHelper.parseControlState(nameState.last!) as AnyObject?
        } else {
            state = nil
        }

//        log.debug("Applying: \(selectorName) on level \(viewStack.count)")
        if let styles = object as? Stylist.Style {
            var stylesToApply = Stylist.Style()
            for (style, value) in styles {
                stylesToApply[style] = styleParser.getStyle(forName: name, value: getValue(value))
            }
            callAppearanceSelector(selectorName, valueOne: stylesToApply as AnyObject?, valueTwo: state)
        } else {
            let value = styleParser.getStyle(forName: name, value: getValue(object))
            callAppearanceSelector(selectorName, valueOne: value, valueTwo: state)
        }
    }

    /**
     Checks if the value is an alias, and if it is resolves to the correct value.
     Otherwise, it will return the passed value.

     - Parameter value: The alias name or actual value
     */
    private func getValue(_ value: AnyObject) -> AnyObject {
        guard let stringValue = value as? String, stringValue.hasPrefix("@") else {
            return value
        }

        if let aliasValue = aliases[stringValue] {
            return aliasValue
        } else {
//            log.error("Value declared is using Alias \(value) which has not been defined")

            return value
        }
    }

    private func callAppearanceSelector(_ selector: String, valueOne: AnyObject?, valueTwo: AnyObject?) {
        let modifiedSelector = "set\(selector.capitalizeFirstLetter()):"

        var viewStack = self.viewStack
        _ = viewStack.popLast()

        let isViewStackRelevant = viewStack.count > 0
        viewStack = viewStack.reversed()

        if valueOne == nil && valueTwo == nil {
            if isViewStackRelevant {
                if #available(iOS 9.0, *) {
                    _ = (self.currentComponent!.appearance(whenContainedInInstancesOf: viewStack) as! NSObject).exeFunction(Selector(modifiedSelector))
                } else {
                    _ = (currentComponent!.styleKitAppearanceWhenContained(within: viewStack) as! NSObject).exeFunction(Selector(modifiedSelector))
                }
            } else {
                _ = (currentComponent!.appearance() as! NSObject).exeFunction(Selector(modifiedSelector))
            }
        } else if valueOne != nil && valueTwo != nil {
            if isViewStackRelevant {
                if #available(iOS 9.0, *) {
                    let methodSignature = (self.currentComponent!.appearance(whenContainedInInstancesOf: viewStack) as! NSObject).method(for: Selector(modifiedSelector))
                    let callback = unsafeBitCast(methodSignature, to: SetValueForControlState.self)
                    callback(self.currentComponent!.appearance(whenContainedInInstancesOf: viewStack), Selector(modifiedSelector), valueOne!, valueTwo as! UInt)
                } else {
                    let methodSignature = (currentComponent!.styleKitAppearanceWhenContained(within: viewStack) as! NSObject).method(for: Selector(modifiedSelector))
                    let callback = unsafeBitCast(methodSignature, to: SetValueForControlState.self)
                    callback(currentComponent!.styleKitAppearanceWhenContained(within: viewStack), Selector(modifiedSelector), valueOne!, valueTwo as! UInt)
                }
            } else {
                let methodSignature = (currentComponent!.appearance() as! NSObject).method(for: Selector(modifiedSelector))
                let callback = unsafeBitCast(methodSignature, to: SetValueForControlState.self)
                callback(currentComponent!.appearance(), Selector(modifiedSelector), valueOne!, valueTwo as! UInt)
            }
        } else if valueOne != nil {
            if isViewStackRelevant {
                let selector = Selector(modifiedSelector)
                if #available(iOS 9.0, *) {
                    _ = (self.currentComponent!.appearance(whenContainedInInstancesOf: viewStack) as! NSObject).exeFunction(Selector(modifiedSelector), with: valueOne!)
                } else {
                    let flag = currentComponent!.styleKitAppearanceWhenContained(within: viewStack)?.responds(to: selector)
                    if let realFlag = flag, realFlag == true {
                        _ = currentComponent!.styleKitAppearanceWhenContained(within: viewStack).perform(selector, with: valueOne!)
                    }
                }
            } else {
                _ = (currentComponent!.appearance() as! NSObject).exeFunction(Selector(modifiedSelector), with: valueOne!)
            }
        }
    }
}
