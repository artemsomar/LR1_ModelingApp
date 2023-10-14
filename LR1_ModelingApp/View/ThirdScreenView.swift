
import SwiftUI

struct ThirdScreen: View {
    
    @Binding var showFirstScreen: Bool
    @Binding var showSecondScreen: Bool
    @Binding var constraintAmount: Int
    @Binding var allEquation: [[Double]]
    @Binding var allSigns: [String]
    @Binding var function: (Double, Double)
    
    let backgroundColor = #colorLiteral(red: 0.9291701913, green: 0.9728782773, blue: 0.9366860986, alpha: 0.6508174669)
    @State var points: [(CGFloat, CGFloat)] = []
    
    @State var graphSize: CGFloat = 500
    @State var graphOriginCoordinates: (CGFloat, CGFloat) = (0, 0)
    @State var zeroCoordinates: (CGFloat, CGFloat) = (0, 0)
    @State var size: CGSize = .zero
    @State var topPartSize: CGSize = .zero
    let axisLimits: (CGFloat, CGFloat) = (-2, 20)
    
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
                                xAxis.move(to: CGPoint(x: graphOriginCoordinates.0, y: zeroCoordinates.1))
                                xAxis.addLine(to: CGPoint(x: graphOriginCoordinates.0 + graphSize, y: zeroCoordinates.1))
                            }
                            .stroke(Color.black, lineWidth: 3)
                            
                            Path { xAxisAdd in
                                xAxisAdd.move(to: CGPoint(x: graphOriginCoordinates.0 + graphSize, y: zeroCoordinates.1))
                                xAxisAdd.addLine(to: CGPoint(x: graphOriginCoordinates.0 + graphSize - 10, y: zeroCoordinates.1 + 5))
                                
                            }
                            .stroke(Color.black, lineWidth: 2)
                            
                            Text("x1")
                                .position(x: graphOriginCoordinates.0+graphSize + 10, y: zeroCoordinates.1)
                            
                            ForEach(Int(axisLimits.0)..<Int(axisLimits.1)) { index in
                                Path { xAxisDiv in
                                    xAxisDiv.move(to: CGPoint(x: zeroCoordinates.0 + CGFloat(index) * coefficient, y: zeroCoordinates.1 - 5))
                                    xAxisDiv.addLine(to: CGPoint(x: zeroCoordinates.0 + CGFloat(index) * coefficient, y: zeroCoordinates.1 + 5))
                                    
                                }
                                .stroke(Color.black, lineWidth: 1.5)
                                if index % 5 == 0 && index != 0 {
                                    Text("\(index)")
                                        .font(.footnote)
                                        .position(x:zeroCoordinates.0 + CGFloat(index) * coefficient, y:zeroCoordinates.1 + 12)
                                }
                            }
                        }
                        
                        //Вісь ігриків (x2)
                        Group {
                            
                            Path { yAxis in
                                yAxis.move(to: CGPoint(x: zeroCoordinates.0, y: graphOriginCoordinates.1))
                                yAxis.addLine(to: CGPoint(x: zeroCoordinates.0, y: graphOriginCoordinates.1 + graphSize))
                            }
                            .stroke(Color.black, lineWidth: 3)
                            
                            Path { yAxisAdd in
                                yAxisAdd.move(to: CGPoint(x: zeroCoordinates.0, y: graphOriginCoordinates.1))
                                yAxisAdd.addLine(to: CGPoint(x: zeroCoordinates.0 - 5, y: graphOriginCoordinates.1 + 10))
                            }
                            .stroke(Color.black, lineWidth: 2)
                            
                            Text("x2")
                                .position(x: zeroCoordinates.0, y: graphOriginCoordinates.1 - 10)
                            
                            ForEach(Int(axisLimits.0)..<Int(axisLimits.1)) { index in
                                Path { yAxisDiv in
                                    yAxisDiv.move(to: CGPoint(x: zeroCoordinates.0 - 5, y: zeroCoordinates.1 - CGFloat(index)*coefficient))
                                    yAxisDiv.addLine(to: CGPoint(x: zeroCoordinates.0 + 5, y: zeroCoordinates.1 - CGFloat(index)*coefficient))
                                    
                                }
                                .stroke(Color.black, lineWidth: 1.5)
                                if index % 5 == 0 && index != 0 {
                                    Text("\(index)")
                                        .font(.footnote)
                                        .position(x:zeroCoordinates.0 - 12, y:zeroCoordinates.1 - CGFloat(index)*coefficient)
                                }
                            }
                        }
                        
                    }
                    .frame(height: graphSize)
                    .onAppear {
                        points = searchRequiredPoint(allSigns: allSigns, allEquation: allEquation)

                        graphSize = wholeWindow.size.height*0.7
                        graphOriginCoordinates = ((wholeWindow.size.width - graphSize) / 2, topPartSize.height)
                        coefficient = graphSize / (axisLimits.1 - axisLimits.0)
                        zeroCoordinates = (graphOriginCoordinates.0 - axisLimits.0 * coefficient,graphOriginCoordinates.1 + axisLimits.1 * coefficient)
                        
                    }
                    .onChange(of: wholeWindow.size) { newSize in
                        graphSize = wholeWindow.size.height*0.7
                        graphOriginCoordinates = ((wholeWindow.size.width - graphSize) / 2, topPartSize.height)
                        coefficient = graphSize / (axisLimits.1 - axisLimits.0)
                        zeroCoordinates = (graphOriginCoordinates.0 - axisLimits.0 * coefficient,graphOriginCoordinates.1 + axisLimits.1 * coefficient)
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
            
                ForEach(0..<points.count, id: \.self) { index in
                    Circle()
                        .frame(width: 5)
                        .position(x: zeroCoordinates.0 + points[index].0*coefficient, y: zeroCoordinates.1 - points[index].1*coefficient)
                }
            }
        }
    }
}
