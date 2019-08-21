//
//  SettingRepository.swift
//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import RxSwift
import RxCocoa

class SettingRepository {
  
  private let localDS: SettingLocalDataSourceProtocol
  
  init(localDS: SettingLocalDataSourceProtocol) {
    self.localDS = localDS
    
  }
  
  public var settings: Observable<[Setting]> {
    return localDS.settings.asObservable()
  }
  
  public func setSetting(_ setting: Setting) {
    localDS.setSetting(setting)
  }
  
  public func getSetting(_ id: Int) -> Setting? {
    return localDS.getSetting(id)
  }
}
