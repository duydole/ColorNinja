//
//  UserNameView.swift
//  ColorNinja
//
//  Created by Do Le Duy on 10/26/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class UserNameView: UIView {
  
  private var button: UIButton!
  private var textField: UITextField!
  private var containerView: UIView!
  private var bottomLine: CALayer!
  private var containerViewBottomConstraint: Constraint!

  var buttonTitle: String? {
    didSet {
      if let buttonTitle = buttonTitle {
        let textRange = NSMakeRange(0, buttonTitle.count)
        let attributedText = NSMutableAttributedString(string: buttonTitle)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
        attributedText.addAttribute(.foregroundColor, value: UIColor.white, range: textRange)
        attributedText.addAttribute(.font, value: UIFont(name: Font.squirk, size: 12) ?? UIFont.systemFont(ofSize: 16), range: textRange)
        button.setAttributedTitle(attributedText, for: .normal)
      } else {
        button.setAttributedTitle(nil, for: .normal)
      }
    }
  }
  
  var placeHolderText: String? {
    didSet {
      textField.placeholder = placeHolderText
    }
  }
  
  var text: String? {
    didSet {
      textField.text = text
    }
  }
  
  var onButtonDidPress: ((String?) -> ())?
    
  convenience init(buttonTitle: String? = nil,
                   placeHolderText: String? = nil,
                   text: String? = nil,
                   onButtonDidPress: ((String?) -> ())? = nil) {
    self.init()
    self.buttonTitle = buttonTitle
    self.placeHolderText = placeHolderText
    self.text = text
    self.onButtonDidPress = onButtonDidPress
    self.commonInit()
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:))))
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    bottomLine.frame = CGRect(x: 0, y: bottomLine.superlayer?.bounds.height ?? 0, width: bottomLine.superlayer?.bounds.width ?? 0, height: 0.7)
  }
  
  func commonInit() {
    self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    
    containerView = UIView()
    containerView.backgroundColor = .white
    containerView.clipsToBounds = true
    containerView.layer.cornerRadius = 16
    //containerView.transform = CGAffineTransform(translationX: 0, y: 400)
    addSubview(containerView)
    
    containerView.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(0.8)
      containerViewBottomConstraint = make.bottom.equalToSuperview().constraint
    }
    
    bottomLine = CALayer()
    bottomLine.backgroundColor = UIColor.gray.cgColor
    
    textField = UITextField()
    textField.placeholder = placeHolderText
    textField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    textField.borderStyle = .none
    textField.textAlignment = .center
    textField.returnKeyType = .done
    textField.layer.addSublayer(bottomLine)
    containerView.addSubview(textField)
    textField.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(48)
      make.left.right.equalToSuperview().inset(16)
    }
    
    
    button = UIButton()
    button.titleLabel?.font = UIFont(name: Font.squirk, size: 16)
    button.clipsToBounds = true
    button.layer.cornerRadius = 16
    button.backgroundColor = UIColor.black
    button.setTitle(buttonTitle, for: .normal)
    button.addTarget(self, action: #selector(handlePrimaryButton), for: .touchUpInside)
    containerView.addSubview(button)
    button.snp.makeConstraints { (make) in
      make.top.equalTo(textField.snp.bottom).offset(48)
      make.centerX.equalToSuperview()
      make.width.equalTo(128)
      make.height.equalTo(48)
      make.bottom.equalToSuperview().inset(16)
    }
  }

  func present(from parentView: UIView) {
    self.frame = parentView.bounds
    parentView.addSubview(self)
    layoutIfNeeded()
    textField.becomeFirstResponder()
  }
  
  func dismiss() {
    UIView.animate(withDuration: 0.5, animations: { [weak self] in
      guard let self = self else {return}
      self.containerView.transform = CGAffineTransform(translationX: 0, y: 400)
      self.alpha = 0
    }) {[weak self] (_) in
      self?.removeFromSuperview()
    }
    textField.resignFirstResponder()
  }
  
  // MARK: Handle actions
  
  @objc private func handlePrimaryButton() {
    onButtonDidPress?(textField.text)
  }
  
  @objc private func handleTapOutSide(_ gesture: UITapGestureRecognizer) {
    if !containerView.frame.contains(gesture.location(in: self)) {
      dismiss()
    }
  }
  
  @objc private func keyboardWillShow(_ notification: Notification) {
    guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
      let animationDuration: Double = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
      else { return }
    
    let keyboardRectangle = keyboardFrame.cgRectValue
    let keyboardHeight = keyboardRectangle.height
    
    UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: { [weak self] in
      guard let self = self else {return}
      self.containerViewBottomConstraint.update(inset: keyboardHeight + 16)
      self.layoutIfNeeded()
      }, completion: nil)
  }
}
