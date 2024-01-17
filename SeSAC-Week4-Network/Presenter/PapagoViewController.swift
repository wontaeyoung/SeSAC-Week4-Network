//
//  PapagoViewController.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/17/24.
//

import UIKit
import Alamofire

final class PapagoViewController: UIViewController {
  
  @IBOutlet weak var sourceTextView: UITextView!
  @IBOutlet weak var translateButton: UIButton!
  @IBOutlet weak var targetLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    translateButton.addTarget(self, action: #selector(translateButtonTapped), for: .touchUpInside)
  }
  
  @objc private func translateButtonTapped(_ sender: UIButton) {
    let url = "https://openapi.naver.com/v1/papago/n2mt"
    
    let parameters: Parameters = [
      "text": sourceTextView.text!,
      "source": "ko",
      "target": "en"
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
