//
//  ViewController.swift
//  Knot
//
//  Created by Geektree0101 on 08/16/2019.
//  Copyright (c) 2019 Geektree0101. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa
import BonMot
import Knot

final class ViewController: ASViewController<ASDisplayNode> {
  
  let testNode = Node.init()
  
  let disposeBag = DisposeBag()
  
  init() {
    super.init(node: .init())
    self.title = "Knot"
    self.node.backgroundColor = .white
    self.node.automaticallyManagesSubnodes = true
    self.node.layoutSpecBlock = { [weak self] (_, _) -> ASLayoutSpec in
      guard let self = self else { return ASLayoutSpec() }
      return ASCenterLayoutSpec.init(
        centeringOptions: .XY,
        sizingOptions: [],
        child: self.testNode
      )
    }
    
    Observable<Int>
      .interval(DispatchTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
      .delaySubscription(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
      .pipe(to: testNode, {
        var (integer, state) = $0
        state.title = "\(integer)"
        return state
      })
      .disposed(by: disposeBag)
    
    Observable<Int>
      .interval(DispatchTimeInterval.milliseconds(10), scheduler: MainScheduler.instance)
      .delaySubscription(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
      .filter(with: testNode, {
        return $0.0 < 100
      })
      .pipe(to: testNode, {
        var (integer, state) = $0
        state.subTitle = "\(integer)"
        return state
      })
      .disposed(by: disposeBag)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


class Node: ASDisplayNode & Knotable {
  
  struct State: KnotState {
    
    var title: String
    var subTitle: String
    
    static func defaultState() -> State {
      return .init(title: "-", subTitle: "-")
    }
  }
  
  private enum Const {
    static let titleStyle: StringStyle = .init(.font(UIFont.boldSystemFont(ofSize: 30.0)), .color(.gray))
    static let subTitleStyle: StringStyle = .init(.font(UIFont.boldSystemFont(ofSize: 20.0)), .color(.lightGray))
  }
  
  let titleNode = ASTextNode.init()
  let subTitleNode = ASTextNode.init()
  
  override init() {
    super.init()
    automaticallyManagesSubnodes = true
  }
  
  public func update(_ state: State) {
    
    titleNode.update({
      $0.attributedText = state.title.styled(with: Const.titleStyle)
    })
    
    subTitleNode.update({
      $0.attributedText = state.subTitle.styled(with: Const.subTitleStyle)
    })
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    
    let stackLayout = ASStackLayoutSpec.init(
      direction: .vertical,
      spacing: 20.0,
      justifyContent: .center,
      alignItems: .center,
      children: [
        titleNode,
        subTitleNode
      ]
    )
    
    return ASInsetLayoutSpec.init(
      insets: .zero,
      child: stackLayout
    )
  }
}
