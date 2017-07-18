//
//  XFMenuView.swift
//  test
//
//  Created by XingfuQiu on 2017/7/18.
//  Copyright © 2017年 XingfuQiu. All rights reserved.
//

import UIKit

let kButtonWidth: CGFloat = 75
/** button两种状态的颜色 可以无视 */
let COLOR_BUTTON_DEFAULT = UIColor(red: 124/255.0, green: 129/255.0, blue: 138/255.0, alpha: 1)
let COLOR_BUTTON_SELECT = UIColor(red: 0/255.0, green: 127/255.0, blue: 255/255.0, alpha: 1)

protocol XFMenuViewDelegate {
    func menuViewSelectIndex(_ index: Int)
}

class XFMenuView: UIView {
    /// 选中下划线
    var lineView: UIView?
    /// 标题数组
    var titleArr: [String] = [String]()
    /// 按钮数组
    var buttonArr: [UIButton] = [UIButton]()
    /// margin
    var margin: CGFloat!
    /// delegate
    var delegate: XFMenuViewDelegate?
    
    func setUI(_ titleArr: Array<String>){
        self.backgroundColor = UIColor.init(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1)
        self.titleArr = titleArr
        margin = (kScreenWidth - (CGFloat(titleArr.count) * kButtonWidth)) / CGFloat(titleArr.count+1)
        for i in 0 ..< titleArr.count  {
            let floatI = CGFloat(i)
            
            let button = UIButton(type: UIButtonType.custom)
            let buttonX = margin*(floatI+1)+floatI*kButtonWidth
            
            button.frame = CGRect(x: buttonX, y: 0, width: kButtonWidth,height: kMenuHight)
            
            let title = titleArr[i]
            button.setTitle(title, for: UIControlState())
            button.setTitleColor(COLOR_BUTTON_DEFAULT, for: UIControlState())
            
            button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
            buttonArr.append(button)
            self.addSubview(button)
        }
        buttonSelectIndex(0)
        
        // 分割线
        let line = UIView(frame: CGRect(x: 0,y: self.frame.height-1,width: kScreenWidth,height: 1))
        line.backgroundColor = UIColor.groupTableViewBackground
        self.addSubview(line)
        
        // 下划线
        lineView = UIView(frame: CGRect(x: margin,y: self.frame.size.height-2,width: kButtonWidth,height: 2))
        lineView?.backgroundColor = COLOR_BUTTON_SELECT
        self.addSubview(lineView!)

    }
    
    func buttonClick(_ sender: UIButton){
        let index = buttonArr.index(of: sender)
        buttonSelectIndex(index!)
        delegate?.menuViewSelectIndex(index!)
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollToRate(CGFloat(index!))
        })
    }
    
    func scrollToRate(_ rate: CGFloat){
        if Int(rate) >= titleArr.count {
            return
        }
        let index = Int(rate)
        let pageRate = rate - CGFloat(index)
        let button = self.buttonArr[index]
        self.lineView?.frame.origin.x = button.frame.origin.x + ( button.frame.width+margin )*pageRate
        buttonSelectIndex(Int(rate + 0.5))
    }
    
    func buttonSelectIndex(_ index: Int){
        for button in buttonArr {
            button.setTitleColor(COLOR_BUTTON_DEFAULT, for: UIControlState())
        }
        let button = buttonArr[index]
        button.setTitleColor(COLOR_BUTTON_SELECT, for: UIControlState())
    }
}

