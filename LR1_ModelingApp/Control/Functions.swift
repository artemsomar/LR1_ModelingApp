
import Foundation

// Функція, яка шукає точку пересічення двох прямих
func solveLinearEquations(firstEquation: Straight, secondEquation: Straight) -> Point {
    
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
func findAllPoints(allEquation: [Straight]) -> [Point] {
    
    var allPoints: [Point] = []
    
    for i in 0..<allEquation.count {
        for j in i+1..<allEquation.count {
            let point = solveLinearEquations(firstEquation: allEquation[i], secondEquation: allEquation[j])
            if !point.x1.isNaN && !point.x2.isNaN {
                allPoints.append(point)
            }
        }
    }
    
    return allPoints
}

// Функція, яка перевіряє точки на попадання в область значень
func searchRequiredPoint(allSigns: [String], allEquation: [Straight]) -> [Point] {
    
    let allPoints: [Point] = findAllPoints(allEquation: allEquation)
    var requiredPoints: [Point] = []
    
    for i in 0..<allPoints.count {
        var check = 0
        let x1 = allPoints[i].x1, x2 = allPoints[i].x2
        for j in 0..<allEquation.count {
            let a = allEquation[j].a, b = allEquation[j].b, c = allEquation[j].c
            if (a*x1 + b*x2 <= c && allSigns[j] == "<=") || (a*x1 + b*x2 >= c && allSigns[j] == ">=") {
                check += 1
            }
        }
        if check == allEquation.count /*&& !requiredPoints.contains(where: { $0 == allPoints[i] })*/ {
            requiredPoints.append(allPoints[i])
        }
    }
    
    return requiredPoints
}

// Функція, яка шукає мінімальне та максимальне значення функції та точки, в яких функція ці значення набуває
func searchFunctionMaxAndMin(allEquation: [Straight], allSigns: [String], function: (Double, Double)) -> (FunctionValue, FunctionValue) {
    
    let requiredPoints = searchRequiredPoint(allSigns: allSigns, allEquation: allEquation)
    
    var min = FunctionValue(value: Double.infinity, point: Point(x1: 0, x2: 0))
    var max = FunctionValue(value: -Double.infinity, point: Point(x1: 0, x2: 0))
    
    for elem in requiredPoints {
        let point = Point(x1: elem.x1, x2: elem.x2)
        let functionValue = point.x1*function.0 + point.x2*function.1
        if functionValue < min.value {
            min = FunctionValue(value: functionValue, point: point)
        }
        if functionValue > max.value {
            max = FunctionValue(value: functionValue, point: point)
        }
    }
    
    return (min, max)
}

//Потім переробити через структури
////Функція, яка шукає точки для подальшого малювання прямих
//func searchPointsForStraights(allEquation: [Straight], graphLimits: Point) -> [(Point, Point)] {
//    
//}

