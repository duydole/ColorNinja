//
//  PopupViewController.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/10/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
    
    // MARK: - Public Property
    
    var contentView: UIView!
    
    var contentSize: CGSize {
        return CGSize(width: 3*Constants.Screen.width/4, height: Constants.Screen.height/2)
    }
    
    var cornerRadius: CGFloat {
        return Constants.PopupViewController.defaultCornerRadius
    }
    
    var didDismissPopUp: (() -> Void)?
    
    func dismissPopUp() {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { (success) in
            self.darkLayer.backgroundColor = .clear
            self.dismiss(animated: false) {
                if let didDismissPopUp = self.didDismissPopUp {
                    didDismissPopUp()
                }
            }
        }
    }

    // MARK: - Private Property
    
    private var darkLayer: UIControl!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.view.alpha = 0.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1.0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.contentView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillAppear(animated)
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 0.0
        }
    }
    
    // MARK: - Setup views
    
    private func setupView() {
        self.addDarkLayer()
        self.addContentView()
    }
    
    private func addContentView() {
        contentView = UIView()
        self.view.addSubview(contentView)
        contentView.layer.cornerRadius = cornerRadius
        contentView.backgroundColor = .white
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(contentSize.width)
            make.height.equalTo(contentSize.height)
        }
        contentView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    }
    
    private func addDarkLayer() {
        self.darkLayer = UIControl(frame: UIScreen.main.bounds)
        self.darkLayer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.view.addSubview(darkLayer)
        self.darkLayer.addTarget(self, action: #selector(didTapDarkLayer), for: .touchUpInside)
    }
    
    @objc private func showDarkLayer() {
        self.darkLayer.isHidden = false
    }
    
    @objc private func hiddenDarkLayer() {
        self.darkLayer.isHidden = true
    }
    
    @objc private func didTapDarkLayer() {
        self.dismissPopUp()
    }
}
