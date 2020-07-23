//
//  LDBannerAdView.swift
//  ColorNinja
//
//  Created by Do Le Duy on 7/11/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import GoogleMobileAds

#if DEBUG_ADS
fileprivate let bannerAdUnitId = "ca-app-pub-3940256099942544/2934735716"
#else
fileprivate let bannerAdUnitId = "ca-app-pub-2457313692920235/2853475691"
#endif

class LDBannerAdView: GADBannerView {
  
  static let shared = LDBannerAdView()
  
  private init() {
    let padding: CGFloat = 10
    let viewWidth = ScreenSize.width - 2*padding
    let adSize: GADAdSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
    super.init(adSize: adSize, origin: CGPoint(x: 0, y: 0))
    self.adUnitID = bannerAdUnitId
    self.isAutoloadEnabled = true
  }
    
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

