//
//  VastParser.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

/**
 Vast Parser
 
 Use this parser to receive final unwrapped VastModel.
 
 When wrapper VAST response is received it recursively fetches the file specified in VastAdTagURI element and flattens the responses
 */
class VastParser {
    
    let options: VastClientOptions
    
    // for testing of local files only
    private let testFileBundle: Bundle?
    private let queue: DispatchQueue
    
    init(options: VastClientOptions, queue: DispatchQueue = DispatchQueue.init(label: "parser", qos: .userInitiated), testFileBundle: Bundle? = nil) {
        self.options = options
        self.queue = queue
        self.testFileBundle = testFileBundle
    }
    
    private var completion: ((VastModel?, Error?) -> ())?
    
    private func finish(vastModel: VastModel?, error: Error?) {
        DispatchQueue.main.async {
            self.completion?(vastModel, error)
            self.completion = nil
        }
    }
    
    @objc private func timerAction() {
        finish(vastModel: nil, error: VastError.wrapperTimeLimitReached)
    }
    
    func parse(url: URL, completion: @escaping (VastModel?, Error?) -> ()) {
        self.completion = completion
        let timer: Timer
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: options.timeLimit, repeats: false) { [weak self] _ in
                self?.finish(vastModel: nil, error: VastError.wrapperTimeLimitReached)
            }
        } else {
            timer = Timer.scheduledTimer(timeInterval: options.timeLimit, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
        }
        queue.async {
            do {
                let vastModel = try self.internalParse(url: url)
                timer.invalidate()
                self.finish(vastModel: vastModel, error: nil)
            } catch {
                timer.invalidate()
                self.finish(vastModel: nil, error: error)
            }
        }
    }
    
    private func internalParse(url: URL, count: Int = 0) throws -> VastModel {
        guard count < options.wrapperLimit else {
            throw VastError.wrapperLimitReached
        }
        let parser = VastXMLParser()
        
        var vm: VastModel
        if url.scheme?.contains("test") ?? false, let bundle = testFileBundle {
            let filename = url.absoluteString.replacingOccurrences(of: "test://", with: "")
            let filepath = bundle.path(forResource: filename, ofType: "xml")!
            let url = URL(fileURLWithPath: filepath)
            vm = try internalParse(url: url)
        } else {
            vm = try parser.parse(url: url)
        }
        
        let flattenedVastAds = unwrap(vm: vm, count: count)
        vm.ads = flattenedVastAds
        return vm
    }
    
    func unwrap(vm: VastModel, count: Int) -> [VastAd] {
        return vm.ads.map { ad -> VastAd in
            var wrapperAd = ad
            
            guard ad.type == .wrapper, let urlToUnwrap = ad.wrapper?.adTagUri else { return ad }
            
            do {
                let unwrappedModel = try internalParse(url: urlToUnwrap, count: count + 1)
                unwrappedModel.ads.forEach { unwrappedAd in
                    if let adSystem = unwrappedAd.adSystem {
                        wrapperAd.adSystem = adSystem
                    }
                    
                    if let title = unwrappedAd.adTitle, !title.isEmpty {
                        wrapperAd.adTitle = title
                    }
                    wrapperAd.errors.append(contentsOf: unwrappedAd.errors)
                    
                    if unwrappedAd.type != AdType.unknown {
                        wrapperAd.type = unwrappedAd.type
                    }
                    
                    wrapperAd.impressions.append(contentsOf: unwrappedAd.impressions)
                    let creatives = CreativeMerger.appendOrMerge(wrapperCreatives: wrapperAd.creatives, unwrappedCreatives: unwrappedAd.creatives)
                    wrapperAd.creatives = creatives
                    wrapperAd.extensions.append(contentsOf: unwrappedAd.extensions)
                }
            } catch {
                print("Unable to unwrap wrapper")
            }
            return wrapperAd
        }
    }
    
}
