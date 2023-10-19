
import SwiftUI

struct ThirdScreen: View {
    
    @Binding var showFirstScreen: Bool
    @Binding var showSecondScreen: Bool
    @Binding var constraintAmount: Int
    @Binding var allEquations: [Equation]
    @Binding var function: (Double, Double)
    
    @State var points: [Point] = []
    @State var straightPoints: [[Point]] = []
    @State var graphSize: CGFloat = 500
    @State var graphOriginCoordinates: Point = Point(x1: 0, x2: 0)
    @State var zeroCoordinates: Point = Point(x1: 0, x2: 0)
    @State var size: CGSize = .zero
    @State var coefficient: CGFloat = 0
    @State var functionMinAndMax: (FunctionValue, FunctionValue) = (FunctionValue(value: 0, x1: 0, x2: 0), FunctionValue(value: 0, x1: 0, x2: 0))
    
    let backgroundColor = #colorLiteral(red: 0.9291701913, green: 0.9728782773, blue: 0.9366860986, alpha: 0.6508174669)
    let graphLimits: (CGFloat, CGFloat) = (-2, 20)
    let topPartHeight: CGFloat = 50
    let colors = [Color.blue, Color.brown, Color.cyan, Color.green, Color.indigo, Color.mint, Color.orange, Color.pink, Color.purple, Color.red]
    
    var body: some View {
        
        ZStack {
            Color(backgroundColor)
            GeometryReader { wholeWindow in
                VStack (spacing: 0)  {
                    
                    Text("Графік функції:")
                        .frame(height: topPartHeight)
                        .font(.title)

                
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: graphSize, height: graphSize)
                        
                        //Вісь іксів (x1)
                        Group {
                            
                            Path { xAxis in
                                xAxis.move(to: CGPoint(x: graphOriginCoordinates.x1, y: zeroCoordinates.x2))
                                xAxis.addLine(to: CGPoint(x: graphOriginCoordinates.x1 + graphSize, y: zeroCoordinates.x2))
                            }
                            .stroke(Color.black, lineWidth: 3)
                            
                            Path { xAxisAdd in
                                xAxisAdd.move(to: CGPoint(x: graphOriginCoordinates.x1 + graphSize, y: zeroCoordinates.x2))
                                xAxisAdd.addLine(to: CGPoint(x: graphOriginCoordinates.x1 + graphSize - 10, y: zeroCoordinates.x2 + 5))
                                
                            }
                            .stroke(Color.black, lineWidth: 2)
                            
                            Text("x1")
                                .position(x: graphOriginCoordinates.x1+graphSize + 10, y: zeroCoordinates.x2)
                            
                            ForEach(Int(graphLimits.0)..<Int(graphLimits.1)) { index in
                                Path { xAxisDiv in
                                    xAxisDiv.move(to: CGPoint(x: zeroCoordinates.x1 + CGFloat(index) * coefficient, y: zeroCoordinates.x2 - 5))
                                    xAxisDiv.addLine(to: CGPoint(x: zeroCoordinates.x1 + CGFloat(index) * coefficient, y: zeroCoordinates.x2 + 5))
                                    
                                }
                                .stroke(Color.black, lineWidth: 1.5)
                                if index % 5 == 0 && index != 0 {
                                    Text("\(index)")
                                        .font(.footnote)
                                        .position(x:zeroCoordinates.x1 + CGFloat(index) * coefficient, y:zeroCoordinates.x2 + 12)
                                }
                            }
                        }
                        
                        //Вісь ігриків (x2)
                        Group {
                            
                            Path { yAxis in
                                yAxis.move(to: CGPoint(x: zeroCoordinates.x1, y: graphOriginCoordinates.x2))
                                yAxis.addLine(to: CGPoint(x: zeroCoordinates.x1, y: graphOriginCoordinates.x2 + graphSize))
                            }
                            .stroke(Color.black, lineWidth: 3)
                            
                            Path { yAxisAdd in
                                yAxisAdd.move(to: CGPoint(x: zeroCoordinates.x1, y: graphOriginCoordinates.x2))
                                yAxisAdd.addLine(to: CGPoint(x: zeroCoordinates.x1 - 5, y: graphOriginCoordinates.x2 + 10))
                            }
                            .stroke(Color.black, lineWidth: 2)
                            
                            Text("x2")
                                .position(x: zeroCoordinates.x1, y: graphOriginCoordinates.x2 - 10)
                            
                            ForEach(Int(graphLimits.0)..<Int(graphLimits.1)) { index in
                                Path { yAxisDiv in
                                    yAxisDiv.move(to: CGPoint(x: zeroCoordinates.x1 - 5, y: zeroCoordinates.x2 - CGFloat(index)*coefficient))
                                    yAxisDiv.addLine(to: CGPoint(x: zeroCoordinates.x1 + 5, y: zeroCoordinates.x2 - CGFloat(index)*coefficient))
                                    
                                }
                                .stroke(Color.black, lineWidth: 1.5)
                                if index % 5 == 0 && index != 0 {
                                    Text("\(index)")
                                        .font(.footnote)
                                        .position(x:zeroCoordinates.x1 - 12, y:zeroCoordinates.x2 - CGFloat(index)*coefficient)
                                }
                            }
                        }
                        
                    }
                    .frame(height: graphSize)
                    .onAppear {
                        functionMinAndMax = searchFunctionMinAndMax(allEquations: allEquations, function: function)
                        points = searchRequiredPoint(allEquations: allEquations)
                        straightPoints = searchPointsForStraights(allEquations: allEquations, graphLimits: graphLimits)
                        graphSize = wholeWindow.size.height*0.7
                        graphOriginCoordinates = Point(x1: (wholeWindow.size.width - graphSize) / 2, x2: 0)
                        coefficient = graphSize / (graphLimits.1 - graphLimits.0)
                        zeroCoordinates = Point(x1: graphOriginCoordinates.x1 - graphLimits.0 * coefficient, x2: graphOriginCoordinates.x2 + graphLimits.1 * coefficient)
                        
                    }
                    .onChange(of: wholeWindow.size) { newSize in
                        graphSize = wholeWindow.size.height*0.7
                        graphOriginCoordinates = Point(x1: (wholeWindow.size.width - graphSize) / 2, x2: 0)
                        coefficient = graphSize / (graphLimits.1 - graphLimits.0)
                        zeroCoordinates = Point(x1: graphOriginCoordinates.x1 - graphLimits.0 * coefficient, x2: graphOriginCoordinates.x2 + graphLimits.1 * coefficient)
                    }
                    
                    
                    Text("Мінімальне значення функції = \(NSString(format: "%.2f",functionMinAndMax.0.value)) при x1 = \(NSString(format: "%.2f",functionMinAndMax.0.x1)), x2 = \(NSString(format: "%.2f",functionMinAndMax.0.x2))\nМаксимальне значення функції = \(NSString(format: "%.2f",functionMinAndMax.1.value)) при x1 = \(NSString(format: "%.2f",functionMinAndMax.1.x1)), x2 = \(NSString(format: "%.2f",functionMinAndMax.1.x2))")
                        .padding(20)
                    
                    Button(action: {
                        showFirstScreen.toggle()
                    }, label: {
                        Text("Ввести нове рівняння")
                            .frame(width: 300, height: 40)
                    })
                    
                }
                
                //Малювання на графіку прямих
                ForEach(0..<straightPoints.count, id: \.self) { index in
                    Path { straight in
                        straight.move(to: CGPoint(x: zeroCoordinates.x1 + straightPoints[index][0].x1*coefficient, y: zeroCoordinates.x2 - straightPoints[index][0].x2*coefficient + topPartHeight))
                        straight.addLine(to: CGPoint(x: zeroCoordinates.x1 + straightPoints[index][1].x1*coefficient, y: zeroCoordinates.x2 - straightPoints[index][1].x2*coefficient + topPartHeight))
                    }
                    .stroke(colors[index], lineWidth: 1)
                }
                
                //Малювання на графіку точок
                ForEach(0..<points.count, id: \.self) { index in
                    Circle()
                        .frame(width: 4)
                        .position(x: zeroCoordinates.x1 + points[index].x1*coefficient , y: zeroCoordinates.x2 - points[index].x2*coefficient + topPartHeight)
                }
            }
        }
    }
}
