
import Foundation

public protocol KnotAssociatedObject { }

extension KnotAssociatedObject {
  
  func associatedObject<T>(forKey key: UnsafeRawPointer) -> T? {
    
    return objc_getAssociatedObject(self, key) as? T
  }
  
  func associatedObject<T>(forKey key: UnsafeRawPointer,
                           default: @autoclosure () -> T) -> T {
    
    guard let object: T = self.associatedObject(forKey: key) else {
      
      let object = `default`()
      
      self.setAssociatedObject(
        object,
        forKey: key
      )
      
      return object
    }
    
    return object
  }
  
  func setAssociatedObject<T>(_ object: T?, forKey key: UnsafeRawPointer) {
    objc_setAssociatedObject(
      self,
      key,
      object,
      .OBJC_ASSOCIATION_RETAIN_NONATOMIC
    )
  }
}
