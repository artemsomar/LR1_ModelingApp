import Foundation

// Функція, яка шукає точку пересічення двох прямих
func solveLinearEquations(firstEquation: [Double], secondEquation: [Double]) -> (Double, Double) {
    
    var firstEquationCopy = firstEquation, secondEquationCopy = secondEquation
    
    // Перевірка, щоб ми не ділили на нуль
    if secondEquationCopy[1] == 0 {
        (firstEquationCopy, secondEquationCopy) = (secondEquationCopy, firstEquationCopy)
    }
    
    let a1 = firstEquationCopy[0], b1 = firstEquationCopy[1], c1 = firstEquationCopy[2]
    let a2 = secondEquationCopy[0], b2 = secondEquationCopy[1], c2 = secondEquationCopy[2]
    
    let x1: Double = (c1 - b1/b2 * c2 )/(a1 - b1/b2 * a2)
    let x2: Double = (c2 - a2 * x1)/b2
    
    return (x1, x2)
}

// Функція, яка шукає всі точки пересічення прямих обмеження
func findAllPoints(allEquation: [[Double]]) -> [(Double, Double)] {
    
    var allPoints: [(Double, Double)] = []
    
    for i in 0..<allEquation.count {
        for j in i+1..<allEquation.count {
            let point = solveLinearEquations(firstEquation: allEquation[i], secondEquation: allEquation[j])
            if !point.0.isNaN && !point.1.isNaN {
                allPoints.append(point)
            }
        }
    }
    
    return allPoints
}

// Функція, яка перевіряє точки на попадання в область значень
func searchRequiredPoint(allSigns: [String], allEquation: [[String]]) -> [(CGFloat, CGFloat)] {
    
    //Створення копії масиву зі всіма коефіцієнтами, значення якого будуть не String, а Double
    var allEquationCopy: [[Double]] = []
    for elem in allEquation {
        var tempArray: [Double] = []
        for arrayElem in elem {
            if let doubleArrayElem = Double(arrayElem) {
                tempArray.append(doubleArrayElem)
            }
        }
        if tempArray.count == 3 {
            allEquationCopy.append(tempArray)
        }
    }
    
    let allPoints: [(Double, Double)] = findAllPoints(allEquation: allEquationCopy)
    var requiredPoints: [(CGFloat, CGFloat)] = []
    var pointCopy: (CGFloat, CGFloat)
    
    for i in 0..<allPoints.count {
        var check = 0
        let x1 = allPoints[i].0, x2 = allPoints[i].1
        for j in 0..<allEquationCopy.count {
            let a = allEquationCopy[j][0], b = allEquationCopy[j][1], c = allEquationCopy[j][2]
            if (a*x1 + b*x2 <= c && allSigns[j] == "<=") || (a*x1 + b*x2 >= c && allSigns[j] == ">=") {
                check += 1
            }
        }
        if check == allEquation.count /*&& !requiredPoints.contains(where: { $0 == allPoints[i] })*/ {
            pointCopy.0 = CGFloat(allPoints[i].0)
            pointCopy.1 = CGFloat(allPoints[i].1)
            requiredPoints.append(pointCopy)
        }
    }
    
    return requiredPoints
}

// Функція, яка шукає мінімальне та максимальне значення функції та точки, в яких функція ці значення набуває
func searchFunctionMaxAndMin(allEquation: [[String]], allSigns: [String], function: (String, String)) -> ([Double], [Double]) {
    
    //Створення копії кортежа з коефіцієнтами функції, де замість String коефіцієнти будуть Double
    var functionCopy : (Double, Double) = (0, 0)
    if let functionCopyFirst = Double(function.0) {
        functionCopy.0 = functionCopyFirst
    }
    if let functionCopySecond = Double(function.1) {
        functionCopy.1 = functionCopySecond
    }
    
    let requiredPoints = searchRequiredPoint(allSigns: allSigns, allEquation: allEquation)
    var min = [Double.infinity, 0, 0], max = [-Double.infinity, 0, 0]
    
    for elem in requiredPoints {
        let x1 = elem.0, x2 = elem.1
        let functionValue = x1*functionCopy.0 + x2*functionCopy.1
        if functionValue < min[0] {
            min = [functionValue, x1, x2]
        }
        if functionValue > max[0] {
            max = [functionValue, x1, x2]
        }
    }
    
    return (min, max)
}
