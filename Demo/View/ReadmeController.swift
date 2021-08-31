//
//  ReadmeController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/11.
//

import Foundation
import MarkdownView

public class ReadmeController : UIViewController {
    
    let md = MarkdownView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // called when rendering finished
        md.onRendered = { [weak self] height in
//            self?.md.snp.updateConstraints() { maker in
//                maker.height.equalTo(height)
//            }
            self?.view.setNeedsLayout()
        }
        
        view.addSubview(md)
        md.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
    
    private static let rootURL: URL = {
        if let url = Bundle(for: URLs.self).url(forResource: "Docs", withExtension: "bundle") {
            return url
        } else {
            return Bundle.main.url(forResource: "Frameworks/Docs", withExtension: "bundle")!
        }
    }()

    private static func docURL(_ file: String, _ file2: String) -> URL? {
        return check(rootURL.appendingPathComponent("docs/\(file).md"))
            ?? check(rootURL.appendingPathComponent("docs/\(file2).md"))
    }

    private static func check(_ url: URL) -> URL? {
        return FileManager.default.fileExists(atPath: url.relativePath) ? url : nil
    }
    
    public func load(component : Component) {
        let name = type(of: component).description()
            .replacingOccurrences(of: "Demo.", with: "")
            .replacingOccurrences(of: "Z", with: "")
            .replacingOccurrences(of: "Component", with: "")
        let name2 = type(of: component.controller).description()
            .replacingOccurrences(of: "Demo.", with: "")
            .replacingOccurrences(of: "Z", with: "")
            .replacingOccurrences(of: "Controller", with: "")
        if let url = Self.docURL(name, name2), let data = try? Data(contentsOf: url) {
            md.load(markdown: String(data: data, encoding: .utf8))
        } else {
            md.load(markdown: "File not found \(name) or \(name2)")
        }
    }
}
