
import Foundation

struct Point {
    var x1: CGFloat
    var x2: CGFloat
    
    init(x1: CGFloat, x2: CGFloat) {
        self.x1 = x1
        self.x2 = x2
    }
}

struct Straight {
    var a: Double
    var b: Double
    var c: Double
}

struct FunctionValue {
    var value: Double
    var point: Point
    
    init(value: Double, point: Point) {
        self.value = value
        self.point = point
    }
}
