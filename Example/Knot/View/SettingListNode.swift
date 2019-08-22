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
import DeepDiff

class SettingListNode: ASDisplayNode & Knotable {
  
  struct State: KnotState {
    
    var displayNavigationBarTitle: String
    
    var changeSet: [Change<SettingCellNode.State>] = []
    var items: [SettingCellNode.State] = []
    
    static func defaultState() -> State {
      
      return .init(
        displayNavigationBarTitle: "Setting",
        changeSet: [],
        items: []
      )
    }
  }
  
  public let tableNode: ASTableNode = .init()
  public weak var presenter: SettingPresenter?
  private var batchContext: ASBatchContext?
  
  override init() {
    super.init()
    self.backgroundColor = .white
    self.automaticallyManagesSubnodes = true
    self.automaticallyRelayoutOnSafeAreaChanges = true
    self.tableNode.dataSource = self
  }
  
  func update(_ state: State) {
    
    print("DEBUG* 1: \(state.items.count) \(state.changeSet.count)")
    
    self.tableNode.reload(changes: state.changeSet, completion: { [weak self] in
      self?.batchContext?.completeBatchFetching($0)
    })
  
    self.closestViewController?.title = state.displayNavigationBarTitle
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
    print("DEBUG* 2: \(state?.items.count)")
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
