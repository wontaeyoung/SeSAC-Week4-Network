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
  }
  
  private func callRequest() {
    // Kakao는 한글 쿼리에 대해 내부적으로 인코딩을 해주지만 Naver 검색은 직접 해주어야 함
    // addingPercentEncoding 메서드로 텍스트를 인코딩할 수 있음
    let query = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    
    let parameters: Parameters = [
      "target": "title",
      "query": query,
      "size": 30
    ]
    
    let headers: HTTPHeaders = ["Authorization": APIKey.Kakao.authorization]
    
    manager.callRequest(
      type: BookRequest.self,
      requestType: .book,
      header: headers,
      parameter: parameters)
    { [weak self] result in
      guard let self else { return }
      
      books = result.documents.map { $0.asBook }
    }
  }
}

// MARK: - CollectionView
extension BookViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    callRequest()
  }
}
