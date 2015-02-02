//
//  HomeViewController.swift
//  TouTiaoNews
//
//  Created by LiJin on 15/1/4.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

class HomeViewController : TTBaseViewController, iCarouselDataSource, iCarouselDelegate, DataManagerDelegate {
    var allChannelList = Array<Array<TTNewsChannel>>()
    var recommendTitleList = Array<String>()
    var unrecommendTitleList = Array<String>()
    
    var segmentControl: XTSegmentControl?
    var carousel: iCarousel?
    var editButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getNewsChannels()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = NSLocalizedString("tab_home", comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UI Method
    func addSegmentControlView() -> Void {
        let space: CGFloat = 10
        let editSegmentWidth: CGFloat = 40
        let segmentWidth: CGFloat = self.view.bounds.width - space * 2 - editSegmentWidth
        let segmentHeight: CGFloat = 40
        
        self.carousel = iCarousel(frame: CGRect(x: 0, y: segmentHeight, width: self.view.bounds.width, height: self.view.bounds.height - segmentHeight))
        self.carousel?.backgroundColor = UIColor.whiteColor()
        self.carousel?.dataSource = self
        self.carousel?.delegate = self
        self.carousel?.type = iCarouselType.Linear
        self.carousel?.pagingEnabled = true
        self.carousel?.bounceDistance = 0.4
        self.view.addSubview(self.carousel!)

        weak var weakCarousel = self.carousel
        self.segmentControl = XTSegmentControl(frame: CGRect(x: space, y: 0, width: segmentWidth, height: segmentHeight), items: self.recommendTitleList, selectedBlock: { (index: Int) in
            let pageIndex = index
            weakCarousel?.scrollToItemAtIndex(pageIndex, animated: false)
        })
        self.view.addSubview(self.segmentControl!)
        
        self.editButton = UIButton(frame: CGRect(x: segmentWidth + space + space/2, y: 0, width: editSegmentWidth, height: segmentHeight))
        self.editButton?.setImage(UIImage(named: "unfold_channelbar"), forState: UIControlState.Normal)
        self.view.addSubview(self.editButton!);
    }
    
    // MARK: - Data Method
    func getNewsChannels() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        DataManager.sharedInstance.delegate = self
        DataManager.sharedInstance.getNewsChannelsAsync()
    }
    
    // MARK: - iCarouselDataSource
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
        return self.recommendTitleList.count
    }
    
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, reusingView view: UIView!) -> UIView! {
        var listView: TTNewsPageView?
        var contentView: UIView?
        if (view == nil) {
            contentView = UIView(frame: carousel.bounds)
            listView = TTNewsPageView(frame: contentView!.frame)
            listView!.tag = 1;
            contentView!.addSubview(listView!)
        } else {
            contentView = view
            listView = contentView!.viewWithTag(1) as? TTNewsPageView
        }
        listView!.getNewsList((self.allChannelList[0])[index])
        
        return contentView
    }
    
    // MARK: - iCarouselDelegate
    func carouselDidScroll(carousel: iCarousel!) {
        if (self.segmentControl != nil) {
            var offset = carousel.scrollOffset
            if (offset > 0) {
                self.segmentControl?.moveIndexWithProgress(Double(offset))
            }
        }
    }
    
    func carouselDidEndScrollingAnimation(carousel: iCarousel!) {
        NSLog("carouselDidEndScrollingAnimation")
        if (self.segmentControl != nil) {
            self.segmentControl?.endMoveIndex(carousel.currentItemIndex)
        }
    }
    
    // MARK: - DataManagerDelegate
    func dataResponseSuccess(responseData: AnyObject, tag: DataResquestTag) -> Void {
        switch tag {
        case DataResquestTag.NewsChannels:
            self.allChannelList = responseData as Array<Array<TTNewsChannel>>
            
            var recommendChannelList = self.allChannelList[0]
            var unrecommendChannelList = self.allChannelList[1]
            
            for channel in recommendChannelList {
                self.recommendTitleList.append(channel.tname)
            }
            for channel in unrecommendChannelList {
                self.unrecommendTitleList.append(channel.tname)
            }
            
            self.addSegmentControlView()
        default:
            "Default"
        }
        
    }
    
    func dataResponseFailed(error: NSError, tag: DataResquestTag) -> Void {
        
    }
}
