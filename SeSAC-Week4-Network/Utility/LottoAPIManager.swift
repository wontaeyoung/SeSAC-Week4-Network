//
//  LottoAPIManager.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/16/24.
//

import Alamofire

enum LottoError: Error {
  case requestFailed
}

struct LottoAPIManager {
  func callRequest(number: Int, completionHandler: @escaping (String) -> Void) {
    let url: String = RequestURL.lotto(number).urlStr
    
    AF
      .request(url)
      .responseDecodable(of: Lotto.self) { response in
        switch response.result {
          case .success(let success):
            completionHandler(success.drwNoDate)
            
          case .failure(let failure):
            print(failure.localizedDescription)
        }
      }
  }
}
