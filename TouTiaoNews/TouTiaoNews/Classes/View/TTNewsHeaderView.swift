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
        self.imageView!.clipsToBounds = true
        self.addSubview(self.imageView!)
        
        self.tagImageView = UIImageView(frame: CGRectZero)
        self.tagImageView!.contentMode = UIViewContentMode.Center
        self.addSubview(self.tagImageView!)
        
        self.titleLabel = UILabel(frame: CGRectZero)
        self.titleLabel!.textAlignment = NSTextAlignment.Left
        self.titleLabel!.font = self.titleLabel!.font.fontWithSize(14)
        self.addSubview(self.titleLabel!)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(model: TTNewsModel) {
        self.imageView!.sd_setImageWithURL(NSURL(string: model.imgsrc!), placeholderImage: UIImage(named: "big_loadpic_empty_listpage"))
        self.imageView!.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - 35)
        
        self.titleLabel!.text = model.title
        
        model.skipType = ""
        model.tag = ""
        if !model.skipType!.isEmpty {
            if (model.skipType == "photoset") {
                self.tagImageView!.image = UIImage(named: "cell_tag_photo")
                self.tagImageView!.frame = CGRect(x: 10, y: self.bounds.height - 26, width: 16, height: 16)
                self.titleLabel!.frame = CGRect(x: 10 + 16 + 6, y: self.bounds.height - 28, width: self.bounds.width - 32 - 10, height: 20)
            } else if (model.skipType == "special") {
                self.tagImageView!.image = UIImage(named: "contentview_special")
                self.tagImageView!.frame = CGRect(x: 15, y: self.bounds.height - 26, width: 16, height: 16)
                self.titleLabel!.frame = CGRect(x: 15 + 16 + 12, y: self.bounds.height - 28, width: self.bounds.width - 43 - 10, height: 20)
            } else if (model.skipType == "live") {
                self.tagImageView!.image = UIImage(named: "contentview_live")
                self.tagImageView!.frame = CGRect(x: 15, y: self.bounds.height - 26, width: 16, height: 16)
                self.titleLabel!.frame = CGRect(x: 15 + 16 + 12, y: self.bounds.height - 28, width: self.bounds.width - 43 - 10, height: 20)
            }
        } else if !model.tag!.isEmpty {
            if (model.tag == NSLocalizedString("news_tag_dujia", comment: "")) {
                self.tagImageView!.image = UIImage(named: "contentview_dujia")
                self.tagImageView!.frame = CGRect(x: 15, y: self.bounds.height - 26, width: 16, height: 16)
                self.titleLabel!.frame = CGRect(x: 15 + 16 + 12, y: self.bounds.height - 28, width: self.bounds.width - 43 - 10, height: 20)
            } else if (model.tag == NSLocalizedString("news_tag_shipin", comment: "")) {
                self.tagImageView!.image = UIImage(named: "cell_tag_video")
                self.tagImageView!.frame = CGRect(x: 10, y: self.bounds.height - 26, width: 16, height: 16)
                self.titleLabel!.frame = CGRect(x: 10 + 16 + 6, y: self.bounds.height - 28, width: self.bounds.width - 32 - 10, height: 20)
            } else if (model.tag == NSLocalizedString("news_tag_yuyin", comment: "")) {
                self.tagImageView!.image = UIImage(named: "cell_tag_audio")
                self.tagImageView!.frame = CGRect(x: 10, y: self.bounds.height - 26, width: 16, height: 16)
                self.titleLabel!.frame = CGRect(x: 10 + 16 + 6, y: self.bounds.height - 28, width: self.bounds.width - 32 - 10, height: 20)
            }
        } else {
            self.titleLabel!.frame = CGRect(x: 10, y: self.bounds.height - 28, width: self.bounds.width - 10 - 10, height: 20)
        }
    }
}
