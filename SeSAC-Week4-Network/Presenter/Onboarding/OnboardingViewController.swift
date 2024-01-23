//
//  OnboardingViewController.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/19/24.
//

import UIKit

final class OnboardingViewController: UIViewController {
  
  @IBOutlet weak var localNotificationButton: UIButton!
  @IBOutlet weak var label: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "온보딩 화면"
    
    label.text = "안녕하세요~"
    
    label.font = Constant.Font2.Title.bold
    localNotificationButton.titleLabel?.font = Constant.Font.Bold.title
    
    localNotificationButton.configuration = .sesacStyle()
  }
  
  private func configureButton() {
    // iOS 15 이전
    localNotificationButton.setTitle("버튼", for: .normal)
    localNotificationButton.setImage(.add, for: .normal)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    /*
    showAlert(
      title: "삭제",
      message: "최근 검색어를 삭제하시겠습니까?",
      buttonTitle: "확인"
    ) {
      print("최근 검색어가 삭제되었습니다.")
    }
     */
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

/** 알림 관련 정책
 1. TimeInterval 60s 이상이어야 반복 가능
 2. Foreground 상태에서는 알림이 오지 않는 것이 Default
    - 알림의 기본 의의가 Retention 증가이기때문에, 이미 Foreground에 있는 유저에게는 보내지 않음
    - 카카오톡에서 Foreground일 때 알림이 오는 것은, 커스텀 Notification을 만들어서 사용하기 때문
    - Foreground에서 알림을 받고 싶다면, Delegate에서 별도로 설정 가능
 3. Identifier는 앱에 최대 64개까지 설정 가능
 4. 사용자가 실제로 알림을 몇 개 받았는지, 알림센터에 보이고 있는지에 대한 정보는 정책상 획득할 수 없음 -> 안드로이드는 가능
    - 사용자가 알림을 '탭'했을 때만 확인 가능
    - 기획자, 마케팅 측에서 운영상 이유로 물어보는데, 안된다는 사실을 명확하게 알아야함
    - ex) 알림을 유저가 성공적으로 받았을 때 쿠폰을 제공하기 (X)
          알림을 유저가 탭했을 때 쿠폰을 제공하기 (O)
 */
extension OnboardingViewController {
  @IBAction func notificationButtonTapped(_ sender: UIButton) {
    
    /// 1. 컨텐츠
    /// UN은 UserNotification 줄임말
    /// 인스턴스 안에 타이틀, 뱃지와 같은 값들이 있음
    let content = UNMutableNotificationContent()
    content.title = "장바구니 확인해보셨나요?"
    content.body = "찜한 상품을 구매해보세요."
    /// iOS에서는 뱃지를 직접 숫자로 관리함
    /// 카카오톡에서 읽은 채팅 갯수에 따라 뱃지 값이 변경되는데, 이건 직접 관리하고 있다는 것
    /// 안드로이드에서는 알림 갯수를 체크해서 디폴트로 들어감
    /// 뱃지를 지우는 로직도 따로 설정해야함, 안그러면 영원히 남아있음

    content.badge = 100
    
    /// 2. 트리거
    /// Time Interval
    let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    
    ///  Calendar / Location
    ///  hour 10 / munute 30으로 설정하면 매일 10시 30분에 오지만, hour를 설정하지 않으면 매 시간 30분마다 알림이 옴
    ///  30분마다가 아니라 시각이 30분일 때 오는 것
    var dateComponent = DateComponents()
    dateComponent.hour = 11
    dateComponent.minute = 24
    
    let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
    
    /// 3. 요청하기
    /// Identifier는 알림 1개에 대한 고유한 값
    /// 같은 앱에 대해 알림이 5개가 와있다면 이 5개의 Identifier가 모두 다르다는 것
    /// 같은 Identifier의 알림이 새로 방출되면 스택에 있는 해당 알림이 교체됨
    /// 가장 쉽게 Identifier를 구별하는 것은 Date로 찍는 것
    let request = UNNotificationRequest(
      identifier: Date.now.formatted(),
      content: content,
      trigger: calendarTrigger
    )
    
    /// 4. 등록하기
    /// 생성한 요청으로 알림센터에 등록
    /// 앱 상태가 Foreground에 있으면 알림이 오지 않음
    UNUserNotificationCenter.current().add(request)
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  /// Foreground 상태에서 어떻게 처리해줄지 물어보는 액션
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    /// 현재는 항상 받도록 하는 것
    /// 나중에는 현재 보고 있는 화면에 대해 조건 처리를 통해 알림 여부를 결정하는 작업도 가능함
    ///   ex) 내가 채팅하고있는 상대방의 채팅에 대해서는 알림이 오지 않음
    completionHandler([.badge, .banner, .list, .sound])
  }
}
