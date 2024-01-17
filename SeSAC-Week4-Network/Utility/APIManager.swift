//
//  APIManager.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/16/24.
//

import Alamofire

enum APIError: Error {
  case requestFailed
}

struct APIManager {
  func callRequest<T: Codable>(
    type: T.Type,
    requestType: RequestURL,
    header: HTTPHeaders,
    parameter: Parameters,
    completionHandler: @escaping (T) -> Void
  ) {
    let url: String = requestType.urlStr
    
    AF
      .request(url, method: .post, parameters: parameter, headers: header)
      .responseDecodable(of: T.self) { response in
        switch response.result {
          case .success(let success):
            completionHandler(success)
            
          case .failure(let failure):
            print(failure.localizedDescription)
        }
      }
  }
}
