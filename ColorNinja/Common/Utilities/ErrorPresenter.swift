//
//  ErrorPresenter.swift
//  ZDZalo
//
//  Created by Duy Đỗ on 08/08/2021.
//

import Foundation
import UIKit

class ErrorPresenter {
    public static let shared = ErrorPresenter()
    
    // MARK: Public methods
    
    public func showError(on viewController: UIViewController?, title: String = "Error", message: String = "Something Wrong") {
        guard let viewController = viewController else {
            return
        }
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        viewController.present(alertVC, animated: true, completion: nil)
    }
}
