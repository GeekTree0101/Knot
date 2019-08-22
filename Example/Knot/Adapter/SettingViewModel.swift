//
//  SettingViewModel.swift
//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import Foundation
import Knot
import DeepDiff

enum SettingViewModel {
  
  struct CellState: KnotState {
    
    var id: Int
    var displayTitle: String
    var isEnable: Bool
    
    static func defaultState() -> CellState {
      return .init(id: -1, displayTitle: "?", isEnable: false)
    }
  }
  
  struct ListState: KnotState {
    
    var displayNavigationBarTitle: String
    var changeSet: [Change<CellState>] = []
    var items: [CellState] = []
    
    static func defaultState() -> ListState {
      
      return .init(
        displayNavigationBarTitle: "Setting",
        changeSet: [],
        items: []
      )
    }
  }
  
}

extension SettingViewModel.CellState: DiffAware {
  
  typealias DiffId = Int
  
  var diffId: Int {
    return id
  }
  
  static func compareContent(_ a: SettingViewModel.CellState,
                             _ b: SettingViewModel.CellState) -> Bool {
    return a.diffId == b.diffId
  }
}
