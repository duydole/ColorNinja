//
//  PopupViewController.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/10/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
    
    var contentView : UIView!
    
    private var darkLayer: UIControl!
    
    // MARK: Life cycle
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillAppear(animated)
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 0.0
        }
    }
    
    // MARK: Setup views
    
    private func setupView() {
        self.addDarkLayer()
        self.addContentView()
    }
    
    private func addContentView() {
        contentView = UIView()
        self.view.addSubview(contentView)
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = .white
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(400)
        }
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
        self.dismiss(animated: true, completion: nil)
    }
}
