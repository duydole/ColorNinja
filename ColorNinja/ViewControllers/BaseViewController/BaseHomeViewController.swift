//
//  BaseHomeViewController.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/18/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

class BaseHomeViewController: UIViewController {
    
    // NavigationBar
    var fakeNavigationbar: UIView!
    var avatarView: UIImageView!
    var usernamelabel: UILabel!

    // TopContainer
    var topContainer: UIView!
    var iconImageView: UIImageView!
    var appNameLabel: UILabel!
    
    // MidContainer
    var midContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.HomeScreen.backgroundColor
        self.setupViews()
    }
    
    func setupViews() {
        addFakeNavigationBar()
        addTopContainer()
        addUserNameButton()
        addAppNameLabel()
        addAppIconView()
        
        addMidContainer()
    }
    
    // MARK: Fake NavigationBar
    
    private func addFakeNavigationBar() {
        fakeNavigationbar = UIView()
        view.addSubview(fakeNavigationbar)
        fakeNavigationbar.snp.makeConstraints { (make) in
            make.top.equalTo(Size.statusBarHeight)
            make.width.equalToSuperview()
            make.height.equalTo(scaledValue(50))
            make.centerX.equalToSuperview()
        }
    }
    
    private func addUserNameButton() {
        
        let avtWidth: CGFloat = 45
        avatarView = UIImageView()
        avatarView.layer.cornerRadius = avtWidth/2
        avatarView.clipsToBounds = true
        switch OwnerInfo.shared.loginType {
        case .Facebook:
            avatarView.image = UIImage(named: "usericon")
            avatarView.downloaded(from: OwnerInfo.shared.avatarUrl)
        default:
            avatarView.image = UIImage(named: "usericon")
        }
        
        fakeNavigationbar.addSubview(avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.width.equalTo(scaledValue(avtWidth))
            make.height.equalTo(scaledValue(avtWidth))
            make.leading.equalTo(scaledValue(20))
            make.centerY.equalToSuperview()
        }
        
        
        // UserName
        usernamelabel = UILabel()
        usernamelabel.text = OwnerInfo.shared.userName
        usernamelabel.textColor = .white
        fakeNavigationbar.addSubview(usernamelabel)
        usernamelabel.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
    }

    // MARK: Top Container
    
    private func addTopContainer() {
        topContainer = UIView()
        view.addSubview(topContainer)
        topContainer.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalTo(fakeNavigationbar.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalToSuperview()
        }
    }
            
    private func addAppNameLabel() {
        appNameLabel = UILabel()
        appNameLabel.text = "COLOR NINJA"
        appNameLabel.textAlignment = NSTextAlignment.center
        appNameLabel.font = UIFont(name: Font.squirk, size: scaledValue(60))
        appNameLabel.adjustsFontSizeToFitWidth = true
        appNameLabel.textColor = Constants.HomeScreen.appNameColor
        appNameLabel.makeShadow()
        topContainer.addSubview(appNameLabel)
        appNameLabel.snp.makeConstraints { (make) in
            make.width.centerX.equalToSuperview().multipliedBy(0.75)
            make.top.equalTo(fakeNavigationbar.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.centerX.equalToSuperview()
        }
    }
    
    private func addAppIconView() {
        iconImageView = UIImageView()
        iconImageView.image = UIImage(named: Constants.HomeScreen.ninjaImageName)
        topContainer.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(appNameLabel.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalTo(iconImageView.snp.height)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    // MARK: Mid container
    
    private func addMidContainer() {
        midContainer = UIView()
        view.addSubview(midContainer)
        midContainer.snp.makeConstraints { (make) in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(topContainer.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
    }
}
