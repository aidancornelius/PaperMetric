//
//  ViewController.swift
//  PaperMetric
//
//  Created by Aidan Cornelius-Bell on 24/2/2022.
//

import Cocoa
import Foundation
import WebKit

class PaperMetricViewController: NSViewController {

    @IBOutlet weak var theDOI: NSTextField!
    @IBOutlet weak var forPlumx: WKWebView!
    @IBOutlet weak var forAltmetric: WKWebView!
    @IBOutlet weak var statusIndication: NSLevelIndicator!
    
    @IBAction func hitEnter(_ sender: Any) {
        theLookup(self)
    }
    
    func matches(for regex: String, in text: String) -> [String] {

        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    
    @IBAction func theLookup(_ sender: Any) {
        
        if theDOI.stringValue == "" {
            statusIndication.intValue = 3
        }
        
        // Some empty inits for HTML to fill depending on outcome
        var plumHtml = ""
        var amHtml = ""
        var doiString = theDOI.stringValue
        
        // Set up our regular expression for DOI
        let pattern = #"\b(10[.][0-9]{4,}(?:[.][0-9]+)*\/(?:(?!["&\'<>])\S)+)\b"#
        
        // Clean any pasted DOI URL up
        let doiStringClean = matches(for: pattern, in: doiString)
        // Now unwrap the result of that function
        if doiStringClean.first != nil {
            theDOI.stringValue = doiStringClean.first!
            doiString = doiStringClean.first!
            statusIndication.intValue = 1
        } else {
            statusIndication.intValue = 2
        }
        
        // Some validation with regex
        let r = doiString.startIndex..<doiString.endIndex
        let r2 = doiString.range(of: pattern, options: .regularExpression)
        
        // a regex to match DOI
        if r2 == r {
            NSLog("it was a DOI")
            
            // definitions for the Plum API
            plumHtml = "<html><head><style>body{font-family: system-ui, -apple-system;}</style><script type='text/javascript' src='https://cdn.plu.mx/widget-details.js'></script></head><body><a href=\"https://plu.mx/plum/a/?doi=" + doiString + "\" class=\"plumx-details\" style='position:absolute;float:right;right:0;'></a></body></html>"
            // definitions for the AM API
            amHtml = "<html><head><style>body{font-family: system-ui, -apple-system;}</style><script type='text/javascript' src='https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js'></script></head><body><div data-badge-details='right' data-badge-type='donut' data-doi='" + doiString + "' class='altmetric-embed'></div></body></html>"
            
            statusIndication.intValue = 1
            
        } else {
            plumHtml = "<html><head><style>body{background:rgb(52,50,51);}</style></head><body><h3 style='margin-top:47vh;text-align:center;color:rgb(222,221,221);font-family: system-ui, -apple-system;'>DOI failed to match pattern</h3></body></html>"
            amHtml = "<html><head><style>body{background:rgb(52,50,51);}</style></head><body><h3 style='margin-top:47vh;text-align:center;color:rgb(222,221,221);font-family: system-ui, -apple-system;'>DOI failed to match pattern</h3></body></html>"
            
            statusIndication.intValue = 3
        }
        
        
        // the loadout for the Plum API
        forPlumx.loadHTMLString(plumHtml, baseURL: URL(string: "https://apple.com/")!)
        // the loadout for the AM API
        forAltmetric.loadHTMLString(amHtml, baseURL: URL(string: "https://apple.com/")!)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusIndication.intValue = 0
        
        forPlumx.reload()
        forAltmetric.reload()
        
        forPlumx.layer?.cornerRadius = 1.0
        forAltmetric.layer?.cornerRadius = 1.0
        
        let preloadHtml = "<html><head><style>body{background:rgb(52,50,51);}</style></head><body><h3 style='margin-top:47vh;text-align:center;color:rgb(222,221,221);font-family: system-ui, -apple-system;'>Enter a DOI to begin</h3></body></html>"
        forPlumx.loadHTMLString(preloadHtml, baseURL: nil)
        forAltmetric.loadHTMLString(preloadHtml, baseURL: nil)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

extension PaperMetricViewController: WKNavigationDelegate {
    
    // This makes sure that if we want to view the details we can open in Safari (or whatever) rather than a tiny window in the app
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        // makes sure we have received a link
        if navigationAction.navigationType == .linkActivated {
            
            // makes sure we have a url
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }

            // some rudamentary verification (i.e. it can actually open in a browser)
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            
            if components?.scheme == "http" || components?.scheme == "https" {
                // And out we go....
                NSWorkspace.shared.open(url)
                // now stop further action in the webview
                decisionHandler(.cancel)
            } else {
                // we'll allow this, but who knows where it's going?
                decisionHandler(.allow)
            }
        } else {
            // this is just for every other kind of event (unlikely to be triggered)
            decisionHandler(.allow)
        }
    }
}
