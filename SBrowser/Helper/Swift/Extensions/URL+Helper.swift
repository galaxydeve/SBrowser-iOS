//
//  URL+Helper.swift
//  SBrowser
//
//  Created by Jin Xu on 21/01/20.
//  Copyright © 2020 SBrowser. All rights reserved.
//

import Foundation

extension URL {
    
    static let blank = URL(string: "about:blank")!
    static let aboutSBrowser = URL(string: "about:SBrowser")!
    static let credits = Bundle.main.url(forResource: "credits", withExtension: "html")!
    
    //static let start = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last!.appendingPathComponent("newTab.html")
    
    static var start: URL {
        
        let dU = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last!.appendingPathComponent("newTab.html")
        
        if let defaultHomePage = UserDefaults.standard.value(forKey: kHomePage) as? String {
            if defaultHomePage != "default" && (defaultHomePage as? NSString)?.lastPathComponent != "newTab.html" {
                return URL(string: defaultHomePage) ?? dU
            }
        }
        
        return dU
    }
    
    var withFixedScheme: URL? {
        switch scheme?.lowercased() {
        case "sbrowserhttp":
            var urlc = URLComponents(url: self, resolvingAgainstBaseURL: true)
            urlc?.scheme = "http"
            
            return urlc?.url
            
        case "sbrowserhttps":
            var urlc = URLComponents(url: self, resolvingAgainstBaseURL: true)
            urlc?.scheme = "https"
            
            return urlc?.url
            
        default:
            return self
        }
    }
    
    var real: URL {
        switch self {
        case URL.aboutSBrowser:
            return URL.credits
        default:
            return self
        }
    }
    
    var clean: URL? {
        switch self {
        case URL.credits:
            return URL.aboutSBrowser
            
        case URL.start:
            //ps//return nil
            let url = URL.start
            if url.lastPathComponent != "newTab.html" {
                  return URL.start
            }
            return nil
        default:
            return self
        }
    }
    
    var isSpecial: Bool {
        switch self {
        case URL.blank, URL.aboutSBrowser, URL.credits, URL.start:
            
            //vishnu
            if self.absoluteString != "default" && (self.absoluteString as? NSString)?.lastPathComponent != "newTab.html" {
                return false
            }
            //
            return true
            
        default:
            return false
        }
    }
}

@objc
extension NSURL {
    var withFixedScheme: NSURL? {
        return (self as URL).withFixedScheme as NSURL?
    }
}
