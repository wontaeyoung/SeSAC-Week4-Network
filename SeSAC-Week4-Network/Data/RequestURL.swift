//
//  RequestURL.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/16/24.
//

enum RequestURL {
  case lotto(Int)
  case upbit
  
  var urlStr: String {
    switch self {
      case .lotto(let number):
        return "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(number)"
      
      case .upbit:
        return "https://api.upbit.com/v1/market/all"
    }
  }
}

