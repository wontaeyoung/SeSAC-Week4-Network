//
//  SceneDelegate.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/16/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  // ViewController가 모두 올라가는 곳
  // nil -> Storyboard Init
  var window: UIWindow?
  
  /// 이 함수를 작성하지 않으면 스토리보드 속성 설정을 기반으로 화면이 시작됨
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    UserDefaults.standard.setValue(true, forKey: "Onboarded")
    // 사용자의 첫 화면을 결정하기 위한 값
    let onboarded: Bool = UserDefaults.standard.bool(forKey: "Onboarded")
    
    /// 온보딩이 아니라면 온보딩 화면 띄우기
    guard onboarded else {
      // 코드를 통해 앱 시작 화면 설정
      guard let scene = (scene as? UIWindowScene) else {
        print("Return")
        return
      }
      
      // 윈도우가 nil이 아니도록 인스턴스 할당
      window = UIWindow(windowScene: scene)
      
      // 스토리보드에서 ViewController 찾아오기
      let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
      let controller = storyboard.instantiateViewController(withIdentifier: OnboardingViewController.identifier)
      
      // 네비게이션 컨트롤러로 시작하려면 VC를 NavigationController의 Root로 설정
      let rootNavigationController = UINavigationController(rootViewController: controller)
      
      // 네비게이션 컨트롤러를 윈도우의 시작 컨트롤러로 설정
      window?.rootViewController = rootNavigationController
      
      // 코드로 화면을 시작할 때 적용하는 설정
      window?.makeKeyAndVisible()
      
      return
    }
    
    /// - 온보딩 완료 유저라면 메인 화면 시작
    guard let scene = (scene as? UIWindowScene) else {
      print("Return")
      return
    }
    
    // 윈도우가 nil이 아니도록 인스턴스 할당
    window = UIWindow(windowScene: scene)
    
    // 스토리보드에서 ViewController 찾아오기
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
    
    // 네비게이션 컨트롤러를 윈도우의 시작 컨트롤러로 설정
    window?.rootViewController = controller
    
    // 코드로 화면을 시작할 때 적용하는 설정
    window?.makeKeyAndVisible()
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }
  
  
}

