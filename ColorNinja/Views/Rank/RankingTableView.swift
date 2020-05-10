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
        self.rankingTableView = UITableView()
        self.rankingTableView.delegate = self
        self.rankingTableView.dataSource = self
        self.addSubview(self.rankingTableView)
        self.rankingTableView.register(RankingTableViewCell.self, forCellReuseIdentifier: kRankingTableViewCell)
        
        self.rankingTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.rankingTableView.separatorStyle = .none
        self.rankingTableView.allowsSelection = false
        self.rankingTableView.backgroundColor = .white
        //         self.tableView.tableFooterView = UIView()
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
        cell .shouldUpdateCell(cellObject: cellObject)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellObject = rankingData[indexPath.row]
        return RankingTableViewCell.heightForCell(cellObject: cellObject, indexPath: indexPath, tableView: tableView)
    }
    
    
}
