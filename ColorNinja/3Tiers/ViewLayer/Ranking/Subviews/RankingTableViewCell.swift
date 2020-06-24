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
    
    self.contentView.addSubview(self.imgAvatar)
    self.contentView.addSubview(self.rankingLabel)
    self.contentView.addSubview(self.nameLabel)
    self.contentView.addSubview(self.recordLabel)
    
    
    self.rankingLabel.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.left.equalToSuperview().offset(RankingTableViewCell.padding)
      make.width.height.equalTo(30)
    }
    
    self.imgAvatar.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.left.equalTo(self.rankingLabel.snp.right).offset(20)
      make.width.height.equalTo(30)
    }
    
    
    self.recordLabel.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.right.equalToSuperview().offset(-RankingTableViewCell.padding)
      make.height.equalTo(30)
      make.width.equalTo(50)
    }
    
    self.nameLabel.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.right.equalTo(self.recordLabel.snp.left).offset(20)
      make.left.equalTo(self.imgAvatar.snp.right).offset(10)
      make.height.equalTo(30)
    }
  }
  
  public func shouldUpdateCell(cellObject: RankingCellModel) {
    self.rankingLabel.text = "\(cellObject.ranking)"
    self.nameLabel.text = getRealNameWithoutPlus(name: cellObject.name)
    self.recordLabel.text = "\(cellObject.record)"
    self.rankingLabel.textColor = cellObject.playerType.colorTitle
    
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
