//
//  PapagoLanguage.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/17/24.
//

enum PapagoLanguage: String, CaseIterable {
  case korean = "한국어"
  case english = "영어"
  case japanese = "일본어"
  case chineseSimplified = "중국어 간체"
  case chineseTraditional = "중국어 번체"
  case spanish = "스페인어"
  case french = "프랑스어"
  case german = "독일어"
  case russian = "러시아어"
  case portuguese = "포르투갈어"
  case italian = "이탈리아어"
  case vietnamese = "베트남어"
  case thai = "태국어"
  case indonesian = "인도네시아어"
  case hindi = "힌디어"
  
  var displayName: String {
    return self.rawValue
  }
  
  var displayNameList: [String] {
    return Self.allCases.map { $0.displayName }
  }
  
  var languageCode: String {
    return Self.papagoLanguages[self.displayName]!
  }
}

extension PapagoLanguage {
  static let papagoLanguages: [String: String] = [
    "한국어": "ko",
    "영어": "en",
    "일본어": "ja",
    "중국어 간체": "zh-CN",
    "중국어 번체": "zh-TW",
    "스페인어": "es",
    "프랑스어": "fr",
    "독일어": "de",
    "러시아어": "ru",
    "포르투갈어": "pt",
    "이탈리아어": "it",
    "베트남어": "vi",
    "태국어": "th",
    "인도네시아어": "id",
    "힌디어": "hi"
  ]
}
