//
//  BaseViewController.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/16/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController : UIViewController {
    
    var exitButton : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.GameScreen.backgroundColor
    }
    
    override func loadView() {
        super.loadView()
        self.setupExitButton()
    }
    
    private func setupExitButton() {
        exitButton = UIButton()
        self.view.addSubview(exitButton)
        exitButton.setImage(UIImage(named: Constants.GameScreen.exitImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        exitButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        exitButton.imageView?.tintColor = Constants.GameScreen.buttonTintColor
        exitButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(Constants.GameScreen.exitButtonWidth)
            make.top.equalTo(Constants.GameScreen.topInset)
            make.trailing.equalTo(-Constants.GameScreen.rightInset)
        }
    }
    
    @objc private func didTapExitButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
