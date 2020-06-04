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
  
  private let reachaBility = try? Reachability()
  public var hasConnection: Bool {
    get {
      return reachaBility?.connection != Reachability.Connection.unavailable
    }
  }
  
  private init() {
    
  }
}
