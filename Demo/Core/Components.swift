//
//  Components.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/20.
//

import Foundation

public class Components : NSObject
{
    static var groups: Dictionary<ComponentGroup, Array<ComponentInfo>>? = nil
    
    public class func allGroups() -> Dictionary<ComponentGroup, Array<ComponentInfo>> {
        if let g = groups {
            return g
        }
        let components = allComponents("^Demo\\..+Component") ?? allComponents2()
        var groups : Dictionary<ComponentGroup, Array<ComponentInfo>> = [:]
        for component in components {
            var group = groups[component.group] ?? []
            group.append(ComponentInfo(component))
            groups[component.group] = group
        }
        Components.groups = groups
        return groups
    }
    
    private class func allComponents(_ pattern: String) -> Array<Component>? {
        let pattern = try! NSRegularExpression(pattern: pattern, options: [])
        var components: [Component] = []
        let image = class_getImageName(Components.self)!
        var outCount = UInt32()
        let classes = objc_copyClassNamesForImage(image, &outCount)!
        for i in 0 ..< Int(outCount) {
            let className = String(cString: classes[i])
            let matches = pattern.matches(in: className, options: [], range: NSRange(location: 0, length: className.utf8.count))
            if matches.count > 0 {
                print("Found component: " + className)
                if let component = ObjectFactory.create(className) as? Component {
                    components.append(component)
                }
            }
        }
        return components.isEmpty ? nil : components
    }
    
    private class func allComponents2() -> Array<Component> {
        return [
            StaticColorsComponent(),
            ButtonsComponent(),
            TextAppearanceComponent(),
            PngIconComponent(),
            DayNightIconComponent(),
            DayNightColorsComponent(),
            SvgIconComponent(),
            StateListColorsComponent(),
            ZDialogComponent(),
            ZToastComponent(),
            ZToolTipComponent(),
            ZSnackBarComponent(),
            ZSearchBarComponent(),
            ZNumberViewComponent(),
            ZTextAreaComponent(),
            ZTextInputComponent(),
            ZCarouselViewComponent(),
            ZListViewComponent(),
            ZGridComponent(),
            ZFilterComponent(),
            ZToolBarComponent(),
            ZBottomBarComponent(),
            ZCardComponent(),
            ZBadgeViewComponent(),
            ZRatioButtonComponent(),
            ZSwitchButtonComponent(),
            ZButtonComponent(),
            ZAvatarViewComponent(),
            ZCheckboxComponent(),
            ZTabBarComponent(),
            ZPanelComponent(),
            ZAppTitleBarComponent(),
            ZActivityViewComponent(),
            ZDatePickerViewComponent(),
            ZPickerViewComponent(),
            ZTimePickerViewComponent(),
            ZActionSheetComponent(),
            ZDropDownComponent(),
        ]
    }
    
    
}
