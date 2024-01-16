//
//  LottoViewController.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/16/24.
//

import UIKit
import Alamofire

struct Lotto: Codable {
  let drwNo: Int          // 회차
  let drwNoDate: String   // 날짜
  
  let drwtNo1: Int
  let drwtNo2: Int
  let drwtNo3: Int
  let drwtNo4: Int
  let drwtNo5: Int
  let drwtNo6: Int
  let bnusNo: Int
}

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
    let url: String = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(number)"
    
    AF
      .request(url, method: .)
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

