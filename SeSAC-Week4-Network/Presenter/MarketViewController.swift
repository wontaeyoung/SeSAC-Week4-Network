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
    callRequest()
  }
  
  private func callRequest() {
    let url: String = RequestURL.upbit.urlStr
    
    AF
      .request(url)
      .responseDecodable(of: [Market].self) { [weak self] response in
        guard let self else { return }
        
        switch response.result {
          case .success(let success):
            markets = success
            
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
