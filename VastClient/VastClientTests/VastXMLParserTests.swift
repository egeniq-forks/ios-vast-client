//
//  VastParserTests.swift
//  Vaster_Example
//
//  Created by Jan Bednar on 12/11/2018.
//  Copyright © 2018 STER. All rights reserved.
//

import XCTest
@testable import VastClient

class VastXMLParserTests: XCTestCase {
    
    func test_online_file() {
        let url = URL(string: "https://raw.githubusercontent.com/InteractiveAdvertisingBureau/VAST_Samples/master/VAST%204.0%20Samples/Ad_Verification-test.xml")!
        let parser = VastXMLParser()
        let model = try! parser.parse(url: url)
        XCTAssertTrue(!model.ads.isEmpty)
    }
    
    func test_inlineLinearTag3() {
        let model = self.loadVastFile(named: "Inline_Linear_Tag-test3")
        XCTAssertEqual(model, VastModel.inlineLinearTag3)
    }
    
    func test_wrapperTag3() {
        let model = self.loadVastFile(named: "Wrapper_Tag-test3")
        XCTAssertEqual(model, VastModel.wrapperTag3)
    }
    
    func test_videoClicksTag3() {
        let model = self.loadVastFile(named: "Video_Clicks_and_click_tracking-Inline-test3")
        XCTAssertEqual(model, VastModel.videoClicksAndClickTrackingInLine3)
    }
    
    func test_eventTrackingTag3() {
        let model = self.loadVastFile(named: "Event_Tracking-test3")
        XCTAssertEqual(model, VastModel.eventTracking3)
    }
    
    func test_category() {
        let model = self.loadVastFile(named: "Category-test")
        XCTAssertEqual(model, VastModel.category)
    }
    
    func test_eventTracking() {
        let model = self.loadVastFile(named: "Event_Tracking-test")
        XCTAssertEqual(model, VastModel.eventTracking)
    }
    
    func test_videoClicksAndClickTrackingInline() {
        let model = self.loadVastFile(named: "Video_Clicks_and_click_tracking-Inline-test")
        XCTAssertEqual(model, VastModel.videoClicksAndClickTrackingInline)
    }
    
    func test_wrapperTag() {
        let model = self.loadVastFile(named: "Wrapper_Tag-test")
        XCTAssertEqual(model, VastModel.wrapperTag)
    }
    
    func test_adVerification() {
        let model = self.loadVastFile(named: "Ad_Verification-test")
        XCTAssertEqual(model, VastModel.adVerification)
    }
    
    func test_universalAdId() {
        let model = self.loadVastFile(named: "Universal_Ad_ID-test")
        XCTAssertEqual(model, VastModel.universalAdId)
    }
    
    func test_noWrapperTag() {
        let model = self.loadVastFile(named: "No_Wrapper_Tag-test")
        XCTAssertEqual(model, VastModel.noWrapperTag)
    }
    
    func test_inlineLinearTag() {
        let model = self.loadVastFile(named: "Inline_Linear_Tag-test")
        XCTAssertEqual(model, VastModel.inlineLinearTag)
    }
    
    func test_inlineSimple() {
        let model = self.loadVastFile(named: "Inline_Simple-test")
        XCTAssertEqual(model, VastModel.inlineSimple)
    }
    
    func test_viewableImpression() {
        let model = self.loadVastFile(named: "Viewable_Impression-test")
        XCTAssertEqual(model, VastModel.viewableImpression)
    }
    
    func test_readyToServerMediaFilesCheck() {
        let model = self.loadVastFile(named: "Ready_to_serve_Media_Files_check-test")
        XCTAssertEqual(model, VastModel.readyToServerMediaFilesCheck)
    }
    
    func test_fullVast4File_doesNotFail() {
        let model = self.loadVastFile(named: "TestFullVast4")
        XCTAssertEqual(model.ads.count, 2)
        XCTAssertEqual(model.version, "4.0")
        XCTAssertEqual(model.errors.count, 0)
    }
    
    func test_fullVast4File() {
        let model = self.loadVastFile(named: "TestFullVast4")
        XCTAssertEqual(model, VastModel.fullVast4)
    }
    
    func test_inlineLinearIcons() {
        let model = self.loadVastFile(named: "Inline_linear_icons-test")
        XCTAssertEqual(model, VastModel.inlineLinearIcons)
    }
    
    func test_sterFeedback1_loadsAd() {
        let model = self.loadVastFile(named: "Feedback1")
        XCTAssertTrue(model.ads.first!.creatives.first(where: { $0.linear != nil })!.linear!.files.mediaFiles.count > 0)
    }
    
    func test_sterFeedback2_loadsAd() {
        let model = self.loadVastFile(named: "Feedback2")
        XCTAssertTrue(model.ads.first!.creatives.first(where: { $0.linear != nil })!.linear!.files.mediaFiles.count > 0)
    }
    
    func test_sterFeedback3_loadsAd() {
        let model = self.loadVastFile(named: "Feedback3")
        XCTAssertTrue(model.ads.first!.creatives.first(where: { $0.linear != nil })!.linear!.files.mediaFiles.count > 0)
    }
    
    func test_sterFeedback11_loadsAd() {
        let model = self.loadVastFile(named: "Feedback11")
        XCTAssertTrue(model.ads.first!.creatives.first(where: { $0.linear != nil })!.linear!.files.mediaFiles.count > 0)
    }
    
    func test_sterFeedback25_parseWrapperXML() {
        let model = self.loadVastFile(named: "Feedback25")
        XCTAssertTrue(model.ads.first!.type == .wrapper)
    }
    
    func test_sterFeedback25_parseInlineUnwrappedXML() {
        let model = self.loadVastFile(named: "Feedback25_unwrapped")
        XCTAssertTrue(model.ads.first!.type == .inline)
        XCTAssertTrue(model.ads.first!.creatives.first(where: { $0.linear != nil })!.linear!.files.mediaFiles.count > 0)
    }
    
    func test_sterFeedback25_loadsAd() {
        let url = URL(string: "test://Feedback25")!
        let expect = expectation(description: "model")
        var model: VastModel?
        let client = VastClient(options: VastClientOptions(wrapperLimit: 2))
        
        client.parseVast(withContentsOf: url, testBundle: Bundle(for: type(of: self))) { (vastModel, error) in
            model = vastModel
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: { _ in
            XCTAssertTrue(model != nil)
            XCTAssertTrue(model!.ads.first!.creatives.first(where: { $0.linear != nil })!.linear!.files.mediaFiles.count > 0)
        })
    }
    
    private func loadVastFile(named filename: String) -> VastModel {
        let parser = VastXMLParser()
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: filename, ofType: "xml")!
        let url = URL(fileURLWithPath: filepath)
        let model = try! parser.parse(url: url)
        return model
    }
}
