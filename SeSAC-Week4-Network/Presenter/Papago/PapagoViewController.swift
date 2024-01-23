//
//  PapagoViewController.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/17/24.
//

/*
 네트워크 에러 핸들링 케이스
 1. 네트워크 통신 상태가 안좋을 때 (와이파이)
 2. API 요청 횟수를 소진했을 때
 3. 요청 버튼을 사용자가 짧은 시간에 연속으로 누를 때
 - 버튼 탭 쿨타임을 만든다
 - 직전 번역 요청 텍스트와 동일하다면 응답받은 척 하고 그대로 둔다
 */

import UIKit
import Alamofire

final class PapagoViewController: UIViewController {
  
  @IBOutlet weak var sourceLangButton: UIButton!
  @IBOutlet weak var swapLangButton: UIButton!
  @IBOutlet weak var targetLangButton: UIButton!
  
  @IBOutlet weak var sourceTextView: UITextView!
  @IBOutlet weak var translateButton: UIButton!
  @IBOutlet weak var targetLabel: UILabel!
  
  private let manager = APIManager()
  private var isSameLanguage: Bool {
    return sourceLang == targetLang
  }
  
  @UserDefault(key: .source, defaultValue: PapagoLanguage.korean)
  private var sourceLang: PapagoLanguage {
    didSet {
      if isSameLanguage { targetLang = oldValue }
    }
  }
  
  @UserDefault(key: .target, defaultValue: PapagoLanguage.english)
  private var targetLang: PapagoLanguage {
    didSet {
      if isSameLanguage { sourceLang = oldValue }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    addTargets()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    sourceLangButton.setTitle(sourceLang.displayName, for: .normal)
    targetLangButton.setTitle(targetLang.displayName, for: .normal)
  }
  
  @objc private func translateButtonTapped(_ sender: UIButton) {
    
    TranslationAPIManager.shared.callRequest(text: sourceTextView.text) { result in
      
      self.targetLabel.text = result
    }
  }
  
  private func addTargets() {
    translateButton.addTarget(self, action: #selector(translateButtonTapped), for: .touchUpInside)
    swapLangButton.addTarget(self, action: #selector(swapLanguage), for: .touchUpInside)
    sourceLangButton.addTarget(self, action: #selector(sourceLangButtonTapped), for: .touchUpInside)
    targetLangButton.addTarget(self, action: #selector(targetLangButtonTapped), for: .touchUpInside)
  }
  
  private func isSource(_ lang: PapagoLanguage) -> Bool {
    return lang == sourceLang
  }
}

// MARK: - Navigation
extension PapagoViewController {
  @objc private func sourceLangButtonTapped() {
    push(currentLanguage: sourceLang) { language in
      self.sourceLang = language
    }
  }
  
  @objc private func targetLangButtonTapped() {
    push(currentLanguage: targetLang) { language in
      self.targetLang = language
    }
  }
  
  private func push(currentLanguage: PapagoLanguage, action: @escaping (PapagoLanguage) -> Void) {
    let identifier = String(describing: LanguageViewController.self)
    let controller: LanguageViewController = storyboard?.instantiateViewController(withIdentifier: identifier) as! LanguageViewController
    
    controller.navigationItem.title = isSource(currentLanguage) ? "원본 언어 선택" : "목적 언어 선택"
    controller.currentLanguage = isSource(currentLanguage) ? sourceLang : targetLang
    controller.submitLanguageAction = action
    
    navigationController?.pushViewController(controller, animated: true)
  }
}

// MARK: - Action
extension PapagoViewController {
  @objc private func swapLanguage() {
    let temp: PapagoLanguage = sourceLang
    sourceLang = targetLang
    targetLang = temp
  }
  
  private func callRequest() {
    
  }
}

// MARK: - Configure
extension PapagoViewController {
  private func configureUI() {
    configureButton()
  }
  
  private func configureButton() {
    sourceLangButton.setTitle(sourceLang.displayName, for: .normal)
    targetLangButton.setTitle(targetLang.displayName, for: .normal)
  }
}
