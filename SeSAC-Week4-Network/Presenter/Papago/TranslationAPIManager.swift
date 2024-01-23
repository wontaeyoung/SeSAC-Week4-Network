//
//  TranslationAPIManager.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/23/24.
//

import Alamofire

final class TranslationAPIManager {
  
  static let shared = TranslationAPIManager()
  
  private init() { }
  
  let baseURL = "https://openapi.naver.com/v1/papago"
  
  /// Naver의 다른 API들도 사용해서 동일한 header를 사용한다면 함수 외부로 분리해서 재사용하도록 설정
  let headers: HTTPHeaders = [
    "X-Naver-Client-Id": APIKey.Naver.clientID,
    "X-Naver-Client-Secret": APIKey.Naver.cliendSecret
  ]
  
  func callRequest(text: String, completionHandler: @escaping (String) -> Void) {
    
    let url = baseURL + "/n2mt"
    
    let parameters: Parameters = [
      "text": text,
      "source": PapagoLanguage.korean.languageCode,
      "target": PapagoLanguage.english.languageCode
    ]
    
    AF
      .request(url, method: .post, parameters: parameters, headers: headers)
      .responseDecodable(of: Papago.self) { response in
        
        switch response.result {
          case .success(let success):
            
            let text = success.message.result.translatedText
            completionHandler(text)
            
          case .failure(let failure):
            print(failure.localizedDescription)
        }
      }
  }
}
