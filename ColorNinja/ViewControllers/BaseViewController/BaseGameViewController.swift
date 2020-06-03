//
//  BaseGameViewController.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/16/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class BaseGameViewController : BaseViewController {
  
  private var readyListString : [String] = ["Default"]
  
  var readyLabel: UILabel!
  var boardContainer: UIView!
  var topContainer : UIView!
  var boardCollectionView : BoardCollectionView!
  let boardDataSource: BoardDataSource = BoardDataSource()
  var currentLevel : LevelModel = LevelModel(levelIndex: 0)
  var shrinkCell : Bool = true
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Public APIs
  
  func startAnimationReadyView(withList listString:[String], completion: ((Bool) -> ())?) {
    readyListString = listString
    self.animationReadyView(index: 0, completion: completion)
  }
  
  func showAlertWithMessage(message: String) {
    let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
    
  }
  
  // MARK: - SetupViews
  
  override func setupViews() {
    super.setupViews()
    
    self.setupTopContainer()
    self.setupBoardContainer()
    self.setupReadyView()
  }
  
  private func setupReadyView() {
    readyLabel = UILabel()
    self.view.addSubview(readyLabel)
    readyLabel.textAlignment = .center
    readyLabel.textColor = Constants.GameScreen.ReadyView.textColor
    readyLabel.font = UIFont.systemFont(ofSize: Constants.GameScreen.ReadyView.fontSize, weight: .heavy)
    readyLabel.alpha = 0.0
    readyLabel.snp.makeConstraints { (make) in
      make.center.equalTo(self.view)
    }
  }
  
  private func setupBoardContainer() {
    
    // Container
    boardContainer = UIView()
    self.view.addSubview(boardContainer)
    boardContainer.snp.makeConstraints { (make) in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(self.topContainer.snp.bottom)
    }
    
    // Board
    let flowLayout = BoardCollectionViewFlowLayout()
    flowLayout.minimumInteritemSpacing = 0.0
    flowLayout.minimumLineSpacing = Constants.GameScreen.BoardCollectionView.spacingBetweenCells
    boardCollectionView = BoardCollectionView(frame: .zero, collectionViewLayout: flowLayout)
    boardCollectionView.clipsToBounds = false
    boardContainer.addSubview(boardCollectionView)
    boardCollectionView.alpha = 0.0
    boardCollectionView.backgroundColor = .clear
    boardCollectionView.dataSource = boardDataSource
    boardCollectionView.delegate = self
    boardCollectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: Constants.GameScreen.BoardCollectionView.cellId)
    let boardWidth = Constants.GameScreen.BoardCollectionView.boardWidth
    boardCollectionView.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
      make.width.height.equalTo(boardWidth)
    }
  }
  
  private func setupTopContainer() {
    topContainer = UIView()
    self.view.addSubview(topContainer)
    topContainer.snp.makeConstraints { (make) in
      make.top.equalTo(settingButton.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(Constants.GameScreen.LabelsContainer.height)
    }
  }
  
  // MARK: - Support animations
  
  private func animationReadyView(index: Int, completion: ((Bool) -> ())? ) {
    
    if index > self.readyListString.count - 1 {
      if let completion = completion {
        completion(true)
      }
      return
    }
    
    self.readyLabel.text = readyListString[index]
    UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseInOut, animations: {
      self.readyLabel.alpha = 1.0
      self.readyLabel.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
    }) { (success) in
      Thread.sleep(forTimeInterval: 0.3)
      self.readyLabel.transform = CGAffineTransform(scaleX: 1/0.4, y: 1/0.4)
      self.readyLabel.alpha = 0.0
      self.animationReadyView(index: index + 1, completion: completion)
    }
  }
  
  // MARK: - GameFlow
  
  func showCurrentLevel() {
    
    // Update level for DataSource
    boardDataSource.levelModel = currentLevel
    
    // ReloadData
    self.boardCollectionView.reloadData()
    self.boardCollectionView.layoutIfNeeded()
    
    // ReloadItems to gain animations:
    self.boardCollectionView.alpha = 1.0
    self.shrinkCell = false
    self.boardCollectionView.reloadItems(at: self.boardCollectionView.indexPathsForVisibleItems)
  }
}


// MARK: - CollectionView Delegate

extension BaseGameViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let itemWidth = currentLevel.cellWidth
    return shrinkCell ? .zero : CGSize(width: itemWidth, height: itemWidth)
  }
}
