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
import RxDataSources_Texture

class SettingViewController: ASViewController<ASDisplayNode> {
  
  private let tableNode: ASTableNode = .init()
  public let bloc: SettingBloc = .init()
  public let disposeBag = DisposeBag()
  
  lazy var dataSource: RxASTableSectionedAnimatedDataSource<SettingUseCase.Section> =
    .init(configureCellBlock: { [weak self] _, _, _, item in
      guard let self = self else { return { ASCellNode() } }
      switch item {
      case .item(let state):
        
        let cellNode = SettingCellNode.init()
        cellNode.sink(state)
        
        self.bloc.updateCellState
          .filter(with: cellNode, { $0.0.id == $0.1.id })
          .pipe(to: cellNode)
          .disposed(by: cellNode.disposeBag)
        
        cellNode.buttonNode.rx.tap
          .state(from: cellNode)
          .subscribe(onNext: { [weak self] state in
            self?.bloc.updateEnableState(state.id, isEnable: !state.isEnable)
          })
          .disposed(by: cellNode.disposeBag)
        
        return { cellNode }
      }
    })
  
  init() {
    super.init(node: .init())
    self.node.backgroundColor = .white
    self.node.automaticallyManagesSubnodes = true
    self.node.automaticallyRelayoutOnSafeAreaChanges = true
    self.node.layoutSpecBlock = { [weak self] (node, _) -> ASLayoutSpec in
      guard let self = self else { return ASLayoutSpec.init() }
      var tableInsets: UIEdgeInsets = node.safeAreaInsets
      tableInsets.bottom = 0.0
      
      return ASInsetLayoutSpec.init(
        insets: tableInsets,
        child: self.tableNode
      )
    }
    
    bloc.listStateRelay
      .map({ $0.sections })
      .bind(to: tableNode.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    bloc.listStateRelay
      .map({ $0.displayNavigationBarTitle })
      .bind(to: self.rx.title)
      .disposed(by: disposeBag)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
