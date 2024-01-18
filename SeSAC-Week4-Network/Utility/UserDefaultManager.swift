//
//  UserDefaultManager.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/18/24.
//

import Foundation

final class UserDefaultManager {
  static let shared = UserDefaultManager()
  
  enum UDKey: String {
    case source
    case target
    
    var defaultValue: String {
      switch self {
        case .source:
          return PapagoLanguage.korean.displayName
          
        case .target:
          return PapagoLanguage.english.displayName
      }
    }
  }
  
  private let ud = UserDefaults.standard
  
  var source: String {
    get {
      let key: UDKey = .source
      return ud.string(forKey: key.rawValue) ?? key.defaultValue
    }
    set {
      ud.setValue(newValue, forKey: UDKey.source.rawValue)
    }
  }
  
  var target: String {
    get {
      let key: UDKey = .target
      return ud.string(forKey: key.rawValue) ?? key.defaultValue
    }
    set {
      ud.setValue(newValue, forKey: UDKey.target.rawValue)
    }
  }
}

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
      
      return value
    }
    set {
      UserDefaults.standard.set(newValue.rawValue, forKey: key.name)
    }
  }
}
