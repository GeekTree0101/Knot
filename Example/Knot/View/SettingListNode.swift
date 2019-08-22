//
//  SettingListNode.swift
//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa
import RxCocoa_Texture
import Knot

class SettingListNode: ASDisplayNode & Knotable {
  
  typealias State = SettingViewModel.ListState
  
  public let tableNode: ASTableNode = .init()
  public weak var presenter: SettingPresenter?
  
  override init() {
    super.init()
    self.backgroundColor = .white
    self.automaticallyManagesSubnodes = true
    self.automaticallyRelayoutOnSafeAreaChanges = true
    self.tableNode.dataSource = self
  }
  
  func update(_ state: SettingViewModel.ListState) {
    
    self.tableNode.reload(changes: state.changeSet, completion: { _ in
      
    })
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    var tableInsets: UIEdgeInsets = self.safeAreaInsets
    tableInsets.bottom = 0.0
    
    return ASInsetLayoutSpec.init(
      insets: tableInsets,
      child: self.tableNode
    )
  }
}

extension SettingListNode: ASTableDataSource {
  
  func numberOfSections(in tableNode: ASTableNode) -> Int {
    return 1
  }
  
  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return state?.items.count ?? 0
  }
  
  func tableNode(_ tableNode: ASTableNode,
                 nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    guard let items = state?.items, indexPath.row < items.count else { return { ASCellNode() } }
    
    let cellNode = SettingCellNode.init()
    cellNode.sink(items[indexPath.row])
    
    self.presenter?.updateCellState
      .filter(with: cellNode, { $0.0.id == $0.1.id })
      .pipe(to: cellNode)
      .disposed(by: cellNode.disposeBag)
    
    cellNode.buttonNode.rx.tap
      .state(from: cellNode)
      .subscribe(onNext: { [weak self] state in
        self?.presenter?.updateEnableState(state.id, isEnable: !state.isEnable)
      })
      .disposed(by: cellNode.disposeBag)
    
    return { cellNode }
  }
}
