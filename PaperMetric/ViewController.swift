//
//  ViewController.swift
//  PaperMetric
//
//  Created by Aidan Cornelius-Bell on 24/2/2022.
//

import Cocoa
import Foundation
import WebKit

class ViewController: NSViewController {

    @IBOutlet weak var theDOI: NSTextField!
    @IBOutlet weak var forPlumx: WKWebView!
    @IBOutlet weak var forAltmetric: WKWebView!
    
    
    @IBAction func theLookup(_ sender: Any) {
        
        var plumHtml = ""
        var amHtml = ""
        
        let doiString = theDOI.stringValue
        let r = doiString.startIndex..<doiString.endIndex
        let pattern = #"\b(10[.][0-9]{4,}(?:[.][0-9]+)*\/(?:(?!["&\'<>])\S)+)\b"#
        let r2 = doiString.range(of: pattern, options: .regularExpression)
        
        
        // a regex to match DOI
        if r2 == r {
            NSLog("it was a DOI")
            
            // definitions for the Plum API
            plumHtml = "<html><head><style>body{font-family: system-ui, -apple-system;}</style><script type='text/javascript' src='https://cdn.plu.mx/widget-details.js'></script></head><body><a href=\"https://plu.mx/plum/a/?doi=" + doiString + "\" class=\"plumx-details\" style='position:absolute;float:right;right:0;'></a></body></html>"
            // definitions for the AM API
            amHtml = "<html><head><style>body{font-family: system-ui, -apple-system;}</style><script type='text/javascript' src='https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js'></script></head><body><div data-badge-details='right' data-badge-type='donut' data-doi='" + doiString + "' class='altmetric-embed'></div></body></html>"
            
        } else {
            plumHtml = "<html><head><style>body{background:rgb(52,50,51);}</style></head><body><h3 style='margin-top:47vh;text-align:center;color:rgb(222,221,221);font-family: system-ui, -apple-system;'>DOI failed to match pattern</h3></body></html>"
            amHtml = "<html><head><style>body{background:rgb(52,50,51);}</style></head><body><h3 style='margin-top:47vh;text-align:center;color:rgb(222,221,221);font-family: system-ui, -apple-system;'>DOI failed to match pattern</h3></body></html>"
        }
        
        
        // the loadout for the Plum API
        forPlumx.loadHTMLString(plumHtml, baseURL: URL(string: "https://apple.com/")!)
        // the loadout for the AM API
        forAltmetric.loadHTMLString(amHtml, baseURL: URL(string: "https://apple.com/")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

