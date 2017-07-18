//
//  CoinPageViewController.swift
//  test
//
//  Created by XingfuQiu on 2017/7/18.
//  Copyright © 2017年 XingfuQiu. All rights reserved.
//

import UIKit
/** 屏幕宽度高度 */
let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHight = UIScreen.main.bounds.size.height

/** header和menu的高度 */
let kHeaderHight: CGFloat = 200
let kMenuHight: CGFloat = 44
let kNavigationHight: CGFloat = 64
let kScrollHorizY = kMenuHight+kHeaderHight+kNavigationHight

/** 偏移方法操作枚举 */
enum headerMenuShowType:UInt {
    case up = 1 // 固定在navigation上面
    case bottom = 2 // 固定在navigation下面
}

class CoinPageViewController: UIViewController {

    /// 底部 scrollView 背景
    var backgroundScrollView: UIScrollView?
    /// tableView 数组
    var tableViewArr: [UITableViewController] = [UITableViewController]()
    /// 菜单
    var menuView: XFMenuView!
    /// HeaderView
    var headerView: UIView!
    
    /// 存放菜单的内容
    var titles: [String] = ["简介","动态","图集","视频"]
    /// 记录当偏移量 Y
    var scrollY: CGFloat = 0
    /// 记录当偏移量
    var scrollX: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        layoutBackgroundScrollView()
        layoutHeaderMenuView()

    }

    /// 底部 scrollView, 用于安装 tableViewController
    func layoutBackgroundScrollView(){
        self.backgroundScrollView = UIScrollView(frame:CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHight+kNavigationHight))
        backgroundScrollView?.isPagingEnabled = true
        backgroundScrollView?.bounces = false
        backgroundScrollView?.delegate = self
        let floatArrCount = CGFloat(titles.count)
        backgroundScrollView?.contentSize = CGSize(width: floatArrCount*kScreenWidth,height: view.frame.size.height-kNavigationHight)
        
        // 给scrollY赋初值避免一上来滑动就乱, tableView自己持有的偏移量和赋值时给的偏移量符号是相反的
        scrollY = -kScrollHorizY
        for (index, menuTitle) in titles.enumerated() {
            let floatI = CGFloat(index)
            
            let tableViewVC = TableViewController(style: .plain)
            // tableView顶部留出HeaderView和MenuView的位置
            tableViewVC.tableView.contentInset = UIEdgeInsetsMake(kScrollHorizY, 0, 0, 0)
            tableViewVC.delegate = self
            tableViewVC.view.frame = CGRect(x: floatI * kScreenWidth,y: 0, width: kScreenWidth, height: kScreenHight)
            tableViewVC.sign = menuTitle
            
            // 将tableViewVC添加进数组方便管理
            tableViewArr.append(tableViewVC)
            addChildViewController(tableViewVC)
        }
        // 需要用到的时候再添加到view上,避免一上来就占用太多资源
        backgroundScrollView?.addSubview(tableViewArr[0].view)
        self.view.addSubview(backgroundScrollView!)
    }
    
    /// HeaderView and MenuView
    func layoutHeaderMenuView(){
        headerView = UIView()
        headerView.backgroundColor = UIColor.orange
        headerView.frame = CGRect(x: 0, y: kNavigationHight, width: kScreenWidth, height: kHeaderHight)
        view.addSubview(headerView)
        
        // MenuView
        menuView = XFMenuView(frame:CGRect(x: 0,y: headerView.frame.maxY,width: kScreenWidth,height: kMenuHight))
        menuView.delegate = self
        menuView.setUI(titles)
        view.addSubview(menuView)
    }

    /// 设置 header and menu 的位置
    ///
    /// - Parameter showType: up/bottom
    func headerMenuViewShowType(_ showType: headerMenuShowType){
        switch showType {
        case .up:
            menuView.frame.origin.y = kNavigationHight
            headerView.frame.origin.y = -kHeaderHight+kNavigationHight
            break
        case .bottom:
            headerView.frame.origin.y = kNavigationHight
            menuView.frame.origin.y = headerView.frame.maxY
            break
        }
    }
}

// MARK: - XFMenuViewDelegate
extension CoinPageViewController: XFMenuViewDelegate {
    func menuViewSelectIndex(_ index: Int) {
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            self.backgroundScrollView?.contentOffset = CGPoint(x: kScreenWidth*CGFloat(index),y: -kNavigationHight)
        })
    }
}

// MARK: - TableViewControllerDelegate
extension CoinPageViewController: TableViewControllerDelegate {
    func tableViewDidScrollPassY(_ tableviewScrollY: CGFloat) {
        // 计算每次改变的值
        let seleoffSetY = tableviewScrollY - scrollY
        // 将scrollY的值同步
        scrollY = tableviewScrollY
        
        // 偏移量超出Navigation之上
        if scrollY >= -kMenuHight-kNavigationHight {
            headerMenuViewShowType(.up)
        }else if  scrollY <= -kScrollHorizY {
            // 偏移量超出Navigation之下
            headerMenuViewShowType(.bottom)
        }else{
            // 剩下的只有需要跟随的情况了
            // 将headerView的y值按照偏移量更改
            headerView.frame.origin.y -= seleoffSetY
            menuView.frame.origin.y = headerView.frame.maxY
        }
    }
}

// MARK: - UIScrollViewDelegate
extension CoinPageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 判断是否有X变动,这里只处理横向滑动
        if scrollX == scrollView.contentOffset.x{
            return
        }
        // 当tableview滑动到很靠上的时候,下一个tableview出现时只用在menuView之下
        if scrollY >= -kMenuHight-kNavigationHight {
            scrollY = -kMenuHight-kNavigationHight
        }
        
        for tableViewVC in tableViewArr {
            tableViewVC.tableView.contentOffset = CGPoint(x: 0, y: scrollY)
        }
        
        let rate = (scrollView.contentOffset.x/kScreenWidth)
        self.menuView.scrollToRate(rate)
        
        // 当滑动到30%的时候加载下一个tableView
        backgroundScrollView?.addSubview(tableViewArr[Int(rate+0.7)].view)
        
        // 记录x
        scrollX = scrollView.contentOffset.x
    }
}
