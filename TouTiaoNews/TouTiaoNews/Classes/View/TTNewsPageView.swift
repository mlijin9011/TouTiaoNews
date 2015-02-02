//
//  TTNewsPageView.swift
//  TouTiaoNews
//
//  Created by LiJin on 15/1/15.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

class TTNewsPageView : UIView, UITableViewDataSource, UITableViewDelegate, DataManagerDelegate {
    
    var contentTableView: UITableView?
    var dataSource: Array<AnyObject>?
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addContentView()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addContentView() -> Void {
        self.contentTableView = UITableView(frame: self.bounds, style: UITableViewStyle.Plain)
        self.contentTableView?.dataSource = self
        self.contentTableView?.delegate = self
        self.addSubview(self.contentTableView!)
    }
    
    func getNewsList(currentChannel: TTNewsChannel) {
        DataManager.sharedInstance.delegate = self
        DataManager.sharedInstance.getNewsListAsync(currentChannel, pageNumber: 0)
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (self.dataSource != nil && self.dataSource?.count > 0) {
            return 2
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.dataSource?.count > 0 && section == 0) {
            return 1
        }
        
        return (self.dataSource?.count)! - 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let CellIdentify = "HeaderCell"
            
            let header = self.dataSource![0] as TTNewsModel
            
            var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentify) as? UITableViewCell
            var headerView: TTNewsHeaderView?
            if (cell == nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentify)
                headerView = TTNewsHeaderView(frame: CGRect(x: 0, y: 0, width: cell!.bounds.width, height: 180))
                headerView!.tag = 100001
                cell!.addSubview(headerView!)
            } else {
                headerView = cell?.viewWithTag(100001) as? TTNewsHeaderView
            }
            headerView!.setModel(header)
            
            return cell!
        } else {
            let CellIdentify = "ListCell"
            
            let model = self.dataSource![indexPath.row + 1] as TTNewsModel
            
            var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentify) as? TTNewsTableViewCell
            
            if (cell == nil) {
                cell = TTNewsTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentify)
            }
            cell!.fillCellWithNewsModel(model)
            
            return cell!
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 180
        }

        return self.cellHeightForNewsModel(self.dataSource![indexPath.row + 1] as TTNewsModel)
    }
    
    func cellHeightForNewsModel(model: TTNewsModel) -> CGFloat {
        if (model.viewType == TTNewsModelViewType.PhotoSet) {
            return 120
        } else if (model.viewType == TTNewsModelViewType.Editor) {
            return 200
        }
        return 80
    }
    
    // MARK: - DataManagerDelegate
    func dataResponseSuccess(responseData: AnyObject, tag: DataResquestTag) -> Void {
        MBProgressHUD.hideHUDForView(self, animated: true)
        switch tag {
        case DataResquestTag.NewsList:
            self.dataSource = responseData as? Array<AnyObject>
            self.contentTableView?.reloadData()
        default:
            "Default"
        }
        
    }
    
    func dataResponseFailed(error: NSError, tag: DataResquestTag) -> Void {
        
    }
}
