<img src="https://github.com/GeekTree0101/Knot/blob/master/screenshot/banner.png" />

[![CI Status](https://img.shields.io/travis/Geektree0101/Knot.svg?style=flat)](https://travis-ci.org/Geektree0101/Knot)
[![Version](https://img.shields.io/cocoapods/v/Knot.svg?style=flat)](https://cocoapods.org/pods/Knot)
[![License](https://img.shields.io/cocoapods/l/Knot.svg?style=flat)](https://cocoapods.org/pods/Knot)
[![Platform](https://img.shields.io/cocoapods/p/Knot.svg?style=flat)](https://cocoapods.org/pods/Knot)

## Intro
- Lightweight & Predictable (Rx dep only)
- You can easy to separate presentation logic from business logic. 
- KnotState will make your presentation logic as reusability.
- Support a disposeBag (Just inherit knotable, you don't needs make a disposeBag property :) )
- Efficient updating node layout with state stream.

## Quick Example

> Node
```swift
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
```

> Controller
```swift

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
```

## API Guide

### Knotable
Knotable will make your node as **predictable state driven node** 

#### Knotable & KnotState
By inheriting **Knotable**, you can design as a responsive node.

> Example
```swift

class Node: ASDisplayNode & Knotable {

  let titleNode = ASTextNode()
   
  struct State: KnotState { // 1. inherit Knot State protocol
  
    var displayTitle: String
  
    static func defaultState() -> State {
      // 2. return defaultState from static defaultState method
    }
  }
  

  // 3. Use a state with updateBlock or as you know
  public func update(_ state: State) {
    
    // using updateBlock
    titleNode.update({
      $0.attributedText = NSAttributedString(string: state.displayTitle)
    })
    
    // or as you know
    titleNode.attributedText = NSAttributedString(string: state.displayTitle)
    
    // you don't needs call setNeedsLayout: :)
  }
}
```

State objects can be **separated to the outside**.
> Example
```swift
struct SomeState: KnotState {
  
    var displayTitle: String
  
    static func defaultState() -> State {
      return .init(displayTitle: "-")
    }
}

class Node: ASDisplayNode & Knotable {

  typealias State = SomeState

  let titleNode = ASTextNode()

  public func update(_ state: State) {
  
    titleNode.update({
      $0.attributedText = NSAttributedString(string: state.displayTitle)
    })
  }
}
```

#### Sink
You can set state directly as sink:
```swift
let node = KnotableNode()
node.sink(State.init(...))
```

#### Stream
You can set state from observable with stream property. In this case, you don't needs call setNeedsLayout :)
```swift
Observable.just(State.init(...)).bind(to: node.stream)
```

### ObservableType convenience extension APIs

#### pipe(to: KnotableNode)
You can reduce knotable node state with event
```swift
  Observable.just(100)
    .pipe(to: node, {
      var (event, state) = $0
      state.count = event
      return state
    })
    .disposed(by: disposeBag)
```
  
#### filter(with: KnotableNode)
You can filter event with node state
```swift
  Observable.just(100)
    .filter(with: node, { (event, state) -> Bool in
      return event == state.count
    }
    //...
 ```
 
### withState(from: KnotableNode)
You can get state with event
```swift
  Observable.just(100).withState(from: node) // 100, state
```

#### state(from: KnotableNode)
You can get state without event
```swift
  Observable.just(100).state(from: node) // state
```

> Example
```swift
let testNode = TestNode()

testNode.rx.tap
   .state(from: testNode)
   .subscribe(onNext: { state in 
     // TODO
   })
   .disposed(by: testNode.disposeBag)
```

## Requirements
- Xcode 10.x
- Swift 5.x
- RxSwift/Cocoa 5.x

## Installation

Knot is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Knot'
```

## Author

Geektree0101, h2s1880@gmail.com

## License

Knot is available under the MIT license. See the LICENSE file for more info.
