//
//  ZPopup.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/10/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit

class ZPopup: NSObject {
    
    private static var popupWindow: UIWindow!
    private var contentView: UIView!
    
    
    class func showPopup() {
        
        ZPopup.popupWindow = UIWindow(frame: UIScreen.main.bounds)
        ZPopup.popupWindow.backgroundColor = .darkGray
        ZPopup.popupWindow.windowLevel = .statusBar
        
        // make popup view
        
        let popUpView = UIView(frame: CGRect(x: 50, y: 50, width: 300, height: 400))
        popUpView.layer.cornerRadius = 9
        popUpView.backgroundColor = .white
        ZPopup.popupWindow.addSubview(popUpView)
//        popUpView.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//            make.width.equalTo(300)
//            make.height.equalTo(400)
//        }
        ZPopup.popupWindow.makeKeyAndVisible()
        print("")
    }

}
