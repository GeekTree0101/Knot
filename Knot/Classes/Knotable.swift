import AsyncDisplayKit
import RxSwift
import RxCocoa

public protocol KnotState {
  
  static func defaultState() -> Self
}

public protocol Knotable: class, KnotAssociatedObject {
  
  associatedtype State: KnotState
  func update(_ state: State)
}

private var knotKey: String = "knot.knotKey"
private var knotStreamKey: String = "knot.knotStreamKey"

extension Knotable {
  
  public var state: State? {
    return _knot.value
  }
  
  public func sink(_ state: State) {
    self.update(state)
    self._knot.accept(state)
  }
}

extension Knotable {
  
  private var _knot: BehaviorRelay<State> {
    get {
      return associatedObject(
        forKey: &knotKey,
        default: .init(value: State.defaultState())
      )
    }
    set {
      setAssociatedObject(newValue, forKey: &knotKey)
    }
  }
  
  internal var stateObservable: Observable<State> {
    return _knot.asObservable()
  }
}

extension Knotable where Self: ASDisplayNode {
  
  public var stream: Binder<State> {
    get {
      let binder = Binder<State>.init(self, binding: { node, state in
        
        node.update(state)
        node._knot.accept(state)
        
        if node.isNodeLoaded == true {
          node.setNeedsLayout()
        } else {
          node.layoutIfNeeded()
          node.invalidateCalculatedLayout()
        }
      })
      return associatedObject(forKey: &knotStreamKey, default: binder)
    }
    set {
      fatalError()
    }
  }
}
