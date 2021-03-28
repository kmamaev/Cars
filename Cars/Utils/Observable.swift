import Foundation

protocol Observable: AnyObject {
    associatedtype Observer
    
    func addObserver(_ observer: Observer)
    func removeObserver(_ observer: Observer)
}

private var associatedObjectHandle: UInt8 = 0

extension Observable {
    var observers: [Observer] { (_observers as! [WeakBox<AnyObject>]).compactMap({ $0.unbox as? Observer }) }
    private var _observers: [AnyObject] {
        get {
            return objc_getAssociatedObject(self, &associatedObjectHandle) as? [AnyObject] ?? []
        }
        set {
            objc_setAssociatedObject(self, &associatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addObserver(_ observer: Observer) {
        cleanUp()
        _observers.append(WeakBox<AnyObject>(observer as AnyObject))
        _observers = _observers.filter({ ($0 as! WeakBox<AnyObject>).unbox != nil })
    }
    
    func removeObserver(_ observer: Observer) {
        cleanUp()
        _observers = _observers.filter({ ($0 as! WeakBox<AnyObject>).unbox !== (observer as AnyObject) })
    }
    
    func notifyObservers(_ event: @escaping (Observer) -> ()) {
        observers.forEach({ event($0) })
    }
    
    private func cleanUp() {
        _observers = _observers.filter({ ($0 as! WeakBox<AnyObject>).unbox != nil })
    }
}

final class WeakBox<A: AnyObject> {
    weak var unbox: A?
    init(_ value: A) {
        unbox = value
    }
}
