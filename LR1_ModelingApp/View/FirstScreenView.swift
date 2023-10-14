
import SwiftUI

struct FirstScreen: View {
    
    @Binding var showFirstScreen: Bool
    @Binding var showSecondScreen: Bool
    @Binding var constraintAmount: Int
    @Binding var allEquation: [[Double]]
    @Binding var allSigns: [String]
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
                    if constraintAmount != 0 {
                        for _ in 0..<constraintAmount {
                            let array: [Double] = [0, 0, 0]
                            allEquation.append(array)
                            allSigns.append("")
                        }
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
