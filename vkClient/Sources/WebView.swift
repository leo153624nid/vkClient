//
//  WebView.swift
//  vkClient
//
//  Created by A Ch on 20.07.2024.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable { // TODO
    typealias UIViewType = WKWebView
    
//    let url = "https://google.com"
    let vkAppID = "52017937"
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: vkAppID),
//            URLQueryItem(name: "redirect_uri", value: "http://oauth.vk.com/blank.html"),
            URLQueryItem(name: "redirect_uri", value: "https://foobar.ru/auth/vk-id"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "response_type", value: "token")
        ]
        
        let req = URLRequest(url: urlComponents.url!)
        webView.load(req)
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
     
}
