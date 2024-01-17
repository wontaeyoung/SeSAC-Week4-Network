//
//  PapagoViewController.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/17/24.
//

/*
 네트워크 에러 핸들링 케이스
 1. 네트워크 통신 상태가 안좋을 때 (와이파이)
 2. API 요청 횟수를 소진했을 때
 3. 요청 버튼을 사용자가 짧은 시간에 연속으로 누를 때
 - 버튼 탭 쿨타임을 만든다
 - 직전 번역 요청 텍스트와 동일하다면 응답받은 척 하고 그대로 둔다
 */

import UIKit
import Alamofire

final class PapagoViewController: UIViewController {
  
  @IBOutlet weak var sourceLangButton: UIButton!
  @IBOutlet weak var swapLangButton: UIButton!
  @IBOutlet weak var targetLangButton: UIButton!
  
  @IBOutlet weak var sourceTextView: UITextView!
  @IBOutlet weak var translateButton: UIButton!
  @IBOutlet weak var targetLabel: UILabel!
  
  private var sourceLang: PapagoLanguage = .korean {
    didSet {
      sourceLangButton.setTitle(sourceLang.displayName, for: .normal)
    }
  }
  private var targetLang: PapagoLanguage = .english {
    didSet {
      targetLangButton.setTitle(targetLang.displayName, for: .normal)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    translateButton.addTarget(self, action: #selector(translateButtonTapped), for: .touchUpInside)
    swapLangButton.addTarget(self, action: #selector(swapLanguage), for: .touchUpInside)
  }
  
  @objc private func translateButtonTapped(_ sender: UIButton) {
    callRequest()
  }
}

// MARK: - Action
extension PapagoViewController {
  @objc private func swapLanguage() {
    let temp: PapagoLanguage = sourceLang
    sourceLang = targetLang
    targetLang = temp
  }
  
  private func callRequest() {
    let url: String = RequestURL.papago.urlStr
    
    let parameters: Parameters = [
      "text": sourceTextView.text!,
      "source": sourceLang.languageCode,
      "target": targetLang.languageCode
    ]
    
    let headers: HTTPHeaders = [
      "X-Naver-Client-Id": APIKey.Naver.clientID,
      "X-Naver-Client-Secret": APIKey.Naver.cliendSecret
    ]
    
    AF
      .request(url, method: .post, parameters: parameters, headers: headers)
      .responseDecodable(of: Papago.self) { [weak self] response in
        guard let self else { return }
        
        switch response.result {
          case .success(let data):
            targetLabel.text = data.message.result.translatedText
            dump(data)
            
          case .failure(let failure):
            print(failure.localizedDescription)
        }
      }
  }
}

// MARK: - Configure
extension PapagoViewController {
  private func configureUI() {
    configureButton()
  }
  
  private func configureButton() {
    sourceLangButton.setTitle(sourceLang.displayName, for: .normal)
    targetLangButton.setTitle(targetLang.displayName, for: .normal)
  }
}
