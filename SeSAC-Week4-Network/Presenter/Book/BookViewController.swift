//
//  BookViewController.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/17/24.
//

import UIKit
import Alamofire

final class BookViewController: UIViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var collectionView: UICollectionView!
  
  private let manager = APIManager()
  private var books: [Book] = [] {
    didSet {
      collectionView.reloadData()
    }
  }
  
  private var isEnd: Bool = false
  private var page: Int = 1
  
  private let cellCount: Int = 2
  private let cellSpacing: CGFloat = 16
  private var cellWidth: CGFloat {
    let lineWidth: CGFloat = (UIScreen.main.bounds.width - (cellSpacing * CGFloat(2 + cellCount - 1))) / CGFloat(cellCount)
    
    return lineWidth
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    register()
    configureSearchBar()
    configureCollectionView()
    
    let button = UIBarButtonItem(
      title: "처음부터 시작하기", 
      style: .plain,
      target: self, 
      action: #selector(restartButtonTapped)
    )
    
    navigationItem.rightBarButtonItem = button
  }
  
  @objc private func restartButtonTapped(_ sender: UIButton) {
    // 화면 전환이 아니라, 아예 처음처럼. 앱이 처음 실행한 것처럼 만들자
    /// sceneDelegate Window RootView
    // UIApplication 싱글톤 인스턴스의 Scene 목록에서 첫 번째를 가져오기
    print("Scene 갯수", UIApplication.shared.connectedScenes.count)
    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    let sceneDelegate = windowScene?.delegate as? SceneDelegate
    
    let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: OnboardingViewController.identifier)
    let rootViewController = UINavigationController(rootViewController: controller)
    
    sceneDelegate?.window?.rootViewController = rootViewController
    sceneDelegate?.window?.makeKeyAndVisible()
  }
  
  private func callRequest() {
    // Kakao는 한글 쿼리에 대해 내부적으로 인코딩을 해주지만 Naver 검색은 직접 해주어야 함
    // addingPercentEncoding 메서드로 텍스트를 인코딩할 수 있음
    let query = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    
    let parameters: Parameters = [
      "target": "title",
      "query": query,
      "size": 50,
      "page": page
    ]
    
    let headers: HTTPHeaders = ["Authorization": APIKey.Kakao.authorization]
    
    manager.callRequest(
      type: BookRequest.self,
      requestType: .book,
      header: headers,
      parameter: parameters)
    { [weak self] result in
      guard let self else { return }
      
      dump(result.meta)
      
      let newBooks: [Book] = result.documents.map { $0.asBook }
      books.append(contentsOf: newBooks)
      self.isEnd = result.meta.isEnd
    }
  }
}

// MARK: - CollectionView
extension BookViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
  /// UICollectionViewDataSourcePrefetching: iOS 10+
  /// 셀이 화면에 보이기 직전에 필요한 리소스를 다운로드하는 기능
  /// 필요한 시점은 애플이 내부적으로 알아서 결정함
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    guard !isEnd else { return }
    
    print("Prefetch \(indexPaths)")
    
    indexPaths
      .forEach { path in
        if path.row + 1 == books.count {
          page += 1
          callRequest()
        }
      }
  }
  
  func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
    print("Cancel \(indexPaths)")
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return books.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let identifier: String = String(describing: BookCollectionViewCell.self)
    let cell: BookCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! BookCollectionViewCell
    let row: Int = indexPath.row
    let book: Book = books[row]
    
    cell.setData(data: book)
    
    return cell
  }
  
  private func configureCollectionView() {
    let layout = UICollectionViewFlowLayout()
    
    layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
    layout.sectionInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
    layout.minimumLineSpacing = cellSpacing
    layout.minimumInteritemSpacing = cellSpacing
    
    collectionView.collectionViewLayout = layout
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.prefetchDataSource = self
  }
  
  private func register() {
    let identifier = String(describing: BookCollectionViewCell.self)
    let xib = UINib(nibName: identifier, bundle: nil)
    collectionView.register(xib, forCellWithReuseIdentifier: identifier)
  }
}

// MARK: - SearchBar
extension BookViewController: UISearchBarDelegate {
  private func configureSearchBar() {
    searchBar.placeholder = "책 이름을 입력해주세요!"
    searchBar.autocorrectionType = .no
    searchBar.autocapitalizationType = .none
    searchBar.searchBarStyle = .minimal
  }
  
  private func resetRequestInfo() {
    // 스크롤 위치를 시작 지점으로 이동
    // scrollsToTop은 animation을 조절할 수 없어서 스크롤 애니메이션이 사용자에게 보여짐
    // scrollsToRow는 animation 관리는 가능하지만 TableView에서만 가능함
    self.collectionView.contentOffset = .zero
    self.books.removeAll() // 기존 데이터 삭제
    self.page = 1 // 페이지 번호 초기화
    self.isEnd = false // 마지막 데이터 조회 여부 초기화
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    resetRequestInfo()
    callRequest()
  }
}
