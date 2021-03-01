import Foundation

public class StyleKit {
    let stylist: Stylist

    public init?(fileUrl: URL, styleParser: StyleParsable? = nil) {
        let fileLoader = FileLoader(fileUrl: fileUrl)
        if let data = fileLoader.load() {
            stylist = Stylist(data: data, styleParser: styleParser)
        } else {
            return nil
        }
    }

    public func apply() {
        stylist.apply()
    }
}
