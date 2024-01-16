//
//  MarketViewController.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/16/24.
//

import UIKit
import Alamofire

final class MarketViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    callRequest()
  }
  
  private func callRequest() {
    let url: String = RequestURL.upbit.urlStr
    
    AF
      .request(url)
      .responseDecodable(of: [Market].self) { response in
        
        switch response.result {
          case .success(let success):
            success[...9].forEach {
              print($0.korean_name + "|" + $0.english_name)
            }
            
          case .failure(let failure):
            print(#function, failure.errorDescription ?? "에러 발생")
        }
      }
  }
}
