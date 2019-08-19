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
