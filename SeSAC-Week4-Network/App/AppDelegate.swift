//
//  AppDelegate.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/16/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    /// 일반적으로 AppDelegate에서 사용자 권한 요청을 작성하는 편
    
    /// AppDelegate를 Delegate로 설정
    UNUserNotificationCenter.current().delegate = self
    
    // 알림 권한 설정
    /// Local, Push 알림을 모두 담당하고 있음
    /// current는 내 앱의 알림을 담당하고 있는 인스턴스
    /// option에서 알림, 뱃지, 사운드와 같은 권한 옵션들을 선택할 수 있음
    /// (Bool, Error)에 대한 completion을 구현할 수 있음
    UNUserNotificationCenter
      .current()
      .requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        print("Success -", success)
        print("Error -", error)
      }
    
    // Override point for customization after application launch.
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
}

