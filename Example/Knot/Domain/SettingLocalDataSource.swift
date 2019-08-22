//
//  SettingLocalDataSource.swift
//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import RxSwift
import RxCocoa

protocol SettingLocalDataSourceProtocol {
  
  var settings: Observable<[Setting]> { get }
  func setSetting(_ setting: Setting)
  func getSetting(_ id: Int) -> Setting?
}

class SettingLocalDataSource: SettingLocalDataSourceProtocol {
  
  private var localSettings: [Setting] = [
    .init(id: 1, title: "Notification", isEnable: false),
    .init(id: 2, title: "GPS", isEnable: false),
    .init(id: 3, title: "Local Cache", isEnable: true),
    .init(id: 4, title: "Bluetooth", isEnable: false)
  ]
  private let updatedRelay: PublishRelay<[Setting]> = .init()
  
  public var settings: Observable<[Setting]> {
    return updatedRelay.startWith(localSettings)
  }
  
  public func setSetting(_ setting: Setting) {
    guard let index = localSettings.index(where: { $0.id == setting.id }) else { return }
    localSettings[index] = setting
    updatedRelay.accept(localSettings)
  }
  
  public func getSetting(_ id: Int) -> Setting? {
    guard let index = localSettings.index(where: { $0.id == id }) else { return nil }
    return localSettings[index]
  }
}
