import SwiftUI
import FirebaseAuth

struct PhoneLoginView: View {
    @State private var phoneNumber = ""
    @State private var verificationCode = ""
    @State private var isVerifying = false
    @State private var verificationID: String?
    
    var onLoginSuccess: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            if !isVerifying {
                TextField("Enter phone number", text: $phoneNumber)
                    .keyboardType(.phonePad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Send Code") {
                    Auth.auth().settings?.isAppVerificationDisabledForTesting = true
                    PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { id, error in
                        if let error = error {
                            print("Error sending code: \(error.localizedDescription)")
                            return
                        }
                        verificationID = id
                        UserDefaults.standard.set(id, forKey: "authVerificationID")
                        isVerifying = true
                    }
                }
                .padding()
            } else {
                TextField("Enter verification code", text: $verificationCode)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Verify & Continue") {
                    guard let id = verificationID ?? UserDefaults.standard.string(forKey: "authVerificationID") else {
                        print("Missing verification ID")
                        return
                    }

                    let credential = PhoneAuthProvider.provider().credential(
                        withVerificationID: id,
                        verificationCode: verificationCode
                    )

                    Auth.auth().signIn(with: credential) { result, error in
                        if let error = error {
                            print("Sign-in error: \(error.localizedDescription)")
                        } else {
                            onLoginSuccess()
                        }
                    }
                }
                .padding()
            }
        }
        .padding()
    }
}

