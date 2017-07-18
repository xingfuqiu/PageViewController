//
//  ViewController.swift
//  test
//
//  Created by XingfuQiu on 2017/7/18.
//  Copyright © 2017年 XingfuQiu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DEMO"
        let zeVC = CoinPageViewController()
        self.addChildViewController(zeVC)
        self.view.addSubview(zeVC.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

