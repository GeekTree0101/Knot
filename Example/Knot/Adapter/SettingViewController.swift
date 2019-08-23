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
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
