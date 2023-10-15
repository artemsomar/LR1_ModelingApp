
import SwiftUI

struct ThirdScreen: View {
    
    @Binding var showFirstScreen: Bool
    @Binding var showSecondScreen: Bool
    @Binding var constraintAmount: Int
    @Binding var allEquation: [Straight]
    @Binding var allSigns: [String]
    @Binding var function: (Double, Double)
    
    let backgroundColor = #colorLiteral(red: 0.9291701913, green: 0.9728782773, blue: 0.9366860986, alpha: 0.6508174669)
    @State var points: [Point] = []
    
    @State var graphSize: CGFloat = 500
    @State var graphOriginCoordinates: Point = Point(x1: 0, x2: 0)
    @State var zeroCoordinates: Point = Point(x1: 0, x2: 0)
    @State var size: CGSize = .zero
    @State var topPartSize: CGSize = .zero
    let graphLimits: (CGFloat, CGFloat) = (-2, 20)
    
    @State var coefficient: CGFloat = 0
    
    var body: some View {
        
        ZStack {
            Color(backgroundColor)
            GeometryReader { wholeWindow in
                VStack (spacing: 0)  {
                    
                    Text("Графік функції:")
                        .font(.title)
                        .padding(.top, 30)
                        .padding(.bottom, 20)
                            
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
                        points = searchRequiredPoint(allSigns: allSigns, allEquation: allEquation)

                        graphSize = wholeWindow.size.height*0.7
                        graphOriginCoordinates = Point(x1: (wholeWindow.size.width - graphSize) / 2, x2: topPartSize.height)
                        coefficient = graphSize / (graphLimits.1 - graphLimits.0)
                        zeroCoordinates = Point(x1: graphOriginCoordinates.x1 - graphLimits.0 * coefficient, x2: graphOriginCoordinates.x2 + graphLimits.1 * coefficient)
                        
                    }
                    .onChange(of: wholeWindow.size) { newSize in
                        graphSize = wholeWindow.size.height*0.7
                        graphOriginCoordinates = Point(x1: (wholeWindow.size.width - graphSize) / 2, x2: topPartSize.height)
                        coefficient = graphSize / (graphLimits.1 - graphLimits.0)
                        zeroCoordinates = Point(x1: graphOriginCoordinates.x1 - graphLimits.0 * coefficient, x2: graphOriginCoordinates.x2 + graphLimits.1 * coefficient)
                    }
                    
                    
                    Text("Максимальне значення функції = 2300 при x1 = 9, x2 = 1\nМінімальне значення функції = 1550 при x1 = 1, x2 = 4")
                        .padding(20)
                    
                    Button(action: {
                        showFirstScreen.toggle()
                    }, label: {
                        Text("Ввести нове рівняння")
                            .frame(width: 300, height: 40)
                            
                    })
                    
                    Spacer()
                    
                }
                
                //Малювання на графіку точок
                ForEach(0..<points.count, id: \.self) { index in
                    Circle()
                        .frame(width: 5)
                        .position(x: zeroCoordinates.x1 + points[index].x1*coefficient, y: zeroCoordinates.x2 - points[index].x2*coefficient)
                }
                
                //Малювання на графіку прямих
                
            }
        }
    }
}
