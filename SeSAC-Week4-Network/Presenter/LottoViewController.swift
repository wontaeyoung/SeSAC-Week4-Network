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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dateLabel.font = .boldSystemFont(ofSize: 16)
    configureTextField()
    configureButton()
  }
  
  private func callRequest(number: Int) {
    let url: String = RequestURL.lotto(number).urlStr
    
    AF
      .request(url)
      .responseDecodable(of: Lotto.self) { [weak self] response in
        guard let self else { return }
        
        switch response.result {
          case .success(let success):
            dateLabel.text = success.drwNoDate
            
            print(success)
            print(success.drwNo, "회차")
            print("날짜:", success.drwNoDate)
            
          case .failure(let failure):
            dateLabel.text = failure.errorDescription
            
            print(#function, failure.errorDescription ?? "에러 발생")
        }
      }
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
    callRequest(number: number)
    numberTextField.text = nil
  }
}

