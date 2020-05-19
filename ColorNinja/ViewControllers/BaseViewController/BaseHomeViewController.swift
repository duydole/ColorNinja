//
//  BaseHomeViewController.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/18/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class BaseHomeViewController: UIViewController {
    
    var iconImageView: UIImageView!
    var appNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.HomeScreen.backgroundColor
        self.setupViews()
    }
    
    func setupViews() {
        self.addAppNameLabel()
        self.addAppIconView()
    }
    
    private func addAppNameLabel() {
        appNameLabel = UILabel()
        appNameLabel.text = Constants.HomeScreen.appName
        appNameLabel.textAlignment = NSTextAlignment.center
        appNameLabel.font = UIFont(name: Font.squirk, size: 60)
        appNameLabel.textColor = Constants.HomeScreen.appNameColor
        appNameLabel.makeShadow()
        self.view.addSubview(appNameLabel)
        appNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(150)
        }
    }
    
    private func addAppIconView() {
        iconImageView = UIImageView()
        iconImageView.image = UIImage(named: Constants.HomeScreen.ninjaImageName)
        self.view.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(appNameLabel.snp.bottom).offset(20)
            make.width.height.equalTo(Constants.HomeScreen.iconWidth)
            make.centerX.equalTo(self.view)
        }
    }
}
