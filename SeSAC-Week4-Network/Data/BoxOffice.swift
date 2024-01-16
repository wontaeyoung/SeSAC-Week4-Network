//
//  BoxOffice.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/16/24.
//

struct Kaz: Codable {
  let boxOfficeResult: SmallKaz
}

struct SmallKaz: Codable {
  let dailyBoxOfficeList: [MovieKaz]
}

struct MovieKaz: Codable {
  let movieNm: String
  let openDt: String
}
