//
//  UserDefaultManager.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/18/24.
//

import Foundation

enum Key: String, CaseIterable {
  case source
  case target
  
  var name: String {
    return self.rawValue
  }
}

@propertyWrapper
struct UserDefault<T> where T: RawRepresentable, T.RawValue: Any {
  private let key: Key
  private var defaultValue: T
  
  init(key: Key, defaultValue: T) {
    self.key = key
    self.defaultValue = defaultValue
  }
  
  var wrappedValue: T {
    get {
      guard
        let rawValue = UserDefaults.standard.object(forKey: key.name) as? T.RawValue,
        let value = T(rawValue: rawValue)
      else {
        return defaultValue
      }
      
      print(#function + "불러오기 \(key.name) : \(rawValue)")
      
      return value
    }
    set {
      UserDefaults.standard.set(newValue.rawValue, forKey: key.name)
      print(#function + "저장하기 \(key.name) : \(newValue.rawValue)")
    }
  }
}
