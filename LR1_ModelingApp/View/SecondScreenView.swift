
import SwiftUI

struct SecondScreen: View {
    
    @Binding var showFirstScreen: Bool
    @Binding var showSecondScreen: Bool
    @Binding var constraintAmount: Int
    @Binding var allEquations: [Equation]
    @Binding var function: (Double, Double)
    
    @State var showSignAlert: Bool = false
    
    let backgroundColor = #colorLiteral(red: 0.9291701913, green: 0.9728782773, blue: 0.9366860986, alpha: 0.6508174669)
    
    var body: some View {
        
        ZStack {
            
            //background
            Color(backgroundColor)
            
            //foreground
            VStack (spacing: 20) {
                
                ForEach(0..<constraintAmount) { index in
                    HStack(spacing: 5) {
                        Text("Введіть \(index+1) рівняння: ")
                        TextField("", value: $allEquations[index].a, format: .number)
                            .frame(width: 40, height: 20)
                        Text("*x1 +")
                        TextField("", value: $allEquations[index].b, format: .number)
                            .frame(width: 40, height: 20)
                        Text("*x2")
                        TextField(">=", text: $allEquations[index].sign)
                            .frame(width: 30, height: 20)
                        TextField("", value: $allEquations[index].c, format: .number)
                            .frame(width: 40, height: 20)
                    }
                }
                
                HStack (spacing: 5) {
                    Text("Введіть функцію: F(x) = ")
                    TextField("", value: $function.0, format: .number)
                        .frame(width: 50, height: 20)
                    Text("*x1 +")
                    TextField("", value: $function.1, format: .number)
                        .frame(width: 50, height: 20)
                    Text("*x2")
                }
                .padding(.top, 30)
                
                Button("Ввести", action: {
                    for elem in allEquations {
                        if elem.sign != "<=" && elem.sign != ">=" {
                            showSignAlert = true
                            break
                        } else {
                            showSignAlert = false
                        }
                    }
                    if !showSignAlert {
                        showSecondScreen.toggle()
                    }
                })
                
                if showSignAlert {
                    Text("Знак має мати вигляд <= або >=")
                        .font(.title3)
                        .foregroundColor(.red)
                }
                
                
            }
            .font(.title2)
        }
    }
}
