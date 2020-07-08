//
//  PopupViewController.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/10/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

  // Public
  public var activityIndicator = UIActivityIndicatorView()
  public var allowTapDarkLayerToDismiss: Bool = false
  public var contentView: UIView!
  public var contentSize: CGSize {
    return CGSize(width: 3*Constants.Screen.width/4, height: Constants.Screen.height/2)
  }
  public var cornerRadius: CGFloat {
    return Constants.PopupViewController.defaultCornerRadius
  }
  public var showDarkDuration: TimeInterval = 0.2
  public var showContentViewDuration: TimeInterval = 0.3
  
  public var didDismissPopUp: (() -> Void)?
  public var dismissInterval: TimeInterval = 0.3
  public func dismissPopUp() {
    UIView.animate(withDuration: dismissInterval, animations: {
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
  
  // Public API
  
  func showAlertWithMessage(message: String) {
    let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }

  // Private
  private var darkLayer: UIControl!
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupView()
    self.view.alpha = 0.0
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super .viewWillAppear(animated)
    
    UIView.animate(withDuration: showDarkDuration) {
      self.view.alpha = 1.0
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    UIView.animate(withDuration: showContentViewDuration) {
      self.contentView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
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
    addDarkLayer()
    addContentView()
    setupIndicator()
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
  
  private func setupIndicator() {
    contentView.addSubview(activityIndicator)
    activityIndicator.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
  }
  
  @objc private func showDarkLayer() {
    self.darkLayer.isHidden = false
  }
  
  @objc private func hiddenDarkLayer() {
    self.darkLayer.isHidden = true
  }
  
  @objc private func didTapDarkLayer() {
    if allowTapDarkLayerToDismiss {
      dismissPopUp()
    }
  }
}
