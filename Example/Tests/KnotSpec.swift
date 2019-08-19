import Quick
import Nimble
import Knot
import AsyncDisplayKit
import RxTest

class KnotSpec: QuickSpec {
  
  override func spec() {
    
    var node: TestNode!
    
    beforeEach {
      node = TestNode.init()
    }
    
    describe("sink") {
      
      context("update layout with sink") {
        
        it("should be relayout with defaultState") {
          let layoutSpec = node.layoutSpecThatFits(ASSizeRangeUnconstrained)
          
          expect(layoutSpec.children?.contains(where: { $0 === node.titleNode })) == true
          expect(layoutSpec.children?.contains(where: { $0 === node.descNode })) == true
        }
        
        it("should be relayout with updated state") {
          node.sink(.init(title: "-", desc: "??", isDisplayDescNode: false))
          let layoutSpec = node.layoutSpecThatFits(ASSizeRangeUnconstrained)
          
          expect(layoutSpec.children?.contains(where: { $0 === node.titleNode })) == true
          expect(layoutSpec.children?.contains(where: { $0 === node.descNode })) == false
        }
      }
      
      context("update state with sink") {
        
        it("initial state should be defaultState") {
          expect(node.state?.title) == "-"
          expect(node.state?.desc) == "-"
          expect(node.state?.isDisplayDescNode) == true
        }
        
        it("should be set state as sink") {
          node.sink(.init(title: "newTitle", desc: "newDesc", isDisplayDescNode: true))
          
          expect(node.state?.title) == "newTitle"
          expect(node.state?.desc) == "newDesc"
          expect(node.state?.isDisplayDescNode) == true
        }
        
        it("should be set defualt state as sink") {
          node.sink(.init(title: "newTitle", desc: "newDesc", isDisplayDescNode: true))
          
          expect(node.state?.title) == "newTitle"
          expect(node.state?.desc) == "newDesc"
          expect(node.state?.isDisplayDescNode) == true
          
          node.sink(TestNode.State.defaultState())
          
          expect(node.state?.title) == "-"
          expect(node.state?.desc) == "-"
          expect(node.state?.isDisplayDescNode) == true
        }
      }
    }
    
    describe("stream") {
      
      var scheduler: TestScheduler!
      
      beforeEach {
        scheduler = TestScheduler.init(initialClock: 0)
      }
      
      context("update state with stream") {
        
        it("should be emit updated state") {
          let inputStream = scheduler.createColdObservable(
            [.next(100, TestNode.State.init(title: "1", desc: "1", isDisplayDescNode: true)),
             .next(200, TestNode.State.init(title: "2", desc: "2", isDisplayDescNode: true))])
          
          let output = scheduler.createObserver(TestNode.State.self)
          
          inputStream.bind(to: node.stream).disposed(by: node.disposeBag)
          node.stateObservable.bind(to: output).disposed(by: node.disposeBag)
          
          scheduler.start()
          
          expect(output.events) == [
            .next(0, TestNode.State.init(title: "-", desc: "-", isDisplayDescNode: true)),
            .next(100, TestNode.State.init(title: "1", desc: "1", isDisplayDescNode: true)),
            .next(200, TestNode.State.init(title: "2", desc: "2", isDisplayDescNode: true))
          ]
        }
      }
    }
  }
  
  final class TestNode: ASDisplayNode, Knotable {
    
    let titleNode = ASTextNode()
    let descNode = ASTextNode()
    
    struct State: KnotState, Equatable {
      
      var title: String
      var desc: String
      var isDisplayDescNode: Bool
      
      static func defaultState() -> KnotSpec.TestNode.State {
        return .init(title: "-", desc: "-", isDisplayDescNode: true)
      }
      
      static func == (_ lhs: State, _ rhs: State) -> Bool {
        return lhs.title == rhs.title
        && lhs.desc == rhs.desc
        && lhs.isDisplayDescNode == rhs.isDisplayDescNode
      }
    }
    
    override init() {
      super.init()
      automaticallyManagesSubnodes = true
    }
    
    func update(_ state: KnotSpec.TestNode.State) {
      titleNode.update({
        $0.attributedText = NSAttributedString.init(string: state.title)
      })
      
      descNode.update({
        $0.attributedText = NSAttributedString.init(string: state.desc)
      })
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
      guard let state = self.state else { return ASLayoutSpec() }
      return ASAbsoluteLayoutSpec.init(children: [titleNode, state.isDisplayDescNode ? descNode : nil].compactMap({ $0 }))
    }
  }
}
