//
//  BookCollectionViewCell.swift
//  SeSAC-Week4-Network
//
//  Created by 원태영 on 1/17/24.
//

import UIKit
import Kingfisher

final class BookCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    configureCell()
  }
  
  private func configureCell() {
    contentView.backgroundColor = .black
    contentView.clipsToBounds = true
    contentView.layer.cornerRadius = 20
    
    titleLabel.textColor = .white
    titleLabel.font = .boldSystemFont(ofSize: 17)
    titleLabel.textAlignment = .left
    
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 10
  }
 
  func setData(data: Book) {
    titleLabel.text = data.title
    imageView.kf.setImage(with: data.url)
  }
}
