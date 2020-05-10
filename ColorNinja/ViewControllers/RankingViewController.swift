//
//  RankingViewController.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/10/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit

class RankingViewController: UIViewController {
    
    private var tableView: RankingTableView!
    private var rankingData: [RankingCellModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = RankingTableView()
        self.view.addSubview(self.tableView)
        
        
        self.tableView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(400)
        }
        
        let testData1 = RankingCellModel(ranking: 1, name: "Phuc", avatarURL: "", record: 50)
        let testData2 = RankingCellModel(ranking: 2, name: "Thi", avatarURL: "", record: 50)
        self.rankingData.append(testData1)
        self.rankingData.append(testData2)
        
        self.tableView.setRankingData(rankingData: self.rankingData)
    }


}
