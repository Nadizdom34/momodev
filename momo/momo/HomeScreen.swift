import SwiftUI
import RiveRuntime
import FirebaseFirestore
import FirebaseAuth
import Firebase
import Foundation

//Displays the homescreen of our app, including animated character Momo
//Edited by Karla


    

struct HomeScreen: View {
    //Rive animation model for displaying our character Momo
    let characterAnimation = RiveViewModel(fileName: "character_test")
    @StateObject private var viewModel = LeaderboardViewModel()
    //For the timer
    @ObservedObject var stopWatch = Stop_Watch()
    
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        let minutes = String(format: "%02d", stopWatch.counter / 60)
        let seconds = String(format: "%02d", stopWatch.counter % 60)
        let union = minutes + " : " + seconds
        
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
                
                //Sets our animated character Momo
                characterAnimation.view()
                    .frame(width: 400, height: 400)
                    .shadow(radius: 5)
                //App motivation
                Text("Stay motivated. Connect with friends.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .font(.title3)
                    .padding(.horizontal, 40)
                
                Spacer()
                //Timer
                VStack(spacing: 16){
                    Text("\(union)")
                        .foregroundStyle(.purple)
                        .font(.custom("", size: 80))
                    
                    HStack(spacing: 15) {
                        Button(action: { self.stopWatch.start() }) {
                            Text("Start")
                                .font(.subheadline)
                                .padding()
                                .frame(width: 100)
                                .background(Color(red: 0.7, green: 1.0, blue: 0.7)) // pastel green
                                .foregroundColor(.black)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                        }
                        
                        Button(action: { self.stopWatch.stop() }) {
                            Text("Stop")
                                .font(.subheadline)
                                .padding()
                                .frame(width: 100)
                                .background(Color(red: 1.0, green: 0.7, blue: 0.7)) // pastel red/pink
                                .foregroundColor(.black)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                        }
                        
                        Button(action: { self.stopWatch.reset() }) {
                            Text("Reset")
                                .font(.subheadline)
                                .padding()
                                .frame(width: 100)
                                .background(Color(red: 1.0, green: 1.0, blue: 0.7)) // pastel yellow
                                .foregroundColor(.black)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                        }
                    }

                }
                .padding()
                .background(Color.white.opacity(0.15))
                .cornerRadius(20)
                .padding(.horizontal,30)
                
                Spacer(minLength:70)
            }
        }
    }
}
//Creating the stopwatch
class Stop_Watch: ObservableObject {
    
    @Published var counter: Int = 0
    var timer = Timer()
    
    func start() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0,
                                                   repeats: true) { _ in
            self.counter += 1
        }
    }
    func stop() {
        self.timer.invalidate()
    }
    func reset() {
        self.counter = 0
        self.timer.invalidate()
    }
}
#Preview {
    HomeScreen()
}
