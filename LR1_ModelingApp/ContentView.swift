//
//  ContentView.swift
//  LR1_ModelingApp
//
//  Created by Artem Somar on 21.09.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State var constraintsAmount: String = "0"
    @State var allEquation: [[String]] = [[]]
    @State var allSigns: [String] = []
    @State var function: (String, String) = ("","")
    
    @State var showFirstScreen: Bool = true
    @State var showSecondScreen: Bool = false
    
    let backgroundColor = #colorLiteral(red: 0.9291701913, green: 0.9728782773, blue: 0.9366860986, alpha: 0.6508174669)
    
    var body: some View {
        
        if showFirstScreen {
            FirstScreen(showFirstScreen: $showFirstScreen, showSecondScreen: $showSecondScreen, constraintAmount: $constraintsAmount)
        } else if showSecondScreen {
            SecondScreen(showFirstScreen: $showFirstScreen, showSecondScreen: $showSecondScreen, constraintAmount: $constraintsAmount, allEquation: $allEquation, allSigns: $allSigns, function: $function)
        } else {
            ThirdScreen(showFirstScreen: $showFirstScreen, showSecondScreen: $showSecondScreen, allEquation: $allEquation, allSigns: $allSigns, function: $function)
        }
    }
}

struct FirstScreen: View {
    
    @Binding var showFirstScreen: Bool
    @Binding var showSecondScreen: Bool
    @Binding var constraintAmount: String
    
    let backgroundColor = #colorLiteral(red: 0.9291701913, green: 0.9728782773, blue: 0.9366860986, alpha: 0.6508174669)
    
    var body: some View {
        ZStack {
            
            //background
            Color(backgroundColor)
            
            //foreground
            VStack(spacing: 30) {
                HStack(spacing: 20) {
                    Text("Введіть кількість лімітуючих прямих:")
                    TextField("", text: $constraintAmount)
                        .frame(width: 40, height: 20)
                }
                
                Button(action: {
                    if constraintAmount != "0" {
                        showFirstScreen.toggle()
                        showSecondScreen.toggle()
                    }
                }, label: {
                    Text("Ввести")
                })
            }
            .font(.title)
        }
    }
}

struct SecondScreen: View {
    
    @Binding var showFirstScreen: Bool
    @Binding var showSecondScreen: Bool
    @Binding var constraintAmount: String
    @Binding var allEquation: [[String]]
    @Binding var allSigns: [String]
    @Binding var function: (String, String)
    
    let backgroundColor = #colorLiteral(red: 0.9291701913, green: 0.9728782773, blue: 0.9366860986, alpha: 0.6508174669)
    
    var body: some View {
        
        ZStack {
            
            //background
            Color(backgroundColor)
            
            //foreground
            VStack (spacing: 20) {
                
                ForEach(0..<Int(constraintAmount)!) { index in
                    HStack(spacing: 5) {
                        Text("Введіть \(index+1) рівняння: ")
                        TextField("", text: $allEquation[index][0])
                            .frame(width: 20, height: 20)
                        Text("*x1 +")
                        TextField("", text: $allEquation[index][1])
                            .frame(width: 20, height: 20)
                        Text("*x2")
                        TextField("", text: $allSigns[index])
                            .frame(width: 30, height: 20)
                        TextField("", text: $allEquation[index][3])
                            .frame(width: 20, height: 20)
                    }
                }
                
                HStack (spacing: 5) {
                    Text("Введіть функцію: F(x) = ")
                    TextField("", text: $function.0)
                        .frame(width: 20, height: 20)
                    Text("*x1 +")
                    TextField("", text: $function.1)
                        .frame(width: 20, height: 20)
                    Text("*x2")
                }
                .padding(.top, 30)
                
                Button("Ввести", action: {
                    showSecondScreen.toggle()
                })
            }
            .font(.title2)
        }
    }
}

struct ThirdScreen: View {
    
    @Binding var showFirstScreen: Bool
    @Binding var showSecondScreen: Bool
    @Binding var allEquation: [[String]]
    @Binding var allSigns: [String]
    @Binding var function: (String, String)
    
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
            
                ForEach(0..<points.count) { index in
                    Circle()
                        .frame(width: 5)
                        .position(x: zeroCoordinates.0 + points[index].0*coefficient, y: zeroCoordinates.1 - points[index].1*coefficient)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//        FirstScreen()
//        SecondScreen()
//        ThirdScreen()
    }
}
