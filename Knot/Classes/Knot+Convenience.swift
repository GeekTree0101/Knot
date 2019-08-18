//
//  Knot+Convenience.swift
//  Knot
//
//  Created by Hyeon su Ha on 16/08/2019.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

extension ObservableType {
  
  public func pipe<K: Knotable & ASDisplayNode>(
    to node: K,
    _ sink: @escaping ((Self.Element, K.State)) -> K.State) -> Disposable {
    
    return self.withLatestFrom(node.stateObservable) { ($0, $1) }
      .map(sink)
      .bind(to: node.stream)
  }
  
  public func filter<K: Knotable & ASDisplayNode>(
    with node: K,
    _ filterLogic: @escaping ((Self.Element, K.State)) -> Bool) -> Observable<Self.Element> {
    
    return self.withLatestFrom(node.stateObservable) { ($0, $1) }
      .filter(filterLogic)
      .map({ $0.0 })
  }
  
  public func state<K: Knotable & ASDisplayNode>(from node: K) -> Observable<K.State> {
    
    return self.withLatestFrom(node.stateObservable)
  }
  
  public func withState<K: Knotable & ASDisplayNode>(from node: K) -> Observable<(Self.Element, K.State)> {
    
    return self.withLatestFrom(node.stateObservable) { ($0, $1) }
  }
  
  public func reduce<SecondO: ObservableConvertibleType>(
    _ second: SecondO,
    _ reduceTransform: @escaping ((Self.Element, SecondO.Element)) -> SecondO.Element) -> Observable<SecondO.Element> {
    
    return self.withLatestFrom(second) { ($0, $1) }
      .map(reduceTransform)
  }
}

public protocol KnotUpdater { }

extension KnotUpdater where Self : AnyObject {
  
  public func update(_ updateBlock: (Self) throws -> Void) {
    
    do {
      try updateBlock(self)
    } catch {
      
    }
  }
}

extension ASDisplayNode : KnotUpdater { }
