//
//  TTNewsTableViewCell.swift
//  TouTiaoNews
//
//  Created by LiJin on 15/1/28.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

class TTNewsTableViewCell : UITableViewCell {

    let cellSpace = 10.0
    
    var coverImageView: UIImageView?
    var coverTitleLabel: UILabel?
    var coverDigestLabel: UILabel?
    var replyCountLabel: UILabel?
    var replyCountImageView: UIImageView?
    var tagImageView: UIImageView?
    
    var photosetFirstImageView: UIImageView?
    var photosetSecondImageView: UIImageView?
    var photosetThirdImageView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.coverImageView = UIImageView(frame: CGRectZero)
        self.coverImageView!.contentMode = UIViewContentMode.ScaleAspectFill
        self.coverImageView!.clipsToBounds = true
        self.addSubview(self.coverImageView!)

        self.coverTitleLabel = UILabel(frame: CGRectZero)
        self.coverTitleLabel!.font = self.coverTitleLabel!.font.fontWithSize(16)
        self.coverTitleLabel!.textColor = UIColor.blackColor()
        self.coverTitleLabel!.backgroundColor = UIColor.clearColor()
        self.addSubview(self.coverTitleLabel!)
        
        self.coverDigestLabel = UILabel(frame: CGRectZero)
        self.coverDigestLabel!.font = self.coverTitleLabel!.font.fontWithSize(13)
        self.coverDigestLabel!.textColor = UIColor.lightGrayColor()
        self.coverDigestLabel!.backgroundColor = UIColor.clearColor()
        self.coverDigestLabel!.numberOfLines = 2
        self.coverDigestLabel!.lineBreakMode = NSLineBreakMode.ByCharWrapping
        self.addSubview(self.coverDigestLabel!)

        self.replyCountLabel = UILabel(frame: CGRectZero)
        self.replyCountLabel!.textColor = UIColor.lightGrayColor()
        self.replyCountLabel!.backgroundColor = UIColor.clearColor()
        self.replyCountLabel!.font = self.replyCountLabel!.font.fontWithSize(12)
        self.replyCountLabel!.textAlignment = NSTextAlignment.Right
        self.addSubview(self.replyCountLabel!)
        
        self.replyCountImageView = UIImageView(frame: CGRectZero)
//        self.replyCountImageView!.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubview(self.replyCountImageView!)
        
        self.tagImageView = UIImageView(frame: CGRectZero)
        self.tagImageView!.contentMode = UIViewContentMode.Center
        self.addSubview(self.tagImageView!)
        
        self.photosetFirstImageView = UIImageView(frame: CGRectZero)
        self.photosetFirstImageView!.contentMode = UIViewContentMode.ScaleAspectFill
        self.photosetFirstImageView!.clipsToBounds = true
        self.addSubview(self.photosetFirstImageView!)
        
        self.photosetSecondImageView = UIImageView(frame: CGRectZero)
        self.photosetSecondImageView!.contentMode = UIViewContentMode.ScaleAspectFill
        self.photosetSecondImageView!.clipsToBounds = true
        self.addSubview(self.photosetSecondImageView!)
        
        self.photosetThirdImageView = UIImageView(frame: CGRectZero)
        self.photosetThirdImageView!.contentMode = UIViewContentMode.ScaleAspectFill
        self.photosetThirdImageView!.clipsToBounds = true
        self.addSubview(self.photosetThirdImageView!)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.resetImageView(self.coverImageView!)
        self.coverTitleLabel!.frame = CGRectZero
        self.coverDigestLabel!.frame = CGRectZero
        self.replyCountLabel!.frame = CGRectZero
        self.resetImageView(self.replyCountImageView!)
        self.resetImageView(self.tagImageView!)
        self.resetImageView(self.photosetFirstImageView!)
        self.resetImageView(self.photosetSecondImageView!)
        self.resetImageView(self.photosetThirdImageView!)
    }
    
    func resetImageView(imageView: UIImageView) {
        imageView.image = nil
        imageView.frame = CGRectZero
    }

    func fillCellWithNewsModel(model: TTNewsModel) -> Void {
        if (model.viewType == TTNewsModelViewType.PhotoSet) {
            self.setPhotosetCellData(model)
        } else if (model.viewType == TTNewsModelViewType.Editor) {
            self.setEditorCellData(model)
        } else {
            self.setDefaultNewsCellData(model)
        }
    }
    
    func setPhotosetCellData(model: TTNewsModel) {
        self.coverTitleLabel!.text = model.title
        self.coverTitleLabel!.frame = CGRectMake(10, 10, CGRectGetWidth(self.bounds) - 10 - 10 - 60, 18)
        
        if (model.replyCount! > 0) {
            if (model.replyCount > 10000) {
                var replyCount = NSString(format: "%.1f万", Float(model.replyCount!)/Float(10000))
                self.replyCountLabel!.text = "\(replyCount)跟帖"
            } else {
                self.replyCountLabel!.text = "\(model.replyCount!)跟帖"
            }
            
            var text: NSString = NSString(CString: self.replyCountLabel!.text!.cStringUsingEncoding(NSUTF8StringEncoding)!, encoding: NSUTF8StringEncoding)!
            var textSize = text.sizeWithAttributes(NSDictionary(object: self.replyCountLabel!.font, forKey: NSFontAttributeName))
            self.replyCountLabel!.frame = CGRectMake(CGRectGetWidth(self.bounds) - textSize.width - 12, CGRectGetMinY(self.coverTitleLabel!.frame) + 2, textSize.width, 15)
            
            self.replyCountImageView!.image = UIImage(named: "cola_bubble_gray")
            self.replyCountImageView!.frame = CGRectMake(CGRectGetMinX(self.replyCountLabel!.frame) - 4, CGRectGetMinY(self.replyCountLabel!.frame), CGRectGetWidth(self.replyCountLabel!.frame) + 8, CGRectGetHeight(self.replyCountLabel!.frame))
        }
        
        if (model.photosets!.count == 3) {
            self.photosetFirstImageView!.sd_setImageWithURL(NSURL(string: model.photosets![0]), placeholderImage: UIImage(named: "big_loadpic_empty_listpage"))
            self.photosetFirstImageView!.frame = CGRectMake(CGRectGetMinX(self.coverTitleLabel!.frame), CGRectGetMaxY(self.coverTitleLabel!.frame) + 11, 97, 68)
            
            self.photosetSecondImageView!.sd_setImageWithURL(NSURL(string: model.photosets![1]), placeholderImage: UIImage(named: "big_loadpic_empty_listpage"))
            self.photosetSecondImageView!.frame = CGRectMake(CGRectGetMaxX(self.photosetFirstImageView!.frame) + 5, CGRectGetMinY(self.photosetFirstImageView!.frame), CGRectGetWidth(self.photosetFirstImageView!.frame), CGRectGetHeight(self.photosetFirstImageView!.frame))
            
            self.photosetThirdImageView!.sd_setImageWithURL(NSURL(string: model.photosets![2]), placeholderImage: UIImage(named: "big_loadpic_empty_listpage"))
            self.photosetThirdImageView!.frame = CGRectMake(CGRectGetMaxX(self.photosetSecondImageView!.frame) + 5, CGRectGetMinY(self.photosetSecondImageView!.frame), CGRectGetWidth(self.photosetSecondImageView!.frame), CGRectGetHeight(self.photosetSecondImageView!.frame))
        }
    }
    
    func setEditorCellData(model: TTNewsModel) {
        self.coverTitleLabel!.text = model.title
        self.coverTitleLabel!.frame = CGRectMake(10, 10, CGRectGetWidth(self.bounds) - 20, 20)
        
        self.coverImageView!.sd_setImageWithURL(NSURL(string: model.imgsrc!), placeholderImage: UIImage(named: "big_loadpic_empty_listpage"))
        self.coverImageView!.frame = CGRectMake(CGRectGetMinX(self.coverTitleLabel!.frame), CGRectGetMaxY(self.coverTitleLabel!.frame) + 8, CGRectGetWidth(self.bounds) - 26, 100)
        
        model.digest! = "学者官员双重身份，不利高效去行政化，学者官员双重身份，不利高效去行政化"
        if (!model.digest!.isEmpty) {
            self.coverDigestLabel!.text = model.digest
            self.coverDigestLabel!.frame = CGRectMake(CGRectGetMinX(self.coverTitleLabel!.frame), CGRectGetMaxY(self.coverImageView!.frame) + 8, CGRectGetWidth(self.coverTitleLabel!.frame), 30)
            self.setLabelLineSpacing(self.coverDigestLabel!)
        } else {
            self.coverDigestLabel!.text = ""
            self.coverDigestLabel!.frame = CGRectMake(CGRectGetMinX(self.coverTitleLabel!.frame), CGRectGetMaxY(self.coverImageView!.frame) + 8, CGRectGetWidth(self.coverTitleLabel!.frame), 30)
        }
        
        if !model.skipType!.isEmpty {
            if (model.skipType == "photoset") {
                self.tagImageView!.image = UIImage(named: "cell_tag_photo")
                self.tagImageView!.frame = CGRectMake(CGRectGetWidth(self.bounds) - 25, CGRectGetMaxY(self.coverImageView!.frame) + 28, 20, 14);
            } else if (model.skipType == "special") {
                self.tagImageView!.image = UIImage(named: "contentview_special")
                self.tagImageView!.frame = CGRectMake(CGRectGetWidth(self.bounds) - 40, CGRectGetMaxY(self.coverImageView!.frame) + 28, 35, 14);
                model.replyCount = 0
            } else if (model.skipType == "live") {
                self.tagImageView!.image = UIImage(named: "contentview_live")
                self.tagImageView!.frame = CGRectMake(CGRectGetWidth(self.bounds) - 40, CGRectGetMaxY(self.coverImageView!.frame) + 28, 35, 14);
            }
        } else if !model.tag!.isEmpty {
            println(self.coverDigestLabel!.frame)
            if (model.tag == NSLocalizedString("news_tag_dujia", comment: "")) {
                self.tagImageView!.image = UIImage(named: "contentview_dujia")
                self.tagImageView!.frame = CGRectMake(CGRectGetWidth(self.bounds) - 40, CGRectGetMaxY(self.coverImageView!.frame) + 28, 35, 14);
            } else if (model.tag == NSLocalizedString("news_tag_shipin", comment: "")) {
                self.tagImageView!.image = UIImage(named: "cell_tag_video")
                self.tagImageView!.frame = CGRectMake(CGRectGetWidth(self.bounds) - 25, CGRectGetMaxY(self.coverImageView!.frame) + 28, 20, 14);
            } else if (model.tag == NSLocalizedString("news_tag_yuyin", comment: "")) {
                self.tagImageView!.image = UIImage(named: "cell_tag_audio")
                self.tagImageView!.frame = CGRectMake(CGRectGetWidth(self.bounds) - 25, CGRectGetMaxY(self.coverImageView!.frame) + 28, 20, 14);
            }
        }
        if (model.replyCount! > 0) {
            if (model.replyCount > 10000) {
                var replyCount = NSString(format: "%.1f万", Float(model.replyCount!)/Float(10000))
                self.replyCountLabel!.text = "\(replyCount)跟帖"
            } else {
                self.replyCountLabel!.text = "\(model.replyCount!)跟帖"
            }
            var text: NSString = NSString(CString: self.replyCountLabel!.text!.cStringUsingEncoding(NSUTF8StringEncoding)!, encoding: NSUTF8StringEncoding)!
            var textSize = text.sizeWithAttributes(NSDictionary(object: self.replyCountLabel!.font, forKey: NSFontAttributeName))
            if (self.tagImageView!.frame.width == 0) {
                self.replyCountLabel!.frame = CGRectMake(CGRectGetWidth(self.bounds) - textSize.width - 10, CGRectGetMaxY(self.coverImageView!.frame) + 28, textSize.width, 15)
            } else {
                self.replyCountLabel!.frame = CGRectMake(CGRectGetMinX(self.tagImageView!.frame) - textSize.width - 5, CGRectGetMaxY(self.coverImageView!.frame) + 28, textSize.width, 15)
            }
            
            self.replyCountImageView!.image = UIImage(named: "cola_bubble_gray")
            self.replyCountImageView!.frame = CGRectMake(CGRectGetMinX(self.replyCountLabel!.frame) - 4, CGRectGetMinY(self.replyCountLabel!.frame), CGRectGetWidth(self.replyCountLabel!.frame) + 8, CGRectGetHeight(self.replyCountLabel!.frame))
        }
    }
    
    func setDefaultNewsCellData(model: TTNewsModel) {
        // MARK: - Default
        self.coverImageView!.sd_setImageWithURL(NSURL(string: model.imgsrc!), placeholderImage: UIImage(named: "big_loadpic_empty_listpage"))
        self.coverImageView!.frame = CGRectMake(10, 10, 75, 60)
        
        self.coverTitleLabel!.text = model.title
        self.coverTitleLabel!.frame = CGRectMake(CGRectGetMaxX(self.coverImageView!.frame) + 8, CGRectGetMinY(self.coverImageView!.frame),CGRectGetWidth(self.bounds) - CGRectGetMaxX(self.coverImageView!.frame) - 8, 18)
        
        if (!model.digest!.isEmpty) {
            self.coverDigestLabel!.text = model.digest
            self.coverDigestLabel!.frame = CGRectMake(CGRectGetMinX(self.coverTitleLabel!.frame), CGRectGetMaxY(self.coverTitleLabel!.frame) + 7, CGRectGetWidth(self.coverTitleLabel!.frame) - 10, 30)
            self.setLabelLineSpacing(self.coverDigestLabel!)
        }
        if !model.skipType!.isEmpty {
            if (model.skipType == "photoset") {
                self.tagImageView!.image = UIImage(named: "cell_tag_photo")
                self.tagImageView!.frame = CGRectMake(CGRectGetWidth(self.bounds) - 25, CGRectGetMaxY(self.coverImageView!.frame) - 15, 20, 14);
            } else if (model.skipType == "special") {
                self.tagImageView!.image = UIImage(named: "contentview_special")
                self.tagImageView!.frame = CGRectMake(CGRectGetWidth(self.bounds) - 40, CGRectGetMaxY(self.coverImageView!.frame) - 15, 35, 14);
                model.replyCount = 0
            } else if (model.skipType == "live") {
                self.tagImageView!.image = UIImage(named: "contentview_live")
                self.tagImageView!.frame = CGRectMake(CGRectGetWidth(self.bounds) - 40, CGRectGetMaxY(self.coverImageView!.frame) - 15, 35, 14);
            }
        } else if !model.tag!.isEmpty {
            if (model.tag == NSLocalizedString("news_tag_dujia", comment: "")) {
                self.tagImageView!.image = UIImage(named: "contentview_dujia")
                self.tagImageView!.frame = CGRectMake(CGRectGetWidth(self.bounds) - 40, CGRectGetMaxY(self.coverImageView!.frame) - 15, 35, 14);
            } else if (model.tag == NSLocalizedString("news_tag_shipin", comment: "")) {
                self.tagImageView!.image = UIImage(named: "cell_tag_video")
                self.tagImageView!.frame = CGRectMake(CGRectGetWidth(self.bounds) - 25, CGRectGetMaxY(self.coverImageView!.frame) - 15, 20, 14);
            } else if (model.tag == NSLocalizedString("news_tag_yuyin", comment: "")) {
                self.tagImageView!.image = UIImage(named: "cell_tag_audio")
                self.tagImageView!.frame = CGRectMake(CGRectGetWidth(self.bounds) - 25, CGRectGetMaxY(self.coverImageView!.frame) - 15, 20, 14);
            }
        }
        if (model.replyCount! > 0) {
            if (model.replyCount > 10000) {
                var replyCount = NSString(format: "%.1f万", Float(model.replyCount!)/Float(10000))
                self.replyCountLabel!.text = "\(replyCount)跟帖"
            } else {
                self.replyCountLabel!.text = "\(model.replyCount!)跟帖"
            }
            var text: NSString = NSString(CString: self.replyCountLabel!.text!.cStringUsingEncoding(NSUTF8StringEncoding)!, encoding: NSUTF8StringEncoding)!
            var textSize = text.sizeWithAttributes(NSDictionary(object: self.replyCountLabel!.font, forKey: NSFontAttributeName))
            if (self.tagImageView!.frame.width == 0) {
                self.replyCountLabel!.frame = CGRectMake(CGRectGetWidth(self.bounds) - textSize.width - 10, CGRectGetMaxY(self.coverImageView!.frame) - 15, textSize.width, 15)
            } else {
                self.replyCountLabel!.frame = CGRectMake(CGRectGetMinX(self.tagImageView!.frame) - textSize.width - 5, CGRectGetMaxY(self.coverImageView!.frame) - 15, textSize.width, 15)
            }
            
            self.replyCountImageView!.image = UIImage(named: "cola_bubble_gray")
            self.replyCountImageView!.frame = CGRectMake(CGRectGetMinX(self.replyCountLabel!.frame) - 4, CGRectGetMinY(self.replyCountLabel!.frame), CGRectGetWidth(self.replyCountLabel!.frame) + 8, CGRectGetHeight(self.replyCountLabel!.frame))
        }
    }
    
    func setLabelLineSpacing(label: UILabel) -> Void {
        var text: NSString = NSString(CString: label.text!.cStringUsingEncoding(NSUTF8StringEncoding)!, encoding: NSUTF8StringEncoding)!
        var attributedString = NSMutableAttributedString(string: text)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, text.length))
        label.attributedText = attributedString
        label.sizeToFit()
    }
}
