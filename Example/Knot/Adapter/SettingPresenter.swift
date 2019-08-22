//
//  SettingPresenter.swift
//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import RxSwift
import RxCocoa
import Knot
import DeepDiff

class SettingPresenter {

  public let updateCellState: PublishRelay<SettingViewModel.CellState> = .init()
  public let listStateRelay: BehaviorRelay<SettingViewModel.ListState> =
    .init(value: SettingViewModel.ListState.defaultState())
  
  public var repository: SettingRepository = .init(
    localDS: SettingLocalDataSource.init()
  )
  
  private let disposeBag = DisposeBag()
  
  init() {
    
    repository.settings
      .reduce(listStateRelay, {
        var (settings, state) = $0
        let newItems: [SettingViewModel.CellState] = settings.map({
          SettingViewModel.CellState(
            id: $0.id,
            displayTitle: $0.title,
            isEnable: $0.isEnable
          )
        })
        state.items = newItems
        state.changeSet = diff(old: state.items, new: newItems)
        return state
      })
      .bind(to: listStateRelay)
      .disposed(by: disposeBag)
  }
  
  public func updateEnableState(_ id: Int, isEnable: Bool) {
    
    guard var setting = repository.getSetting(id) else { return }
    setting.isEnable = isEnable
    updateCellState.accept(.init(
      id: setting.id,
      displayTitle: setting.title,
      isEnable: setting.isEnable
      )
    )
    repository.setSetting(setting)
  }
}
