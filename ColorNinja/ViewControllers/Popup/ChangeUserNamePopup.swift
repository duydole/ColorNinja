//
//  ChangeUserNamePopup.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/30/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

protocol ChangeUserNamePopupDelegate {
    func didDismissPopupWithNewUserName(newUserName: String) -> Void
}

class ChangeUserNamePopup: PopupViewController {
    
    private var changeButton: UIButton!
    private var textField: UITextField!
    var delegate: ChangeUserNamePopupDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        tapDarkLayerToDismiss = true
    }
    
    override var contentSize: CGSize {
        return CGSize(width: scaledValue(200), height: scaledValue(200))
    }
    
    override var cornerRadius: CGFloat {
        return 20
    }
    
    private func setupViews() {
        
        // TextField
        textField = UITextField()
        textField.delegate = self
        textField.borderStyle = .roundedRect;
        textField.placeholder = getRealNameWithoutPlus(name: OwnerInfo.shared.userName)
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        textField.textAlignment = .center
        contentView.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.top.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(60)
        }
        
        // GoButton
        changeButton = UIButton()
        changeButton.setTitle("Update", for: .normal)
        changeButton.backgroundColor = .black
        changeButton.titleLabel!.font = UIFont(name: Font.squirk, size: 30)
        changeButton.layer.cornerRadius = 13
        changeButton.makeShadow()
        contentView.addSubview(changeButton)
        changeButton.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.width.height.centerX.equalTo(textField)
        }
        changeButton.addTarget(self, action: #selector(didTapChangeButton), for: .touchUpInside)

    }
    
    @objc private func didTapChangeButton() {
        
        guard let username = textField.text else {
            return
        }
        
        if username.isEmpty {
            showAlertWithMessage(message: "Please input your new username. Thanks.")
            return
        }
        
        if !isValidUsername(userName: username) {
            showAlertWithMessage(message: "Please input valid username. Thanks.")
            return
        }
        
        /* Send RoomID to Delegate */
        dismissPopUp()
        didDismissPopUp = {
            self.delegate?.didDismissPopupWithNewUserName(newUserName: username)
        }
    }
            
    func showAlertWithMessage(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    private func isValidUsername(userName: String) -> Bool {
        return true
    }
}

extension ChangeUserNamePopup: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return false
        }
        
        let oldLength = text.count
        let replacementLength = string.count
        let rangeLength = range.length;
        let newLength = oldLength - rangeLength + replacementLength
        let returnkey = string.range(of: "\n")?.lowerBound != nil
        
        return newLength <= MAX_USERNAME_LENGTH || returnkey;
    }
}
