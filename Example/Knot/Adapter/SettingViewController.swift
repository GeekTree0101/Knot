//
//  SettingViewController.swift
//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import AsyncDisplayKit
import Knot
import RxCocoa
import RxSwift

class SettingViewController: ASViewController<SettingListNode> {
  
  public let presenter: SettingPresenter = .init()
  
  init() {
    super.init(node: SettingListNode.init())
    self.node.presenter = self.presenter
    
    presenter.listStateRelay
      .pipe(to: node)
      .disposed(by: self.node.disposeBag)
    
    presenter.listStateRelay
      .map({ $0.displayNavigationBarTitle })
      .bind(to: self.rx.title)
      .disposed(by: self.node.disposeBag)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
