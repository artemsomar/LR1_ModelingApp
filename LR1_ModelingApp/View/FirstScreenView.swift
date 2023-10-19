
import SwiftUI

struct FirstScreen: View {
    
    @Binding var showFirstScreen: Bool
    @Binding var showSecondScreen: Bool
    @Binding var constraintAmount: Int
    @Binding var allEquations: [Equation]
    
    @State var showAlert: Bool = false
    
    let backgroundColor = #colorLiteral(red: 0.9291701913, green: 0.9728782773, blue: 0.9366860986, alpha: 0.6508174669)
    
    var body: some View {
        ZStack {
            
            //background
            Color(backgroundColor)
            
            //foreground
            VStack(spacing: 30) {
                HStack(spacing: 20) {
                    Text("Введіть кількість лімітуючих прямих:")
                    TextField("", value: $constraintAmount, format: .number)
                        .frame(width: 40, height: 20)
                }
                
                
                Button(action: {
                    if constraintAmount > 10 || constraintAmount < 1 {
                        showAlert = true
                    } else {
                        for _ in 0..<constraintAmount {
                            let equation = Equation(a: 0, b: 0, sign: "", c: 0)
                            allEquations.append(equation)
                        }
                        showFirstScreen.toggle()
                        showSecondScreen.toggle()
                    }
                }, label: {
                    Text("Ввести")
                })
                
                if showAlert {
                    Text("Кількість рівнянь має входити в межі [1;10]")
                        .font(.title3)
                        .foregroundColor(.red)
                }
            }
            .font(.title)
        }
    }
}
