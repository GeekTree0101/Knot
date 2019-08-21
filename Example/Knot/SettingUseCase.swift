//
//  SettingUseCase.swift
//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import Foundation
import RxDataSources_Texture
import Knot

enum SettingUseCase {
  
  enum Section {
    case itemSection([Item])
  }
  
  enum Item {
    case item(CellState)
  }
  
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
    var sections: [SettingUseCase.Section]
    
    static func defaultState() -> ListState {
      return .init(displayNavigationBarTitle: "Setting", sections: [])
    }
  }
  
}

extension SettingUseCase.Section: AnimatableSectionModelType {
  
  typealias Identity = String
  
  var identity: String {
    switch self {
    case .itemSection: return "itemSection"
    }
  }
  
  var items: [SettingUseCase.Item] {
    switch self {
    case .itemSection(let items): return items
    }
  }
  
  init(original: SettingUseCase.Section, items: [SettingUseCase.Item]) {
    switch original {
    case .itemSection: self = .itemSection(items)
    }
  }
}

extension SettingUseCase.Item: IdentifiableType {
  
  typealias Identity = Int
  
  var identity: Int {
    switch self {
    case .item(let setting):
      return setting.id
    }
  }
}

extension SettingUseCase.Item: Equatable {
  static func == (lhs: SettingUseCase.Item, rhs: SettingUseCase.Item) -> Bool {
    return lhs.identity == rhs.identity
  }
}
