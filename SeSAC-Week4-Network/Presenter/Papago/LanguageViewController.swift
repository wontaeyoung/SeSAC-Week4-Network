//
//  LanguageViewController.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/17/24.
//

import UIKit

final class LanguageViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var currentLanguage: PapagoLanguage?
  var submitLanguageAction: ((PapagoLanguage) -> Void)?
  var currentLanguageIndex: Int? {
    return PapagoLanguage.allCases.firstIndex(of: currentLanguage ?? .korean)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    setSaveBarButtonItem()
  }
  
  private func setSaveBarButtonItem() {
    let button = UIBarButtonItem(
      title: "저장",
      style: .plain,
      target: self,
      action: #selector(saveButtonTapped)
    )
    
    navigationItem.rightBarButtonItem = button
    navigationController?.navigationBar.tintColor = .label
  }
  
  @objc private func saveButtonTapped(_ sender: UIButton) {
    self.submitLanguageAction?(currentLanguage!)
    navigationController?.popViewController(animated: true)
  }
}

extension LanguageViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return PapagoLanguage.allCases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageTableViewCell", for: indexPath)
    let cellLanguage: String = PapagoLanguage.displayNameList[indexPath.row]
    
    cell.textLabel?.text = cellLanguage
    cell.textLabel?.textColor = .label
    
    if currentLanguageIndex == indexPath.row {
      cell.textLabel?.textColor = .systemGreen
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedLanguage: String = PapagoLanguage.displayNameList[indexPath.row]
    let papagoLanguage: PapagoLanguage = PapagoLanguage(rawValue: selectedLanguage)!
    self.currentLanguage = papagoLanguage
    tableView.reloadData()
  }
}
