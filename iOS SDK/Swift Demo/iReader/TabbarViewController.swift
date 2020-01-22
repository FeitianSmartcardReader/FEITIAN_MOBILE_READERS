//
//  TabbarViewController.swift
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setValue(Tabbar(), forKey: "tabBar")
    }
}

class Tabbar: UITabBar {

    lazy var addBtn: Button = {
        
        let btn = Button(type: .custom)
        btn.setTitle("Reader Command", for: .normal)
        btn.setImage(UIImage(named: "readerCommand"), for: .normal)
        btn.setImage(UIImage(named: "readerCommandHighlight"), for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.addTarget(self, action: #selector(Tabbar.addBtnClick), for: .touchUpInside)
        self.addSubview(btn)
        return btn
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let btnW: Double = Double(self.frame.size.width / 3)
        let btnH: Double = Double(self.frame.size.height)
        let btnY: Double = 0
        var btnX: Double = 0
        var index: Double = 0
        
        for view in self.subviews {
            guard view.isKind(of: NSClassFromString("UITabBarButton")!) else {
                continue
            }
            
            btnX = index * btnW
            
            if index > 0 {
                btnX += btnW
            }
            
            view.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
            index += 1
        }
        
        addBtn.frame = CGRect(x: btnW, y: btnY, width: btnW, height: btnH)
    }
    
    @objc func addBtnClick() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: tabbarMiddleButtonClickNotification), object: nil)
    }
}

class Button: UIButton {
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let btnW:Double = Double(self.frame.size.width)
        
        let imageW = Double(self.imageView!.frame.size.width)
        let imageH = Double(self.imageView!.frame.size.height)
        let imageX = (btnW - imageW) * 0.5;
        let imageY = -6
        self.imageView?.frame = CGRect(x: imageX, y: Double(imageY), width: imageW, height: imageH)
        
        let labelH = 12.0
        let labelW = btnW
        let labelX = 0.0
        let labelY = imageH - 10
        self.titleLabel?.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
    }
}
