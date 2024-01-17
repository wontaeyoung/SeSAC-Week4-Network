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
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  private func callRequest() {
    // Kakao는 한글 쿼리에 대해 내부적으로 인코딩을 해주지만 Naver 검색은 직접 해주어야 함
    // addingPercentEncoding 메서드로 텍스트를 인코딩할 수 있음
    let query = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let url: String = RequestURL.book.urlStr
    
    let parameters: Parameters = [
      "target": "title",
      "query": query,
      "size": 5
    ]
    
    let headers: HTTPHeaders = ["Authorization": APIKey.Kakao.authorization]
    
    AF
      .request(url, method: .post, parameters: parameters, headers: headers)
      .responseDecodable(of: Book.self) { [weak self] response in
        guard let self else { return }
        
        switch response.result {
          case .success(let data):
            dump(data)
            
          case .failure(let failure):
            print(failure.localizedDescription)
        }
      }
  }
  
  private func configureSearchBar() {
    searchBar.placeholder = "책 이름을 입력해주세요!"
    searchBar.autocorrectionType = .no
    searchBar.autocapitalizationType = .none
  }
}

extension BookViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    callRequest()
  }
}
