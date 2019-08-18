<img src="https://github.com/GeekTree0101/Knot/blob/master/screenshot/banner.png" />

[![CI Status](https://img.shields.io/travis/Geektree0101/Knot.svg?style=flat)](https://travis-ci.org/Geektree0101/Knot)
[![Version](https://img.shields.io/cocoapods/v/Knot.svg?style=flat)](https://cocoapods.org/pods/Knot)
[![License](https://img.shields.io/cocoapods/l/Knot.svg?style=flat)](https://cocoapods.org/pods/Knot)
[![Platform](https://img.shields.io/cocoapods/p/Knot.svg?style=flat)](https://cocoapods.org/pods/Knot)

## API Guide

### Knotable


#### Knotable & KnotState
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

#### Sink
You can set state directly
```swift
let node = KnotableNode()
node.sink(State.init(...))
```

#### Stream
You can set state from observable. In this case, you don't needs call setNeedsLayout :)
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
