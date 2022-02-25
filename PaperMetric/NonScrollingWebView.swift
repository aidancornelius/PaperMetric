//
//  NonScrollingWebView.swift
//  PaperMetric
//
//  Created by Aidan Cornelius-Bell on 25/2/2022.
//

import Foundation
import Cocoa
import WebKit

class NonScrollingWebView: WKWebView {
    // we were using this for the metric views, but for extremely long results this became impractical
    override func scrollWheel(with theEvent: NSEvent) {
        nextResponder?.scrollWheel(with: theEvent)
        return
    }
    
}
