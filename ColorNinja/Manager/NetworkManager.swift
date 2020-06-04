//
//  NetworkManager.swift
//  ColorNinja
//
//  Created by Do Le Duy on 6/4/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import Reachability

class NetworkManager {
  static let shared = NetworkManager()
  
  private let reachability: Reachability
  public var hasConnection: Bool {
    get {
      return reachability.connection != Reachability.Connection.unavailable
    }
  }
  
  private init() {
    reachability = try! Reachability()

    NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
    do {
      try reachability.startNotifier()
    } catch {
      print("could not start reachability notifier")
    }
  }
  
  @objc func reachabilityChanged(note: Notification) {
    
    let reachability = note.object as! Reachability
    
    switch reachability.connection {
    case .wifi:
      print("duydl: Reachable via WiFi")
    case .cellular:
      print("duydl: Reachable via Cellular")
    case .unavailable:
      print("duydl: Network not reachable")
    case .none:
      print("duydl: None???")
    }
  }
}
