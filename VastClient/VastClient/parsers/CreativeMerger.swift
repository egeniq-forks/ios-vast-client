//
//  CreativeMerger.swift
//  VastClient
//
//  Created by Jan Bednar on 24/07/2019.
//  Copyright © 2019 John Gainfort Jr. All rights reserved.
//

import Foundation

struct CreativeMerger {
    static func appendOrMerge(wrapperCreatives: [VastCreative], unwrappedCreatives: [VastCreative]) -> [VastCreative] {
        let uniqueWrapperCreatives = wrapperCreatives.filter { creative in
            if let sequence = creative.sequence {
                return !unwrappedCreatives.contains(where: { $0.sequence == sequence })
            } else {
                return false
            }
        }
        
        let uniqueUnwrappedCreatives = unwrappedCreatives.filter { creative in
            if let sequence = creative.sequence {
                return !wrapperCreatives.contains(where: { $0.sequence == sequence })
            } else {
                return false
            }
        }
        
        var combinedCreatives = uniqueWrapperCreatives + uniqueUnwrappedCreatives
        
        let nonuniqueWrapperCreatives = wrapperCreatives.filter( { !uniqueUnwrappedCreatives.contains( $0 )})
        let nonuniqueUnwrappedCreatives = unwrappedCreatives.filter( { !uniqueUnwrappedCreatives.contains( $0 )})
        
        let merged = nonuniqueWrapperCreatives.map { wrapperCreative -> VastCreative in
            guard let sequence = wrapperCreative.sequence, let unwrappedCreative = nonuniqueUnwrappedCreatives.first(where: { $0.sequence == sequence }) else {
                return wrapperCreative
            }
            return self.merge(unwrapped: unwrappedCreative, wrapper: wrapperCreative)
        }
        
        combinedCreatives.append(contentsOf: merged)
        return combinedCreatives
    }
    
    // merge only creatives with the same sequence!!!
    private static func merge(unwrapped: VastCreative, wrapper: VastCreative) -> VastCreative {
        var unwrapped = unwrapped
        unwrapped.universalAdId = unwrapped.universalAdId ?? wrapper.universalAdId
        unwrapped.creativeExtensions.append(contentsOf: wrapper.creativeExtensions)
        unwrapped.companionAds?.companions.append(contentsOf: wrapper.companionAds?.companions ?? [])
        if let wrapperLinear = wrapper.linear {
            unwrapped.linear?.merge(wrapper: wrapperLinear)
        }
        
        return unwrapped
    }
}

fileprivate extension VastLinearCreative {
    mutating func merge(wrapper: VastLinearCreative) {
        self.duration = self.duration ?? wrapper.duration
        self.videoClicks.append(contentsOf: wrapper.videoClicks)
        self.trackingEvents.append(contentsOf: wrapper.trackingEvents)
        self.icons.append(contentsOf: wrapper.icons)
        self.files.mediaFiles.append(contentsOf: wrapper.files.mediaFiles)
        self.files.interactiveCreativeFiles.append(contentsOf: wrapper.files.interactiveCreativeFiles)
    }
}
