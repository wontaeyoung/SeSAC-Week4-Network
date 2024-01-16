//
//  MarketViewController.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/16/24.
//

import UIKit
import Alamofire

final class MarketViewController: UIViewController {
  
  @IBOutlet weak var marketTableView: UITableView!
  
  private var markets: [Market] = [] {
    didSet {
      marketTableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureTableView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    callRequest()
  }
  
  private func callRequest() {
    let url: String = RequestURL.upbit.urlStr
    
    AF
      .request(url)
      .validate(statusCode: 200...500) // 상태 코드에 포함되어있어야 result가 success로 반환됨
      .responseDecodable(of: [Market].self) { [weak self] response in
        guard let self else { return }
        
        switch response.result {
          case .success(let success):
            let statusCode = response.response?.statusCode
            
            if statusCode == 200 {
              markets = success
            } else if statusCode == 500 {
              print("오류가 발생했어요. 잠시 후 다시 시도해주세요.")
            }
            
          case .failure(let failure):
            print(#function, failure.errorDescription ?? "에러 발생")
        }
      }
  }
}

extension MarketViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return markets.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MarketTableViewCell", for: indexPath)
    let row: Int = indexPath.row
    let market: Market = markets[row]
    
    cell.textLabel?.text = market.korean_name
    cell.detailTextLabel?.text = market.market
    
    return cell
  }
  
  private func configureTableView() {
    marketTableView.delegate = self
    marketTableView.dataSource = self
  }
}
