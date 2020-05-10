//
//  RankingTableViewCell.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/10/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit
import SnapKit

class RankingTableViewCell: UITableViewCell {
    
     // MARK: - Constants
    static let padding: Int = 10;
    
    // MARK: - Property
    private var imgAvatar: UIImageView!
    private var rankingLabel: UILabel!
    private var nameLabel: UILabel!
    private var recordLabel: UILabel!
    
    
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
        self.imgAvatar = UIImageView()
        self.rankingLabel = UILabel()
        self.nameLabel = UILabel()
        self.recordLabel = UILabel()
        
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
        self.nameLabel.text = cellObject.name
        self.recordLabel.text = "\(cellObject.record)"
        
        if let image = UIImage(named: cellObject.avatarURL) {
            self.imgAvatar.image = image
        }
    }
    
    
    static public func heightForCell(cellObject: RankingCellModel, indexPath: IndexPath, tableView: UITableView) -> CGFloat
    {
        return 50;
    }
}
