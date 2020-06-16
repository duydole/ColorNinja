//
//  RankingTableView.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/10/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit

fileprivate let kRankingTableViewCell = "RankingTableViewCell"

class RankingTableView: UIView {

    private var rankingTableView: UITableView!
    private var rankingData: [RankingCellModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        self.backgroundColor = Constants.GameScreen.forcegroundColor
        self.rankingTableView = UITableView()
        
        self.rankingTableView.backgroundColor = Constants.GameScreen.forcegroundColor
        self.rankingTableView.delegate = self
        self.rankingTableView.dataSource = self
        self.addSubview(self.rankingTableView)
        self.rankingTableView.register(RankingTableViewCell.self, forCellReuseIdentifier: kRankingTableViewCell)
        
        self.rankingTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.rankingTableView.separatorStyle = .none
        self.rankingTableView.allowsSelection = false
    }
    
    public func setRankingData(rankingData: [RankingCellModel]) {
        self.rankingData = rankingData
        self.rankingTableView.reloadData()
    }
    
}

extension RankingTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.rankingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.rankingTableView.dequeueReusableCell(withIdentifier: kRankingTableViewCell, for: indexPath) as? RankingTableViewCell else {
            return UITableViewCell()
        }
        let cellObject = rankingData[indexPath.row]
        cell.shouldUpdateCell(cellObject: cellObject)
        if cellObject.id == OwnerInfo.shared.userId {
            cell.contentView.backgroundColor = ColorRGB(55, 55, 55)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellObject = rankingData[indexPath.row]
        return RankingTableViewCell.heightForCell(cellObject: cellObject, indexPath: indexPath, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = self .setupHeaderView()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    
    private func setupHeaderView() -> UIView {
        
        let headerView = UIView()
        headerView.backgroundColor = Constants.GameScreen.forcegroundColor
        
        let rankingLabel = UILabel()
        rankingLabel.textAlignment = .center
        rankingLabel.text = "NO"
        rankingLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        rankingLabel.textColor = .white
        
        let nameLabel = UILabel()
        nameLabel.text = "NAME"
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nameLabel.textColor = .white
        
        let recordLabel = UILabel()
        recordLabel.textAlignment = .center
        recordLabel.text = "BEST SCORE"
        recordLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        recordLabel.textColor = .white
        headerView.addSubview(rankingLabel)
        headerView.addSubview(nameLabel)
        headerView.addSubview(recordLabel)
        
        
        rankingLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(RankingTableViewCell.padding)
            make.width.height.equalTo(30)
        }

        recordLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-RankingTableViewCell.padding)
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(recordLabel.snp.left).offset(20)
            make.left.equalTo(rankingLabel.snp.right).offset(30)
            make.height.equalTo(30)
        }
        
        return headerView
    }
}
