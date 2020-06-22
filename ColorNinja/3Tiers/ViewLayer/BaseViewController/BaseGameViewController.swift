//
//  BaseGameViewController.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/16/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

#if DEBUG_ADS
fileprivate let bannderIngameId = "ca-app-pub-3940256099942544/2934735716"
#else
fileprivate let bannderIngameId = "ca-app-pub-2457313692920235/1972710690"
#endif

class BaseGameViewController : BaseViewController {
  
  //Public
  public var topContainer : UIView!
  public var boardCollectionView : BoardCollectionView!
  public var currentLevel : LevelModel = LevelModel(levelIndex: 0)
  public var activityIndicator = UIActivityIndicatorView()
  public var shrinkCell : Bool = true
  public var adBannerView: GADBannerView!

  //Private
  private var readyLabel: UILabel!
  private var boardContainer: UIView!
  private let boardDataSource: BoardDataSource = BoardDataSource()
  private var readyListString : [String] = ["Default"]
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: Override
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }
  
  override func setupViews() {
    super.setupViews()
    
    setupTopContainer()
    setupBoardContainer()
    setupReadyView()
    setupIndicator()
    setupBannerAd()
  }

  // MARK: Public APIs
  
  func startAnimationReadyView(withList listString:[String], completion: ((Bool) -> ())?) {
    readyListString = listString
    self.animationReadyView(index: 0, completion: completion)
  }
  
  func showAlertWithMessage(message: String) {
    let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
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
  
  func zoomLabelAnimation(scale: CGFloat, label: UILabel, text: String) {
    label.text = text
    UIView.animate(withDuration: 0.2, animations: {
      label.transform = CGAffineTransform(scaleX: scale, y: scale)
    }, completion: { _ in
      UIView.animate(withDuration: 0.2) {
        label.transform = CGAffineTransform(scaleX: CGFloat(1.0), y: CGFloat(1.0))
      }
    })
  }
  
  // MARK: SetupViews
    
  private func setupReadyView() {
    readyLabel = UILabel()
    self.view.addSubview(readyLabel)
    readyLabel.textAlignment = .center
    readyLabel.textColor = Constants.GameScreen.ReadyView.textColor
    readyLabel.font = UIFont.systemFont(ofSize: scaledValue(Constants.GameScreen.ReadyView.fontSize), weight: .heavy)
    readyLabel.alpha = 0.0
    readyLabel.snp.makeConstraints { (make) in
      make.center.equalTo(self.view)
    }
  }
  
  private func setupBoardContainer() {
    
    // Container
    boardContainer = UIView()
    self.view.addSubview(boardContainer)
    
    if  UIDevice.current.userInterfaceIdiom == .pad {
      boardContainer.snp.makeConstraints { (make) in
        make.width.height.equalTo(500)
        make.center.equalToSuperview()
      }
    } else {
      boardContainer.snp.makeConstraints { (make) in
        make.leading.trailing.bottom.equalToSuperview()
        make.top.equalTo(self.topContainer.snp.bottom)
      }
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
  
  private func setupIndicator() {
    view.addSubview(activityIndicator)
    activityIndicator.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
  }
  
  private func setupBannerAd() {
    adBannerView = GADBannerView()
    adBannerView.rootViewController = self
    adBannerView.adUnitID = bannderIngameId
    adBannerView.load(GADRequest())
    view.addSubview(adBannerView)
    
    let padding: CGFloat = 10
    let viewWidth = ScreenSize.width - 2*padding
    let bottomPadding = safeAreaBottom() > 0 ? safeAreaBottom() : padding
    
    adBannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
    adBannerView.snp.makeConstraints { (make) in
      make.bottom.equalTo(-bottomPadding)
      make.centerX.equalToSuperview()
    }
  }
  
  // MARK: Support animations
  
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
}


// MARK: CollectionView Delegate

extension BaseGameViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let itemWidth = currentLevel.cellWidth
    return shrinkCell ? .zero : CGSize(width: itemWidth, height: itemWidth)
  }
}
