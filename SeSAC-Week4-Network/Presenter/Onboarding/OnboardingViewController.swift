//
//  OnboardingViewController.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/19/24.
//

import UIKit

final class OnboardingViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "온보딩 화면"
  }
  
  @IBAction func startButtonTapped(_ sender: UIButton) {
    
    // 온보딩 여부 상태값 변경
    UserDefaults.standard.setValue(true, forKey: "onboarded")
    print("온보딩 되었습니다.")
    
    // 메인 화면 시작
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
    
//    navigationController?.pushViewController(controller, animated: false)
    /// 1. 애니메이션 해제 후 풀스크린으로 띄우기
    /// 사용자 관점에서는 어색하지 않게 메인 화면으로 전환할 수 있음
    controller.modalPresentationStyle = .fullScreen
    present(controller, animated: false)
    
    /// 2. 온보딩 -> 메인 화면 과정도 메모리에서 온보딩을 내려야하기 때문에 SceneDelegate로 전환해야함
    
  }
}
