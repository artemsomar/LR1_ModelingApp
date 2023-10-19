
import SwiftUI

struct ContentView: View {
    
    @State var constraintsAmount: Int = 0
    @State var allEquations: [Equation] = []
    @State var function: (Double, Double) = (0,0)

    @State var showFirstScreen: Bool = true
    @State var showSecondScreen: Bool = false
    
    let backgroundColor = #colorLiteral(red: 0.9291701913, green: 0.9728782773, blue: 0.9366860986, alpha: 0.6508174669)
    
    var body: some View {
        
        if showFirstScreen {
            FirstScreen(showFirstScreen: $showFirstScreen, showSecondScreen: $showSecondScreen, constraintAmount: $constraintsAmount, allEquations: $allEquations)
        } else if showSecondScreen {
            SecondScreen(showFirstScreen: $showFirstScreen, showSecondScreen: $showSecondScreen, constraintAmount: $constraintsAmount, allEquations: $allEquations, function: $function)
        } else {
            ThirdScreen(showFirstScreen: $showFirstScreen, showSecondScreen: $showSecondScreen, constraintAmount: $constraintsAmount, allEquations: $allEquations, function: $function)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
