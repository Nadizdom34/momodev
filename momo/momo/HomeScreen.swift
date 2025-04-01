import SwiftUI

struct HomeScreen: View {
    var body: some View {
        VStack {
            Spacer()

            Text("Momo Fit")
                .font(.system(size: 40, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.pink.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .foregroundColor(.white)
                .cornerRadius(25)
                .shadow(radius: 10)

            Image(systemName: "figure.walk") // Placeholder Image
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .foregroundColor(.pink)
                .shadow(radius: 10)

            Spacer()

            Button(action: {
                print("Get Started Tapped") // Placeholder action
            }) {
                Text("Get Started")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.pink.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
            }
            .padding(.horizontal, 40)

            Spacer()
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    HomeScreen()
}

