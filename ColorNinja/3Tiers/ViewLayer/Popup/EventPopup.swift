//
//  EventPopup.swift
//  ColorNinja
//
//  Created by Do Le Duy on 6/27/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class EventPopup : PopupViewController {
  
  // MARK: Instance property
  
  private var topViewContainer: UIView!
  private var topViewTitleLabel: UILabel!
  private var eventNameLabel: UILabel!
  
  // MARK: Override
  
  override var contentSize: CGSize {
    let width = scaledValue(300)
    return CGSize(width: width, height: width)
  }
  
  override var cornerRadius: CGFloat {
    return scaledValue(10)
  }
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  // MARK: Setup View
  
  private func setupViews() {
    
    /// ContentView
    contentView.clipsToBounds = true
    
    /// TopView
    let topViewHeight = scaledValue(80)
    topViewContainer = UIView()
    topViewContainer.backgroundColor = Color.Zalo.blue1
    contentView.addSubview(topViewContainer)
    topViewContainer.snp.makeConstraints { (make) in
      make.top.left.right.equalToSuperview()
      make.height.equalTo(topViewHeight)
    }
    
    /// TopView Title
    let titleFontSize = scaledValue(25)
    let paddingTop = scaledValue(5)
    let textTitle = "Thông báo"
    topViewTitleLabel = UILabel()
    topViewTitleLabel.text = textTitle
    topViewTitleLabel.textColor = .white
    topViewTitleLabel.font = UIFont.systemFont(ofSize: titleFontSize, weight: .bold)
    topViewContainer.addSubview(topViewTitleLabel)
    topViewTitleLabel.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(paddingTop)
    }
    
    /// EventName:
    let eventTitleFontSize = scaledValue(20)
    let eventName = "Đua top nhận quà"
    eventNameLabel = UILabel()
    eventNameLabel.text = "Event: \(eventName)"
    eventNameLabel.font = UIFont.systemFont(ofSize: eventTitleFontSize)
    eventNameLabel.textColor = .white
    topViewContainer.addSubview(eventNameLabel)
    eventNameLabel.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(topViewTitleLabel.snp.bottom).offset(paddingTop)
    }
  }
  
}
