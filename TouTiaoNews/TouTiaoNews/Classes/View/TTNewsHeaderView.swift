//
//  TTNewsHeaderView.swift
//  TouTiaoNews
//
//  Created by LiJin on 15/1/20.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

class TTNewsHeaderView : UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var imageView: UIImageView?
    var tagImageView: UIImageView?
    var titleLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView = UIImageView(frame: CGRectZero)
        self.imageView!.contentMode = UIViewContentMode.ScaleAspectFill
        self.addSubview(self.imageView!)
        
        var subView = UIView(frame: CGRect(x: 0, y: self.bounds.height - 30, width: self.bounds.width, height: 30))
        subView.backgroundColor = UIColor.whiteColor()
        self.addSubview(subView)
        
        self.tagImageView = UIImageView(frame: CGRectZero)
        self.tagImageView!.contentMode = UIViewContentMode.Center
        self.addSubview(self.tagImageView!)
        
        self.titleLabel = UILabel(frame: CGRectZero)
        self.titleLabel!.textAlignment = NSTextAlignment.Left
        self.titleLabel!.font = self.titleLabel!.font.fontWithSize(13)
        self.addSubview(self.titleLabel!)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(model: TTNewsModel) {
        self.imageView!.sd_setImageWithURL(NSURL(string: model.imgsrc!), placeholderImage: UIImage(named: "big_loadpic_empty_listpage"))
        self.imageView!.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - 30)
        
        self.titleLabel!.text = model.title
        
        if !model.skipType!.isEmpty {
            self.titleLabel!.frame = CGRect(x: 10 + 16 + 10, y: self.bounds.height - 30, width: self.bounds.width - 36 - 10, height: 30)
            if (model.skipType == "photoset") {
                self.tagImageView!.image = UIImage(named: "cell_tag_photo")
            } else if (model.tag == "special") {
                
            } else if (model.tag == "live") {
                
            }
        } else if !model.tag!.isEmpty {
            self.titleLabel!.frame = CGRect(x: 10 + 16 + 10, y: self.bounds.height - 30, width: self.bounds.width - 36 - 10, height: 30)
            if (model.tag == NSLocalizedString("news_tag_dujia", comment: "")) {
                
            } else if (model.tag == NSLocalizedString("news_tag_shipin", comment: "")) {
                self.tagImageView!.image = UIImage(named: "cell_tag_video")
            } else if (model.tag == NSLocalizedString("news_tag_yuyin", comment: "")) {
                self.tagImageView!.image = UIImage(named: "cell_tag_audio")
            }
        } else {
            self.titleLabel!.frame = CGRect(x: 10, y: self.bounds.height - 30, width: self.bounds.width - 10 - 10, height: 30)
        }
        self.tagImageView!.frame = CGRect(x: 10, y: self.bounds.height - 30 + 7, width: 16, height: 16)
    }
}
