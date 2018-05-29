//
//  VastModel.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

struct VastElements {
    static let vast = "VAST"
    static let error = "Error"
}

struct VastAttributes {
    static let version = "version"
}

public struct VastModel {
    public let version: String
    public var ads = [VastAd]()
    public var error: URL?
}

extension VastModel {
    public init(attrDict: [String: String]) {
        var version = ""
        for (key, value) in attrDict {
            switch key {
            case VastAttributes.version:
                version = value
            default:
                break
            }
        }
        self.version = version
    }
}
