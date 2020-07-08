//
//  RankingTableViewCell.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/10/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit

fileprivate let fontSize = scaledValue(16)

class RankingTableViewCell: UITableViewCell {
  
  // MARK: - Constants
  static let padding: Int = 15;
  
  // MARK: - Property
  private var imgAvatar: UIImageView!
  private var rankingLabel: UILabel!
  private var nameLabel: UILabel!
  private var recordLabel: UILabel!
  private var rateLabel: UILabel!
  
  override func prepareForReuse() {
    self.contentView.backgroundColor = Constants.GameScreen.forcegroundColor
    imgAvatar.image = nil
    rankingLabel.text = nil
  }
  
  // MARK: - Initialize
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super .init(style: style, reuseIdentifier: reuseIdentifier)
    self.setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup view
  
  private func setupView() {
    
    self.contentView.backgroundColor = Constants.GameScreen.forcegroundColor
    
    self.imgAvatar = UIImageView()
    self.imgAvatar.layer.cornerRadius = 30.0/2
    self.imgAvatar.clipsToBounds = true
    
    self.rankingLabel = UILabel()
    self.rankingLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    self.rankingLabel.textColor = .white
    self.rankingLabel.textAlignment = .center
    
    self.nameLabel = UILabel()
    self.nameLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    self.nameLabel.textColor = .white
    
    self.recordLabel = UILabel()
    self.recordLabel.textAlignment = .center
    self.recordLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    self.recordLabel.textColor = .white

    self.rateLabel = UILabel()
    self.rateLabel.textAlignment = .center
    self.rateLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    self.rateLabel.textColor = .white
    self.rateLabel.text = "100%"
    
    self.contentView.addSubview(self.imgAvatar)
    self.contentView.addSubview(self.rankingLabel)
    self.contentView.addSubview(self.nameLabel)
    self.contentView.addSubview(self.recordLabel)
    self.contentView.addSubview(self.rateLabel)
    
    self.rankingLabel.snp.makeConstraints { (make) in
      make.centerY.height.equalToSuperview()
      make.left.equalToSuperview().offset(10)
      make.width.equalTo(30)
    }
    
    self.imgAvatar.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.left.equalTo(self.rankingLabel.snp.right).offset(5)
      make.width.height.equalTo(30)
    }
        
    self.nameLabel.snp.makeConstraints { (make) in
      make.height.centerY.equalToSuperview()
      make.left.equalTo(imgAvatar.snp.right).offset(10)
      make.right.equalTo(recordLabel.snp.left).offset(-5)
    }
    
    self.rateLabel.snp.makeConstraints { (make) in
      make.height.centerY.equalToSuperview()
      make.width.equalTo(45)
      make.right.equalToSuperview().offset(-5)
    }
    
    self.recordLabel.snp.makeConstraints { (make) in
      make.height.centerY.equalToSuperview()
      make.right.equalTo(rateLabel.snp.left).offset(-5)
      make.width.equalTo(50)
    }
    
  }
  
  public func shouldUpdateCell(cellObject: RankingCellModel) {
    self.rankingLabel.text = "\(cellObject.ranking)"
    self.nameLabel.text = getRealNameWithoutPlus(name: cellObject.name)
    self.recordLabel.text = "\(cellObject.record)"
    self.rankingLabel.textColor = cellObject.playerType.colorTitle
    self.rateLabel.text = "\(cellObject.rate ?? 0)%"
    
    if cellObject.playerType != .normal {
      self.rankingLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    self.imgAvatar.image = UIImage(named: "defaultAvatar")
    if let avatarUrl = cellObject.avatarURL {
      self.imgAvatar.setImageWithLink(from: avatarUrl)
    }
  }
  
  static public func heightForCell(cellObject: RankingCellModel, indexPath: IndexPath, tableView: UITableView) -> CGFloat {
    return scaledValue(50);
  }
}
