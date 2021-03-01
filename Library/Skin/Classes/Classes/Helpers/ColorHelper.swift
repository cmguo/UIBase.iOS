import UIKit

public struct ColorHelper {
    public static func parseColor(_ color: String) -> UIColor? {
        return UIColor(hexString: color)
    }
}
