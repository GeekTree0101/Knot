//
//  Knot+Convenience.swift
//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

extension ObservableType {
  
  /**
   Pipe(to:sink:) is bind to stream with sinked event element
   
   - Returns:
   will return Disposable, you have to set disposed(by:).
   
   - Parameters:
   - node: Knotable ASDisplayNode or subclass.
   - sink: Reduce closure.
   
   - Important:
   you have to reduce state with return new state as immutable.
   */
  public func pipe<K: Knotable & ASDisplayNode>(
    to node: K,
    _ sink: @escaping ((Self.Element, K.State)) -> K.State) -> Disposable {
    
    return self.withLatestFrom(node.stateObservable) { ($0, $1) }
      .map(sink)
      .bind(to: node.stream)
  }
  
  /**
   Filter(with:filterLogic) is filter event element with knotable node state
   
   - Returns:
   When event element is filtered by filteredLogic then return event element
   
   - Parameters:
   - node: Knotable ASDisplayNode or subclass.
   - filterLogic: filter handle logic
   
   */
  public func filter<K: Knotable & ASDisplayNode>(
    with node: K,
    _ filterLogic: @escaping ((Self.Element, K.State)) -> Bool) -> Observable<Self.Element> {
    
    return self.withLatestFrom(node.stateObservable) { ($0, $1) }
      .filter(filterLogic)
      .map({ $0.0 })
  }
  
  /**
   State(from:) is return KnotableNode State
   
   - Returns:
   Will return knotableNode state
   
   - Parameters:
   - node: Knotable ASDisplayNode or subclass.
   
   */
  public func state<K: Knotable & ASDisplayNode>(from node: K) -> Observable<K.State> {
    
    return self.withLatestFrom(node.stateObservable)
  }
  
  /**
   WithState(from:) is return KnotableNode State with event element
   
   - Returns:
   Will return knotableNode state with event element
   
   - Parameters:
   - node: Knotable ASDisplayNode or subclass.
   
   */
  public func withState<K: Knotable & ASDisplayNode>(from node: K) -> Observable<(K.State, Self.Element)> {
    
    return self.withLatestFrom(node.stateObservable) { ($1, $0) }
  }
  
  /**
   Reduce is convenience withLatestForm with mapping
   
   - Returns:
   Will return scond ObservableConvertibleType element
   
   */
  public func reduce<SecondO: ObservableConvertibleType>(
    _ second: SecondO,
    _ reduceTransform: @escaping ((Self.Element, SecondO.Element)) -> SecondO.Element) -> Observable<SecondO.Element> {
    
    return self.withLatestFrom(second) { ($0, $1) }
      .map(reduceTransform)
  }
}

extension ObservableType {
  
  /**
   Pipe(to:) is bind to stream with knotable state event element
   
   - Returns:
   will return Disposable, you have to set disposed(by:).
   
   - Parameters:
   - node: Knotable ASDisplayNode or subclass.
   
   - Important:
   Event element must be a KnotState
   */
  public func pipe<K: Knotable & ASDisplayNode>(to node: K) -> Disposable where K.State == Self.Element {
    return self.bind(to: node.stream)
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
