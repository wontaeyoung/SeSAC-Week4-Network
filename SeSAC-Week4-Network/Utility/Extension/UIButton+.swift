//
//  UIButton+.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/23/24.
//

import UIKit

extension UIButton.Configuration {
  
  static func sesacStyle() -> UIButton.Configuration {
    // iOS 15 +
    /// subtitle, multiline, padding(title과 image 사이, title과 subtitle 사이)
    
    var config =  UIButton.Configuration.plain()
    config.title = "여기가 버튼 타이틀이에요"
    config.subtitle = "이곳은 서브타이틀"
    config.titleAlignment = .trailing
    
    config.baseBackgroundColor = .systemGreen
    config.baseForegroundColor = .systemRed
    
    config.image = UIImage(systemName: "star.fill")
    config.imagePlacement = .trailing
    config.imagePadding = 8
    
    config.cornerStyle = .capsule
    config.indicator = .popup
    
    return config
  }
}
