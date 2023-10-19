
import Foundation

struct Point {
    var x1: CGFloat
    var x2: CGFloat
    
    init(x1: CGFloat, x2: CGFloat) {
        self.x1 = x1
        self.x2 = x2
    }
}

struct Equation {
    var a: Double
    var b: Double
    var sign: String
    var c: Double
}

struct FunctionValue {
    var value: Double
    var x1: CGFloat
    var x2: CGFloat
    
    init(value: Double, x1: CGFloat, x2: CGFloat) {
        self.value = value
        self.x1 = x1
        self.x2 = x2
    }
}
