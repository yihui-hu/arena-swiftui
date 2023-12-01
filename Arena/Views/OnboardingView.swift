//
//  OnboardingView.swift
//  Arena
//
//  Created by Yihui Hu on 29/11/23.
//

import SwiftUI
import Defaults

struct OnboardingView: View {
    // TODO: Reset accessToken
    @State private var accessToken: String = "cfsNlJe3Ns9Vnj8SAKHLvDCaeh3uMm1sNwsIX6ESdeY"
    @State private var username: String = ""
    @State private var userId: Int = 0
    @State private var isLoading: Bool = false
    @State private var apiCheckPassed: Bool = false
    @State private var error: String = ""
    @FocusState private var inputIsFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Spacer()

                VStack(spacing: 40) {
                    Image(uiImage: UIImage(named: "AppIcon-Preview")!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: inputIsFocused ? 44 : 88, height: inputIsFocused ? 44 : 88)
                        .clipShape(RoundedRectangle(cornerRadius: inputIsFocused ? 12 : 24))

                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            TextField("Are.na Access Token", text: $accessToken)
                            TextField("Are.na Username", text: $username)
                        }
                        .focused($inputIsFocused)
                        .textFieldStyle(OnboardingInputStyle())
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .onAppear {
                            UITextField.appearance().clearButtonMode = .always
                        }
                        
                        Text("How do I get my access token & username?")
                            .foregroundStyle(Color("text-secondary"))
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                    }
                }

                Spacer()

                NavigationLink(
                    destination: VerificationView(
                        accessToken: $accessToken,
                        username: $username,
                        userId: $userId
                    ),
                    isActive: $apiCheckPassed
                ) {
                    EmptyView()
                }
                .hidden()

                VStack(spacing: 20) {
                    if !error.isEmpty {
                        Text("\(error)")
                            .foregroundStyle(Color.red)
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                    }
                    
                    Button(action: {
                        inputIsFocused = false
                        getUserData(username: username, accessToken: accessToken, userId: $userId, errorMessage: $error)
                    }) {
                        VStack {
                            if isLoading {
                                CircleLoadingSpinner(customColor: "spinner-blue", customBgColor: "spinner-blue-bg")
                            } else {
                                Text("Next")
                                    .fontWeight(.medium)
                                    .fontDesign(.rounded)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 48)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(16)
                    }
                    .disabled(isLoading)
                }
            }
            .animation(.easeInOut, value: UUID())
            .padding(32)
        }
    }

    func getUserData(username: String, accessToken: String, userId: Binding<Int>, errorMessage: Binding<String>) {
        isLoading = true
        
        guard let url = URL(string: "https://api.are.na/v2/users/\(username.lowercased())/channels") else {
            isLoading = false
            return
        }
    
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                errorMessage.wrappedValue = "Unable to connect to Are.na servers"
                isLoading = false
                return
            }

            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let userData = try decoder.decode(ArenaChannels.self, from: data)
                    DispatchQueue.main.async {
                        userId.wrappedValue = userData.id
                        errorMessage.wrappedValue = ""
                        isLoading = false
                        apiCheckPassed = true
                    }
                } catch let decodingError {
                    print("Decoding Error: \(decodingError)")
                    errorMessage.wrappedValue = "Either access token or username is invalid."
                    isLoading = false
                    return
                }
            }
            
            DispatchQueue.main.async {
                isLoading = false
            }
        }

        task.resume()
    }
}

struct OnboardingInputStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.leading, 20)
            .padding(.trailing, 12)
            .padding(.vertical, 12)
            .foregroundColor(Color("text-primary"))
            .background(Color("surface"))
            .cornerRadius(16)
            .fontDesign(.rounded)
            .fontWeight(.medium)
    }
}

struct VerificationView: View {
    @Binding var accessToken: String
    @Binding var username: String
    @Binding var userId: Int

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                VStack(spacing: 20) {
                    Text("Is this you?")
                        .foregroundStyle(Color("text-secondary"))
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .fontDesign(.rounded)
                    
                    Button(action: {
                        Defaults[.accessToken] = accessToken
                        Defaults[.username] = username
                        Defaults[.userId] = userId
                        Defaults[.onboardingDone] = true
                    }) {
                        Text("Yes!")
                            .frame(maxWidth: .infinity, maxHeight: 48)
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                            .cornerRadius(16)
                    }
                }
            }
            .padding(32)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
