//
//  JoinRoomPopup.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/21/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

protocol JoinRoomPopupDelegate {
  func didDismissWithRoomId(roomId: Int) -> Void
}

class JoinRoomPopup: PopupViewController {
  
  private var goButton: UIButton!
  private var textField: UITextField!
  var delegate: JoinRoomPopupDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    
    showDarkDuration = 0.0
    showContentViewDuration = 0.3
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    /// Open keyboard
    UIView.animate(withDuration: showContentViewDuration) {
      self.textField.becomeFirstResponder()
    }
  }
  
  override func dismissPopUp() {
    UIView.animate(withDuration: 0.3, animations: {
      self.textField.resignFirstResponder()
    }) { (success) in
      super.dismissPopUp()
    }
  }
  
  override var contentSize: CGSize {
    return CGSize(width: scaledValue(220), height: scaledValue(180))
  }
  
  override var cornerRadius: CGFloat {
    return scaledValue(20)
  }
  
  private func setupViews() {
    
    // TextField
    textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.placeholder = "Enter RoomId"
    textField.font = UIFont.systemFont(ofSize: scaledValue(20))
    textField.autocorrectionType = .no
    textField.keyboardType = .decimalPad
    textField.returnKeyType = .done
    textField.clearButtonMode = .whileEditing
    textField.contentVerticalAlignment = .center
    textField.textAlignment = .center
    contentView.addSubview(textField)
    textField.snp.makeConstraints { (make) in
      make.top.leading.equalTo(scaledValue(20))
      make.trailing.equalTo(scaledValue(-20))
      make.height.equalTo(scaledValue(60))
    }
    
    // GoButton
    goButton = UIButton()
    goButton.setTitle("GO", for: .normal)
    goButton.backgroundColor = .black
    goButton.titleLabel!.font = UIFont(name: Font.squirk, size: scaledValue(30))
    goButton.layer.cornerRadius = scaledValue(13)
    goButton.makeShadow()
    contentView.addSubview(goButton)
    goButton.snp.makeConstraints { (make) in
      make.width.height.centerX.equalTo(textField)
      make.bottom.equalToSuperview().offset(scaledValue(-20))
    }
    goButton.addTarget(self, action: #selector(didTapGoButton), for: .touchUpInside)
    
  }
  
  @objc private func didTapGoButton() {
    
    // Validate TextField
    guard let roomIdString = textField.text else {
      return
    }
    
    if roomIdString.isEmpty {
      showAlertWithMessage(message: "Please input your RoomId. Thanks.")
      return
    }
    
    if !isValidRoomId(roomIdString: roomIdString) {
      showAlertWithMessage(message: "Please input valid RoomId. Thanks.")
      return
    }
    
    if roomIdString.toInt() > 999 {
      showAlertWithMessage(message: "Please input RoomId less than 999. Thanks.")
      return
    }
    
    /* Send RoomID to Delegate */
    dismissPopUp()
    didDismissPopUp = {
      self.delegate?.didDismissWithRoomId(roomId: roomIdString.toInt())
    }
  }
  
  func isValidRoomId(roomIdString: String) -> Bool {
    if roomIdString == "0" {
      return true
    }
    
    if roomIdString.toInt() == 0 {
      return false
    }
    
    return true
  }
  
}
