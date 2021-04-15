//
//  UIColors.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/15.
//

import Foundation

@propertyWrapper
class DayNightColorWrapper {
    
    let dayColor: String
    let nightColor: String
    var color: UIColor
    
    var wrappedValue: UIColor {
        get { return color }
    }
    
    init(dayColor: String, nightColor: String) {
        self.dayColor = dayColor
        self.nightColor = nightColor
        self.color = UIColor(hexString: dayColor)
    }
    
    private static var wrappers = [DayNightColorWrapper]()
    
    public static func setDayNight(night: Bool) {
        for w in wrappers {
            w.color = UIColor(hexString: night ? w.dayColor : w.nightColor)
        }
    }
}

extension UIColor {

    @DayNightColorWrapper(dayColor: "#FFFFFF", nightColor: "#212630")
    public static var white_card

    @DayNightColorWrapper(dayColor: "#FFFFFF", nightColor: "#191E26")
    public static var bluegrey_00 //white_bg

    @DayNightColorWrapper(dayColor: "#F7F8F9", nightColor: "#262C36")
    public static var bluegrey_05

    @DayNightColorWrapper(dayColor: "#F7F8F9", nightColor: "#0B1117")
    public static var bluegrey_50 //bluegrey_bg

    @DayNightColorWrapper(dayColor: "#F2F3F4", nightColor: "#262D38")
    public static var bluegrey_100

    public static var bluegrey_200 = UIColor(hexString: "#EBECED")

    @DayNightColorWrapper(dayColor: "#E4E6E8", nightColor: "#2D3440")
    public static var bluegrey_300

    public static var bluegrey_400 = UIColor(hexString: "#D5D7DB")

    @DayNightColorWrapper(dayColor: "#B7BBBF", nightColor: "#4D5666")
    public static var bluegrey_500

    public static var bluegrey_600 = UIColor(hexString: "#9CA0A6")

    @DayNightColorWrapper(dayColor: "#81858C", nightColor: "#707C8C")
    public static var bluegrey_700

    @DayNightColorWrapper(dayColor: "#4E5359", nightColor: "#A3AFBF")
    public static var bluegrey_800

    @DayNightColorWrapper(dayColor: "#1D2126", nightColor: "#E2ECFA")
    public static var bluegrey_900

    @DayNightColorWrapper(dayColor: "#FFFCD4", nightColor: "#524C23")
    public static var brand_100

    public static var brand_500 = UIColor(hexString: "#FFD630")

    @DayNightColorWrapper(dayColor: "#F2C121", nightColor: "#D9B629")
    public static var brand_600

    @DayNightColorWrapper(dayColor: "#FFEDED", nightColor: "#3D2929")
    public static var red_100

    @DayNightColorWrapper(dayColor: "#FF6666", nightColor: "#DA7171")
    public static var red_500

    @DayNightColorWrapper(dayColor: "#EB3B3B", nightColor: "#E48484")
    public static var red_600

    @DayNightColorWrapper(dayColor: "#FFEDE5", nightColor: "#3E322E")
    public static var redorange_100

    @DayNightColorWrapper(dayColor: "#FF6D2E", nightColor: "#DA825E")
    public static var redorange_500

    @DayNightColorWrapper(dayColor: "#FF4D00", nightColor: "#E69472")
    public static var redorange_600

    @DayNightColorWrapper(dayColor: "#FFF0DB", nightColor: "#3C3325")
    public static var orange_100

    @DayNightColorWrapper(dayColor: "#FFA319", nightColor: "#E6A15C")
    public static var orange_500

    @DayNightColorWrapper(dayColor: "#FF8C00", nightColor: "#F2AF6C")
    public static var orange_600

    @DayNightColorWrapper(dayColor: "#E8F7F0", nightColor: "#203A32")
    public static var green_100

    @DayNightColorWrapper(dayColor: "#00CC66", nightColor: "#61BA8D")
    public static var green_500

    @DayNightColorWrapper(dayColor: "#00B058", nightColor: "#71C99D")
    public static var green_600

    @DayNightColorWrapper(dayColor: "#E1F9FA", nightColor: "#233738")
    public static var cyan_100

    @DayNightColorWrapper(dayColor: "#00D1D9", nightColor: "#5DC3C6")
    public static var cyan_500

    @DayNightColorWrapper(dayColor: "#00B9BF", nightColor: "#6DD1D4")
    public static var cyan_600

    @DayNightColorWrapper(dayColor: "#EDF4FF", nightColor: "#213452")
    public static var blue_100

    @DayNightColorWrapper(dayColor: "#CCE0FF", nightColor: "#324563")
    public static var blue_200

    @DayNightColorWrapper(dayColor: "#4F94FF", nightColor: "#6B99DE")
    public static var blue_500

    @DayNightColorWrapper(dayColor: "#1970F2", nightColor: "#7FA6E2")
    public static var blue_600

    @DayNightColorWrapper(dayColor: "#F2F0FD", nightColor: "#343146")
    public static var purple_100

    public static var purple_500 = UIColor(hexString: "#8C79F2")

    @DayNightColorWrapper(dayColor: "#6A54E0", nightColor: "#988BDC")
    public static var purple_600

    public static var static_bluegrey_05 = UIColor(hexString: "#F7F8F9")

    public static var static_bluegrey_50 = UIColor(hexString: "#F7F8F9")

    public static var static_bluegrey_100 = UIColor(hexString: "#F2F3F4")

    public static var static_bluegrey_200 = UIColor(hexString: "#EBECED")

    public static var static_bluegrey_300 = UIColor(hexString: "#E4E6E8")

    public static var static_bluegrey_400 = UIColor(hexString: "#D5D7DB")

    public static var static_bluegrey_500 = UIColor(hexString: "#B7BBBF")

    public static var static_bluegrey_600 = UIColor(hexString: "#9CA0A6")

    public static var static_bluegrey_700 = UIColor(hexString: "#81858C")

    public static var static_bluegrey_800 = UIColor(hexString: "#4E5359")

    public static var static_bluegrey_900 = UIColor(hexString: "#1D2126")

    public static var static_white_100 = UIColor(hexString: "#FFFFFF")

    public static var static_white_90 = UIColor(hexString: "#E5FFFFFF") //90% 

    public static var static_white_80 = UIColor(hexString: "#CCFFFFFF") //80% 

    public static var static_white_70 = UIColor(hexString: "#B2FFFFFF") //70% 

    public static var static_white_60 = UIColor(hexString: "#99FFFFFF") //60% 

    public static var static_white_50 = UIColor(hexString: "#7FFFFFFF") //50% 

    public static var static_white_40 = UIColor(hexString: "#66FFFFFF") //40% 

    public static var static_white_30 = UIColor(hexString: "#4CFFFFFF") //30% 

    public static var static_white_20 = UIColor(hexString: "#33FFFFFF") //20% 

    public static var static_white_10 = UIColor(hexString: "#19FFFFFF") //10% 

    public static var static_white_05 = UIColor(hexString: "#0CFFFFFF") //5% 

    public static var static_black_100 = UIColor(hexString: "#000000")

    public static var static_black_90 = UIColor(hexString: "#E5000000") //90% 

    public static var static_black_80 = UIColor(hexString: "#CC000000") //80% 

    public static var static_black_70 = UIColor(hexString: "#B2000000") //70% 

    public static var static_black_60 = UIColor(hexString: "#99000000") //60% 

    public static var static_black_50 = UIColor(hexString: "#7F000000") //50% 

    public static var static_black_40 = UIColor(hexString: "#66000000") //40% 

    public static var static_black_30 = UIColor(hexString: "#4C000000") //30% 

    public static var static_black_20 = UIColor(hexString: "#33000000") //20% 

    public static var static_black_10 = UIColor(hexString: "#19000000") //10% 

    public static var static_black_05 = UIColor(hexString: "#0C000000") //5% 

}
