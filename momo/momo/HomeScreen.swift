import SwiftUI
import RiveRuntime

//Displays the homescreen of our app, including animated character Momo
//Edited by Karla
struct HomeScreen: View {
    //Rive animation model for displaying our character Momo
    let characterAnimation = RiveViewModel(fileName: "character_test")
    var body: some View {
        ZStack {
            //Background UI
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.85, green: 0.80, blue: 0.95),
//                    Color(red: 0.75, green: 0.65, blue: 0.90)
                    Color(red: 0.7, green: 0.6, blue: 0.95),

                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()
                //App title
                Text("Momo Fit")
                    .font(.system(size: 42, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)

//                Image(systemName: "figure.walk")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 180, height: 180)
//                    .foregroundColor(.white)
//                    .shadow(radius: 10)
                //Sets our animated character Momo
                characterAnimation.view()
                                    .frame(width: 400, height: 400)
                                    .shadow(radius: 5)
                //App motivation
                Text("Track your fitness. Stay motivated. Connect with friends.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .font(.title3)
                    .padding(.horizontal, 40)

                Spacer()

//                Button(action: {
//                    print("Get Started tapped") // Replace with navigation logic
//                }) {
//                    Text("Get Started")
//                        .font(.title2)
//                        .fontWeight(.bold)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.white)
//                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8)) // lavender-purple
//                        .cornerRadius(20)
//                        .shadow(radius: 10)
//                        .padding(.horizontal, 40)
//                }
                .scaleEffect(1.05)
                .animation(.easeInOut(duration: 0.2), value: UUID())

                Spacer(minLength: 40)
            }
        }
    }
}

#Preview {
    HomeScreen()
}
