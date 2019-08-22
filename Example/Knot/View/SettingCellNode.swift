//
//  SettingCellNode.swift
//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import AsyncDisplayKit
import Knot
import BonMot
import RxCocoa_Texture

class SettingCellNode: ASCellNode & Knotable {
  
  typealias State = SettingViewModel.CellState
  
  private enum Const {
    
    static let titleStyle: StringStyle = .init(
      .font(UIFont.boldSystemFont(ofSize: 15.0)),
      .color(.darkGray)
    )
  }
  
  let titleNode: ASTextNode = {
    let node = ASTextNode.init()
    node.maximumNumberOfLines = 1
    return node
  }()
  
  let buttonNode: ASButtonNode = {
    let node = ASButtonNode.init()
    node.cornerRadius = 5.0
    node.borderWidth = 1.0
    node.borderColor = UIColor.blue.cgColor
    node.setTitle("Enable", with: .boldSystemFont(ofSize: 15.0), with: .blue, for: .normal)
    node.setTitle("Disable", with: .boldSystemFont(ofSize: 15.0), with: .white, for: .selected)
    node.setBackgroundImage(UIImage.init(color: .white), for: .normal)
    node.setBackgroundImage(UIImage.init(color: .blue), for: .selected)
    node.style.width = ASDimension.init(unit: .points, value: 80.0)
    node.clipsToBounds = true
    node.contentEdgeInsets = .init(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    return node
  }()
  
  override init() {
    super.init()
    self.automaticallyManagesSubnodes = true
    self.backgroundColor = .white
    self.selectionStyle = .none
  }
  
  func update(_ state: State) {
    
    titleNode.update({
      $0.attributedText = state.displayTitle.styled(with: Const.titleStyle)
    })
    buttonNode.isSelected = state.isEnable
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    titleNode.style.flexShrink = 1.0
    
    let stackLayout = ASStackLayoutSpec.init(
      direction: .horizontal,
      spacing: 5.0,
      justifyContent: .spaceBetween,
      alignItems: .center,
      children: [titleNode, buttonNode]
    )
    
    return ASInsetLayoutSpec.init(
      insets: .init(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0),
      child: stackLayout
    )
  }
}
