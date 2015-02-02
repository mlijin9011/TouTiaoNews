//
//  TTNewsModel.swift
//  TouTiaoNews
//
//  Created by LiJin on 15/1/28.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

enum TTNewsModelViewType : Int {
    // Default: default/"skipType":"special"/"skipType":"photoset"/"skipType":"live"/"TAG":"dujia"/"TAG":"shipin"/"TAG":"yuyin"
    // Default: "title"/"digest"/"imgsrc"/"skipType"/"TAG"/"replyCount"/"url_3w"/"imgextra"
    case Default
    // TopType: default/"skipType":"special"/"skipType":"photoset"/"skipType":"live"/"TAG":"dujia"/"TAG":"shipin"/"TAG":"yuyin"
    // Top: "template"/"title"/"digest"/"imgsrc"/"skipType"/"TAG"/"replyCount"/"url_3w"/"imgextra"
    case Top
    // PhotoSetType: default
    // PhotoSet: "title"/"digest"/"imgsrc"/"skipType"/"replyCount"/"url_3w"/"imgextra"
    case PhotoSet
    // EditorType: default/"skipType":"special"/"skipType":"photoset"/"skipType":"live"/"TAG":"dujia"/"TAG":"shipin"/"TAG":"yuyin"
    // Editor: "editor"/"title"/"digest"/"imgsrc"/"skipType"/"TAG"/"replyCount"/"url_3w"/"imgextra"
    case Editor
}

/**
 *  Model
 */
class TTNewsModel : NSObject {
    
    var viewType: TTNewsModelViewType?
    var title: String?
    var imgsrc: String?
    var replyCount: Int?
    var digest: String?
    var skipType: String?
    var tag: String?
    var url_3w: String?
    var photosets: Array<String>?
    
    override init() {
        super.init()
        self.viewType = TTNewsModelViewType.Default
        self.title = ""
        self.imgsrc = ""
        self.replyCount = 0
        self.digest = ""
        self.skipType = ""
        self.tag = ""
        self.url_3w = ""
        self.photosets = Array<String>()
    }
    
    class func initNewsModelWithDictionary(dic: Dictionary<String, AnyObject>, needTop: Bool) -> TTNewsModel {
        var model = TTNewsModel()
        model.title = dic["title"] as? String
        model.imgsrc = dic["imgsrc"] as? String
        
        if (dic.indexForKey("skipType") != nil) {
            model.skipType = dic["skipType"] as? String
            if (dic.indexForKey("editor") != nil) {
                model.viewType = TTNewsModelViewType.Editor
            } else if (dic.indexForKey("template") != nil && ((dic["template"] as? String) == "manual")) {
                if (needTop) {
                    model.viewType = TTNewsModelViewType.Top
                }
            } else if (dic.indexForKey("imgextra") != nil) {
                let photos = dic["imgextra"] as? Array<Dictionary<String, String>>
                model.photosets?.append(model.imgsrc!)
                if (photos != nil) {
                    model.viewType = TTNewsModelViewType.PhotoSet
                    for photoDic in photos! {
                        model.photosets?.append(photoDic["imgsrc"]!)
                    }
                }
            }
        } else {
            if (dic.indexForKey("editor") != nil) {
                model.viewType = TTNewsModelViewType.Editor
            } else if (dic.indexForKey("template") != nil && ((dic["template"] as? String) == "manual")) {
                if (needTop) {
                    model.viewType = TTNewsModelViewType.Top
                }
            } else if (dic.indexForKey("imgextra") != nil) {
                let photos = dic["imgextra"] as? Array<Dictionary<String, String>>
                model.photosets?.append(model.imgsrc!)
                if (photos != nil) {
                    model.viewType = TTNewsModelViewType.PhotoSet
                    for photoDic in photos! {
                        model.photosets?.append(photoDic["imgsrc"]!)
                    }
                }
            }
        }
        if (dic.indexForKey("replyCount") != nil) {
            model.replyCount = dic["replyCount"] as? Int
        }
        if (dic.indexForKey("digest") != nil) {
            model.digest = dic["digest"] as? String
        }
        if (dic.indexForKey("TAG") != nil) {
            model.tag = dic["TAG"] as? String
        }
        if (dic.indexForKey("url_3w") != nil) {
            model.url_3w = dic["url_3w"] as? String
        }
        
        return model
    }
}
