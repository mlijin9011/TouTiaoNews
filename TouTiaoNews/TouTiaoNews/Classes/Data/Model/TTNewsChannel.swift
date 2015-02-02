//
//  TTNewsChannel.swift
//  TouTiaoNews
//
//  Created by LiJin on 15/1/8.
//  Copyright (c) 2015 User. All rights reserved.
//

import Foundation
import CoreData

class TTNewsChannel : NSManagedObject {

    /**
     *  "icon":"T1348648037603",
     *  "headLine":false,
     *  "num":100,
     *  "alias":"Region",
     *  "isNew":0,
     *  "recommendOrder":109,
     *  "ename":"shehui",
     *  "tname":"shehui",
     *  "isHot":0,
     *  "hasIcon":true,
     *  "tid":"T1348648037603",
     *  "recommend":"1"
     */
    
    @NSManaged var tid: String
    @NSManaged var recommend: NSNumber
    @NSManaged var ename: String
    @NSManaged var tname: String
    @NSManaged var headLine: NSNumber
    @NSManaged var recommendOrder: NSNumber

}
