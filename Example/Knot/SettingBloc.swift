//
//  SettingBloc.swift
//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import RxSwift
import RxCocoa
import Knot

class SettingBloc {

  public let updateCellState: PublishRelay<SettingUseCase.CellState> = .init()
  public let listStateRelay: BehaviorRelay<SettingUseCase.ListState> =
    .init(value: SettingUseCase.ListState.defaultState())
  
  public var repository: SettingRepository = .init(
    localDS: SettingLocalDataSource.init()
  )
  
  private let disposeBag = DisposeBag()
  
  init() {
    
    repository.settings
      .reduce(listStateRelay, {
        var (settings, state) = $0
        let items: [SettingUseCase.Item] = settings.map({
          .item(SettingUseCase.CellState.init(
            id: $0.id,
            displayTitle: $0.title,
            isEnable: $0.isEnable
          ))
        })
        state.sections = [.itemSection(items)]
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
