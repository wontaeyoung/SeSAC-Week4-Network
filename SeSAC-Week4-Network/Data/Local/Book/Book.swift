//
//  Book.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/17/24.
//

import Foundation

// MARK: -
struct Book {
  let title: String
  let image: String
  
  var url: URL? {
    return URL(string: image)
  }
}

// MARK: - API Model
struct BookRequest: Codable {
  let documents: [Document]
  let meta: Meta
}

struct Document: Codable {
  let authors: [String]
  let contents: String
  let datetime: String
  let isbn: String
  let price: Int
  let salePrice: Int
  let thumbnail: String
  let title: String
  let url: String
  
  enum CodingKeys: String, CodingKey {
    case authors, contents, datetime, isbn, price
    case salePrice = "sale_price"
    case thumbnail, title, url
  }
  
  var asBook: Book {
    return Book(title: title, image: thumbnail)
  }
}

struct Meta: Codable {
  let isEnd: Bool
  let pageableCount, totalCount: Int
  
  enum CodingKeys: String, CodingKey {
    case isEnd = "is_end"
    case pageableCount = "pageable_count"
    case totalCount = "total_count"
  }
}
