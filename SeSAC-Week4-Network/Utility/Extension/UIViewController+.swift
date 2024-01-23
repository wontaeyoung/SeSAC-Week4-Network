//
//  UIViewController+.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/19/24.
//

import UIKit

extension UIViewController {
  static var identifier: String { return String(describing: Self.self) }
  
  func showAlert(
    title: String,
    message: String,
    buttonTitle: String,
    completionHandler: @escaping () -> Void
  ) {
    
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: .alert)
    
    let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
      completionHandler()
    }
    
    let cancel = UIAlertAction(title: "취소", style: .cancel)
    
    alert.addAction(action)
    alert.addAction(cancel)
    
    present(alert, animated: true)
  }
}
