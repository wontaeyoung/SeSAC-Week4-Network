//
//  LottoViewController.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/16/24.
//

import UIKit
import Alamofire

final class LottoViewController: UIViewController {
  
  @IBOutlet weak var numberTextField: UITextField!
  @IBOutlet weak var requestButton: UIButton!
  @IBOutlet weak var dateLabel: UILabel!
  
  private let manager = APIManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dateLabel.font = .boldSystemFont(ofSize: 16)
    configureTextField()
    configureButton()
  }
  
  private func configureTextField() {
    numberTextField.placeholder = "회차를 입력해주세요"
    numberTextField.borderStyle = .roundedRect
    numberTextField.autocorrectionType = .no
    numberTextField.autocapitalizationType = .none
    numberTextField.keyboardType = .numberPad
  }
  
  private func configureButton() {
    requestButton.setTitle("요청하기", for: .normal)
    requestButton.addTarget(self, action: #selector(requestButtonTapped), for: .touchUpInside)
  }
  
  @objc private func requestButtonTapped(_ sender: UIButton) {
    let number: Int = Int(numberTextField.text!)!
    
    manager.callRequest(type: Lotto.self, requestType: .lotto(number)) { [weak self] lotto in
      guard let self else { return }
      
      dateLabel.text = lotto.drwNoDate
    }
    
    numberTextField.text = nil
  }
}

