//
//  NetworkManager.swift
//  TouTiaoNews
//
//  Created by LiJin on 15/1/15.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

class NetworkManager : NSObject {
    
    class var sharedInstance: NetworkManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: NetworkManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = NetworkManager()
        }
        return Static.instance!
    }
    
    let httpRequestManager = AFHTTPRequestOperationManager()
    
    func getNewsChannelsAsync(delegate: NetworkManagerDelegate) -> Void {
        httpRequestManager.responseSerializer = AFHTTPResponseSerializer()
        httpRequestManager.GET("http://c.m.163.com/nc/topicset/ios/subscribe.html",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("Response Success!!!")
                delegate.networkResponseSuccess(operation, responseObject: responseObject, tag: DataResquestTag.NewsChannels)
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Response Failed!!! and Error: " + error.localizedDescription)
                delegate.networkResponseFailed(operation, error: error, tag: DataResquestTag.NewsChannels)
        })
    }
    
    func getNewsListAsync(delegate: NetworkManagerDelegate, currentChannel: TTNewsChannel, pageNumber: Int) -> Void {
        httpRequestManager.responseSerializer = AFHTTPResponseSerializer()
        let urlString = "http://c.m.163.com/nc/article/headline/\(currentChannel.tid)/\(self.getpageIdentifyWithPageNumber(pageNumber)).html"
        println("News Request URL: " + urlString)
        httpRequestManager.GET(urlString,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("Response Success!!!")
                delegate.networkResponseSuccess(operation, responseObject: responseObject, tag: DataResquestTag.NewsList)
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Response Failed!!! and Error: " + error.localizedDescription)
                delegate.networkResponseFailed(operation, error: error, tag: DataResquestTag.NewsList)
        })
    }
    
    func getpageIdentifyWithPageNumber(pageNumber: Int) -> String {
        return "\(pageNumber * 20)-20"
    }
}

protocol NetworkManagerDelegate : NSObjectProtocol {
    func networkResponseSuccess(operation: AFHTTPRequestOperation, responseObject: AnyObject, tag: DataResquestTag) -> Void
    func networkResponseFailed(operation: AFHTTPRequestOperation, error: NSError, tag: DataResquestTag) -> Void
}
