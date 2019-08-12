//
//  PubadsModel-test.swift
//  VastClientTests
//
//  Created by Jan Bednar on 20/11/2018.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation
@testable import VastClient

extension VastModel {
    static let pubadsModel: VastModel = {
        let wrapper = VastModel.pubadsWrapperModel
        let inline = VastModel.pubadsInlineModel
        
        var model = wrapper
        model.ads[0].adSystem = inline.ads.first?.adSystem
        if let title = inline.ads.first?.adTitle, !title.isEmpty {
            model.ads[0].adTitle = title
        }
        
        model.ads[0].type = .inline
        model.ads[0].impressions.append(contentsOf: inline.ads.first!.impressions)
        model.ads[0].extensions.append(contentsOf: inline.ads.first!.extensions)
        model.ads[0].creatives = CreativeMerger.appendOrMerge(wrapperCreatives: model.ads[0].creatives, unwrappedCreatives: inline.ads[0].creatives)
        
        return model
    }()
}
