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
import GoogleSignIn

let kDownloadAvatarSuccessNotificationName: String = "com.user.donwload.avatar.success"

class BaseHomeViewController: UIViewController {
    
    // NavigationBar
    var fakeNavigationbar: UIView!
    var avatarView: UIImageView!
    var usernamelabel: UILabel!
    var signOutButton: UIImageView!
    
    // TopContainer
    var topContainer: UIView!
    var iconImageView: UIImageView!
    var appNameLabel: UILabel!
    
    // MidContainer
    var midContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.HomeScreen.backgroundColor
        setupViews()
        setupNotifications()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didDownloadSuccessAvatar),
                                               name: NSNotification.Name(kDownloadAvatarSuccessNotificationName),
                                               object: nil)
    }
    
    @objc private func didDownloadSuccessAvatar() {
        updateAvatarView()
    }
    
    private func updateAvatarView() {
        self.avatarView.image = UIImage(named: "defaultAvatar")
        SessionManager.shared.getCurrentUserAvatar { image in
            DispatchQueue.main.async {
                guard image != nil else {
                    return
                }
                self.avatarView.image = image
            }
        }
    }
    
    // MARK: Setup and Layout
    
    func setupViews() {
        addFakeNavigationBar()
        addTopContainer()
        addMidContainer()
    }
        
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
        
        let avtWidth: CGFloat = scaledValue(45)
        avatarView = UIImageView()
        avatarView.layer.cornerRadius = avtWidth/2
        avatarView.clipsToBounds = true
        avatarView.layer.borderWidth = 1.0
        avatarView.layer.borderColor = UIColor.white.cgColor
        avatarView.contentMode = .scaleAspectFit
        updateAvatarView()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapAvatarViewOrUserNameLabel))
        avatarView.isUserInteractionEnabled = true
        avatarView.addGestureRecognizer(tapGestureRecognizer)
        
        fakeNavigationbar.addSubview(avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.width.equalTo(avtWidth)
            make.height.equalTo(avtWidth)
            make.leading.equalTo(scaledValue(20))
            make.centerY.equalToSuperview()
        }
        
        // UserName
        usernamelabel = UILabel()
        usernamelabel.text = getRealNameWithoutPlus(name: OwnerInfo.shared.userName)
        usernamelabel.textColor = .white
        let tapUserName = UITapGestureRecognizer(target: self, action: #selector(didTapAvatarViewOrUserNameLabel))
        usernamelabel.isUserInteractionEnabled = true
        usernamelabel.addGestureRecognizer(tapUserName)
        
        fakeNavigationbar.addSubview(usernamelabel)
        usernamelabel.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
    }
    
    private func addTopContainer() {
        topContainer = UIView()
        view.addSubview(topContainer)
        topContainer.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalTo(fakeNavigationbar.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.25)
            make.centerX.equalToSuperview()
        }
        
        // Add subviews of TopContainer
        addUserNameButton()
        addAppNameLabel()
        addAppIconView()
        addSignoutImageView()
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
        iconImageView.image = UIImage(named: "appiconhome")
        topContainer.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(appNameLabel.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalTo(iconImageView.snp.height)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    private func addSignoutImageView() {
        
        let signoutWidth = scaledValue(32)
        let paddingRight = scaledValue(20)
        
        signOutButton = UIImageView()
        signOutButton.image = UIImage(named: "logouticon")?.withRenderingMode(.alwaysTemplate)
        signOutButton.tintColor = .white
        fakeNavigationbar.addSubview(signOutButton)
        signOutButton.snp.makeConstraints { (make) in
            make.right.equalTo(-paddingRight)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(signoutWidth)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapLogoutButton))
        signOutButton.isUserInteractionEnabled = true
        signOutButton.addGestureRecognizer(tap)
    }
    
    private func addMidContainer() {
        midContainer = UIView()
        view.addSubview(midContainer)
        midContainer.snp.makeConstraints { (make) in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(topContainer.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.35)
        }
    }
    
    // MARK: Event
    
    @objc func didTapAvatarViewOrUserNameLabel() {
        let popup = ChangeUserNamePopup()
        popup.modalPresentationStyle = .overCurrentContext
        popup.delegate = self
        
        present(popup, animated: false, completion: nil)
    }
    
    @objc func didTapLogoutButton() {
        let alert = UIAlertController(title: "Log out", message: "Do you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Log out", style: .default, handler: { _ in
            self.proccessLogout()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func proccessLogout() {
        
        /// Logout Facebook
        FBSDKLoginKit.LoginManager().logOut()
        
        /// Logout Google
        GIDSignIn.sharedInstance.signOut()
        
        /// Clear localData
        SessionManager.shared.clearInfoOffCurrentUser()
        
        /// Logout Auth
        AuthManager.shared.logOutUser { success in
            DispatchQueue.main.async {
                if success == false {
                    fatalError("Could not log out")
                }
                
                guard let window = UIApplication.shared.windows.first else {
                    return
                }
                let loginVC = LoginViewController()
                window.rootViewController = loginVC
                loginVC.view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                UIView.transition(with: window,
                                  duration: 0.4,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    loginVC.view.transform = .identity
                                  },
                                  completion: nil)
                
            }
        }
    }
}

// MARK: ChangeUserNamePopupDelegate

extension BaseHomeViewController: ChangeUserNamePopupDelegate {
    
    func didDismissPopupWithNewUserName(newUserName: String) {
        if newUserName != OwnerInfo.shared.userName {
            OwnerInfo.shared.updateUserName(newusername: newUserName)
            usernamelabel.text = getRealNameWithoutPlus(name: newUserName)
        }
    }
}
