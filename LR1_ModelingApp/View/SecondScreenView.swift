
import SwiftUI

struct SecondScreen: View {
    
    @Binding var showFirstScreen: Bool
    @Binding var showSecondScreen: Bool
    @Binding var constraintAmount: Int
    @Binding var allEquation: [[Double]]
    @Binding var allSigns: [String]
    @Binding var function: (Double, Double)
    @State var inputDouble: Double = 0
    @State var inputString: String = ""
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
                        TextField("", value: self.$allEquation[index][0], format: .number)
                            .frame(width: 40, height: 20)
                        Text("*x1 +")
                        TextField("", value: self.$allEquation[index][1], format: .number)
                            .frame(width: 40, height: 20)
                        Text("*x2")
                        TextField("", text: $allSigns[index])
                            .frame(width: 30, height: 20)
                        TextField("", value: self.$allEquation[index][2], format: .number)
                            .frame(width: 40, height: 20)
                    }
                }
                
                HStack (spacing: 5) {
                    Text("Введіть функцію: F(x) = ")
                    TextField("", value: self.$function.0, format: .number)
                        .frame(width: 20, height: 20)
                    Text("*x1 +")
                    TextField("", value: self.$function.1, format: .number)
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
