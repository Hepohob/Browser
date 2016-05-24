//
//  ViewController.swift
//  Browser
//
//  Created by Алексей Неронов on 24.05.16.
//  Copyright © 2016 Алексей Неронов. All rights reserved.
//

import Cocoa
import WebKit


class ViewController: NSViewController, WebFrameLoadDelegate, WebPolicyDelegate {

    @IBOutlet var textField: NSTextField!
    @IBOutlet var webView: WebView!
    
    @IBOutlet var myProgressView: NSLevelIndicator!
    
    var theBool: Bool!
    var myTimer: NSTimer!

    let defaultURL = "http://support.amurprint.ru"
    
    @IBAction func textFieldAction(sender: NSTextField) {
        var urlStr=sender.stringValue
        var urlStrCheck=sender.stringValue
        if !urlStrCheck.hasPrefix("http://") {
            urlStrCheck="http://"+urlStrCheck
        }
        if validateUrl(urlStrCheck) {
            print("This is URL adress "+urlStr)
            if !urlStr.hasPrefix("http://") {
                urlStr="http://"+urlStr
            }
        } else {
            print("Search string '"+urlStr+"'")
            urlStr="http://www.google.com/search?q=\(urlStr)"
        }
        self.webView.mainFrame.loadRequest(NSURLRequest(URL: NSURL(string:urlStr)!))
    }
    
    func validateUrl (stringURL : NSString) -> Bool {
        let urlRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
        let urlTest = NSPredicate.predicateWithSubstitutionVariables(predicate)
        
        return predicate.evaluateWithObject(stringURL)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.stringValue = defaultURL
        self.webView.frameLoadDelegate = self
        self.webView.policyDelegate = self
        self.webView.mainFrame.loadRequest(NSURLRequest(URL: NSURL(string: defaultURL)!))
        
    }

    func webView(webView: WebView!, decidePolicyForNavigationAction actionInformation: [NSObject : AnyObject]!, request: NSURLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!) {
       /*
        if let currentURL = request.URL {
            if currentURL.absoluteString == defaultURL {
                print("our base/default URL is being called - showing in WebView")
                listener.use()   // tell the listener to show the request
            } else {
                print("some other URL - ie. a link has been clicked - ignore in WebView")
                listener.ignore()   // tell the listener to ignore the request
                print("redirecting url: \(currentURL.absoluteString) to standard browser")
                NSWorkspace.sharedWorkspace().openURL(currentURL)
            }
        }
 */
        listener.use()
    }

    func webView(sender: WebView!, didStartProvisionalLoadForFrame frame: WebFrame!)
    {
        print("Start load ...")
        funcToCallWhenStartLoadingYourWebview()
    }
    
    func webView(sender: WebView!, didFinishLoadForFrame frame: WebFrame!)
    {
        funcToCallCalledWhenUIWebViewFinishesLoading()
        print("Finish load ...")
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func funcToCallWhenStartLoadingYourWebview() {
        self.myProgressView.integerValue = 0
        self.theBool = false
        self.myTimer = NSTimer.scheduledTimerWithTimeInterval(0.01667, target: self, selector: #selector(ViewController.timerCallback), userInfo: nil, repeats: true)
    }
    
    func funcToCallCalledWhenUIWebViewFinishesLoading() {
        self.theBool = true
    }
    
    func timerCallback() {
        if self.theBool! {
            if self.myProgressView.integerValue >= 100 {
                //self.myProgressView.hidden = true
                self.myTimer.invalidate()
            } else {
                self.myProgressView.integerValue += 10
            }
        } else {
            self.myProgressView.integerValue += 5
            if self.myProgressView.integerValue >= 95 {
                self.myProgressView.integerValue = 95
            }
        }
    }

}

