//
//  DataManager.swift
//  TouTiaoNews
//
//  Created by LiJin on 15/1/15.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit
import CoreData

enum DataResquestTag : Int {
    case NewsChannels
    case NewsList
}

class DataManager : NSObject, NetworkManagerDelegate {
    
    class var sharedInstance: DataManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: DataManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = DataManager()
        }
        return Static.instance!
    }
    
    var delegate: DataManagerDelegate?
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    lazy var managedObjectContext: NSManagedObjectContext? = {
        if let managedObjectContext = self.appDelegate.cdh.managedObjectContext {
            return managedObjectContext
        } else {
            return nil
        }
    }()
    
    var recommendChannels : Dictionary<String, NSNumber>?
    var unrecommendChannels : Dictionary<String, NSNumber>?
    
    func getNewsChannelsAsync() -> Void {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var allChannelList = Array<Array<TTNewsChannel>>()
            var recommendChannelList = Array<TTNewsChannel>()
            var unrecommendChannelList = Array<TTNewsChannel>()
            
            // 1. Get news channel list from db
            var error: NSError? = nil
            var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "TTNewsChannel")
            var sorter: NSSortDescriptor = NSSortDescriptor(key: "recommendOrder", ascending: true)
            fetchRequest.sortDescriptors = [sorter]
            
            var result = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as Array<TTNewsChannel>
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    NSLog("getNewsChannelsAsync from DB with Error: \(error?.description)")
                    self.delegate?.dataResponseFailed(error!, tag: DataResquestTag.NewsChannels)
                })
            } else if (result.count > 0) {
                for channel: TTNewsChannel in result {
                    NSLog("getNewsChannelsAsync from DB fetched TTNewsChannel for \(channel.tname) ")
                    if channel.recommend.boolValue {
                        recommendChannelList.append(channel)
                    } else {
                        unrecommendChannelList.append(channel)
                    }
                }
                allChannelList.append(recommendChannelList)
                allChannelList.append(unrecommendChannelList)
                
                dispatch_async(dispatch_get_main_queue(), {
                    NSLog("getNewsChannelsAsync from DB Success!!")
                    self.delegate?.dataResponseSuccess(allChannelList, tag: DataResquestTag.NewsChannels)
                })
            } else {
                // 2. Get news channel list from network
                dispatch_async(dispatch_get_main_queue(), {
                    NetworkManager.sharedInstance.getNewsChannelsAsync(self)
                })
            }
        })
    }
    
    func parseAndSaveNetChannelData(channelData: NSData) -> Array<Array<TTNewsChannel>> {
        var allChannelList = Array<Array<TTNewsChannel>>()
        var recommendChannelList = Array<TTNewsChannel>()
        var unrecommendChannelList = Array<TTNewsChannel>()
        
        let jsonArray = NSJSONSerialization.JSONObjectWithData(channelData, options: NSJSONReadingOptions.MutableContainers, error: nil) as Array<Dictionary<String, AnyObject>>
        self.getDefaultNewsChannels()
        for cListDic in jsonArray {
            let cListType = cListDic["type"] as String
            if (cListType == NSLocalizedString("news_channel_wangyi", comment: "")) {
                var cList = cListDic["cList"] as Array<Dictionary<String, AnyObject>>
                var channelList: Array<Dictionary<String, AnyObject>>
                for channelListDic in cList {
                    channelList = channelListDic["tList"] as Array<Dictionary<String, AnyObject>>
                    for channelDic in channelList {
                        var channelEntity = NSEntityDescription.insertNewObjectForEntityForName("TTNewsChannel", inManagedObjectContext: self.managedObjectContext!) as TTNewsChannel
                        
                        channelEntity.tid = channelDic["tid"] as String
                        channelEntity.ename = channelDic["ename"] as String
                        channelEntity.tname = channelDic["tname"] as String
                        channelEntity.headLine = (channelEntity.ename == "toutiao")
                        
                        if (self.recommendChannels!.indexForKey(channelEntity.tname) != nil) {
                            channelEntity.recommend = true
                            channelEntity.recommendOrder = self.recommendChannels![channelEntity.tname]!
                            
                            recommendChannelList.append(channelEntity)
                        } else if (self.unrecommendChannels!.indexForKey(channelEntity.tname) != nil) {
                            channelEntity.recommend = false
                            channelEntity.recommendOrder = self.unrecommendChannels![channelEntity.tname]!
                            
                            unrecommendChannelList.append(channelEntity)
                        }
                        
                        NSLog("Inserted New Family for \(channelEntity.tname) ")
                    }
                }
                
                allChannelList.append(recommendChannelList)
                allChannelList.append(unrecommendChannelList)
                
                self.appDelegate.cdh.saveContext()
            }
        }
        
        return allChannelList
    }
    
    func getDefaultNewsChannels() -> Void{
        var path = NSBundle.mainBundle().pathForResource("DefaultNewsChannels", ofType: "plist")
        let channelsDic = NSDictionary(contentsOfFile: path!)
        self.recommendChannels = channelsDic?.objectForKey("recommendChannels") as? Dictionary<String, NSNumber>
        self.unrecommendChannels = channelsDic?.objectForKey("unrecommendChannels") as? Dictionary<String, NSNumber>
    }
    
    func getNewsListAsync(currentChannel: TTNewsChannel, pageNumber: Int) -> Void {
        NSLog("Current channel : %@", currentChannel.tname)
        NetworkManager.sharedInstance.getNewsListAsync(self, currentChannel: currentChannel, pageNumber: pageNumber)
    }
    
    func parseAndSaveNetNewsData(newsData: NSData) -> Array<AnyObject> {
        var allNewsList = Array<AnyObject>()
        
        let jsonDic = NSJSONSerialization.JSONObjectWithData(newsData, options: NSJSONReadingOptions.MutableContainers, error: nil) as? Dictionary<String, Array<Dictionary<String,AnyObject>>>
        if jsonDic != nil {
            for (key,value) in jsonDic! {
                let newsArray = value
                for modelDic in newsArray {
                    let model = TTNewsModel.initNewsModelWithDictionary(modelDic, needTop: false)
                    
                    allNewsList.append(model)
                }
            }
        }
        
        return allNewsList
    }
    
    // MARK: NetworkManagerDelegate
    func networkResponseSuccess(operation: AFHTTPRequestOperation, responseObject: AnyObject, tag: DataResquestTag) -> Void {
        NSLog("Get from Network Success!!")
        var responseData: AnyObject?
        switch tag {
        case DataResquestTag.NewsChannels:
            responseData = self.parseAndSaveNetChannelData(responseObject as NSData)
        case DataResquestTag.NewsList:
            responseData = self.parseAndSaveNetNewsData(responseObject as NSData)
        default:
            "Default"
        }
        self.delegate?.dataResponseSuccess(responseData!, tag: tag)
    }
    
    func networkResponseFailed(operation: AFHTTPRequestOperation, error: NSError, tag: DataResquestTag) -> Void {
        NSLog("Get from Network with Error: \(error.description)")
        self.delegate?.dataResponseFailed(error, tag: tag)
    }
}

protocol DataManagerDelegate : NSObjectProtocol {
    func dataResponseSuccess(responseData: AnyObject, tag: DataResquestTag) -> Void
    func dataResponseFailed(error: NSError, tag: DataResquestTag) -> Void
}
