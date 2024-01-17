//
//  Papago.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/17/24.
//

// MARK: - Papago
struct Papago: Codable {
  let message: Message
}

// MARK: - Message
struct Message: Codable {
  let result: Result
}

// MARK: - Result
struct Result: Codable {
  let translatedText: String
}
