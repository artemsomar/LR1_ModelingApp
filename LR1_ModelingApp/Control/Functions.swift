
import Foundation

// Функція, яка шукає точку пересічення двох прямих
func solveLinearEquations(firstEquation: Equation, secondEquation: Equation) -> Point {
    
    var firstEquationCopy = firstEquation, secondEquationCopy = secondEquation
    var resultPoint = Point(x1: 0, x2: 0)
    
    // Перевірка, щоб ми не ділили на нуль
    if secondEquationCopy.b == 0 {
        (firstEquationCopy, secondEquationCopy) = (secondEquationCopy, firstEquationCopy)
    }
    
    let a1 = CGFloat(firstEquationCopy.a), b1 = CGFloat(firstEquationCopy.b), c1 = CGFloat(firstEquationCopy.c)
    let a2 = CGFloat(secondEquationCopy.a), b2 = CGFloat(secondEquationCopy.b), c2 = CGFloat(secondEquationCopy.c)
    
    resultPoint.x1 = (c1 - b1/b2 * c2 )/(a1 - b1/b2 * a2)
    resultPoint.x2 = (c2 - a2 * resultPoint.x1)/b2
    
    
    return resultPoint
}

// Функція, яка шукає всі точки пересічення прямих обмеження
func findAllPoints(allEquations: [Equation]) -> [Point] {
    
    var allPoints: [Point] = []
    
    for i in 0..<allEquations.count {
        for j in i+1..<allEquations.count {
            let point = solveLinearEquations(firstEquation: allEquations[i], secondEquation: allEquations[j])
            if !point.x1.isNaN && !point.x2.isNaN {
                allPoints.append(point)
            }
        }
    }
    
    return allPoints
}

// Функція, яка перевіряє точки на попадання в область значень
func searchRequiredPoint(allEquations: [Equation]) -> [Point] {
    
    let allPoints: [Point] = findAllPoints(allEquations: allEquations)
    var requiredPoints: [Point] = []
    
    for i in 0..<allPoints.count {
        var check = 0
        let x1 = allPoints[i].x1, x2 = allPoints[i].x2
        for j in 0..<allEquations.count {
            let a = allEquations[j].a, b = allEquations[j].b, c = allEquations[j].c
            if (a*x1 + b*x2 <= c && allEquations[j].sign == "<=") || (a*x1 + b*x2 >= c && allEquations[j].sign == ">=") {
                check += 1
            }
        }
        if check == allEquations.count  {
            requiredPoints.append(allPoints[i])
        }
    }
    
    return requiredPoints
}

// Функція, яка шукає мінімальне та максимальне значення функції та точки, в яких функція ці значення набуває
func searchFunctionMinAndMax(allEquations: [Equation], function: (Double, Double)) -> (FunctionValue, FunctionValue) {
    
    let requiredPoints = searchRequiredPoint(allEquations: allEquations)
    
    var min = FunctionValue(value: Double.infinity, x1: 0, x2: 0)
    var max = FunctionValue(value: -Double.infinity, x1: 0, x2: 0)
    
    for elem in requiredPoints {
        let functionValue = elem.x1*function.0 + elem.x2*function.1
        if functionValue < min.value {
            min = FunctionValue(value: functionValue, x1: elem.x1, x2: elem.x2)
        }
        if functionValue > max.value {
            max = FunctionValue(value: functionValue, x1: elem.x1, x2: elem.x2)
        }
    }
    
    return (min, max)
}

//Функція, яка шукає точки для подальшого малювання прямих
func searchPointsForStraights(allEquations: [Equation], graphLimits: (CGFloat, CGFloat)) -> [[Point]] {
    
    var equationPoints: [[Point]] = []
    var x1: CGFloat, x2: CGFloat
    
    for elem in allEquations {
        var array: [Point] = []
        
        x1 = graphLimits.0
        x2 = (elem.c - elem.a * x1)/elem.b
        if graphLimits.0 < x2 && x2 < graphLimits.1 {
            let point = Point(x1: x1, x2: x2)
            array.append(point)
        }
        
        x1 = graphLimits.1
        x2 = (elem.c - elem.a * x1)/elem.b
        if graphLimits.0 < x2 && x2 < graphLimits.1 {
            let point = Point(x1: x1, x2: x2)
            array.append(point)
        }
        
        x2 = graphLimits.0
        x1 = (elem.c - elem.b * x2)/elem.a
        if graphLimits.0 < x1 && x1 < graphLimits.1 {
            let point = Point(x1: x1, x2: x2)
            array.append(point)
        }
        
        x2 = graphLimits.1
        x1 = (elem.c - elem.b * x2)/elem.a
        if graphLimits.0 < x1 && x1 < graphLimits.1 {
            let point = Point(x1: x1, x2: x2)
            array.append(point)
        }
        equationPoints.append(array)
    }
    return equationPoints
}

