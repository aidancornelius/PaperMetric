//
//  HelpViewController.swift
//  PaperMetric
//
//  Created by Aidan Cornelius-Bell on 25/2/2022.
//

import Foundation
import Cocoa
import WebKit

class HelpViewController: NSViewController {
    @IBOutlet weak var helpWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let helpIndexPath = Bundle.main.url(forResource: "PaperMetricHelp", withExtension: "html")!
        let request = NSURLRequest(url: helpIndexPath)
        helpWebView.load(request as URLRequest)
    }
    
}
