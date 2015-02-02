//
//  TTTabBarController.swift
//  TouTiaoNews
//
//  Created by LiJin on 15/1/4.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

class TTTabBarViewController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tabBarImages = ["home_tabbar_press", "dynamic_tabbar_press", "mine_tabbar_press"]
        let count = self.childViewControllers.count
        var selectedImage: UIImage
        for var i = 0; i < count; ++i {
            selectedImage = UIImage(named: tabBarImages[i])!
            (childViewControllers[i] as UIViewController).tabBarItem.selectedImage = selectedImage.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
