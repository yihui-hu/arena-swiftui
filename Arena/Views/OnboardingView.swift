//
//  OnboardingView.swift
//  Arena
//
//  Created by Yihui Hu on 29/11/23.
//

import SwiftUI
import Defaults

struct OnboardingView: View {
    @State private var accessToken: String = ""
    @State private var username: String = ""
    @State private var userId: Int = 0
    @State private var userPicURL: String = ""
    @State private var userInitials: String = ""
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
                            SecureField("Are.na Access Token", text: $accessToken)
                            TextField("Are.na Username", text: $username)
                        }
                        .focused($inputIsFocused)
                        .textFieldStyle(OnboardingInputStyle())
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .onAppear {
                            UITextField.appearance().clearButtonMode = .always
                        }
                        
                        Button(action: {
                            Defaults[.safariViewURL] = "https://github.com/yihui-hu/arena-swiftui/blob/main/GUIDE.md"
                            Defaults[.safariViewOpen] = true
                        }) {
                            Text("How to get access token & username?")
                                .foregroundStyle(Color("text-secondary"))
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                                .fontDesign(.rounded)
                        }
                    }
                }
                
                Spacer()
                
                NavigationLink(
                    destination: VerificationView(
                        accessToken: $accessToken,
                        username: $username,
                        userId: $userId,
                        userPicURL: $userPicURL,
                        userInitials: $userInitials
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
                        getUserData(username: username, accessToken: accessToken, userId: $userId, userPicURL: $userPicURL, userInitials: $userInitials, errorMessage: $error)
                    }) {
                        VStack {
                            if isLoading {
                                CircleLoadingSpinner(customColor: "spinner-blue", customBgColor: "spinner-blue-bg")
                            } else {
                                Text("Next")
                                    .fontWeight(.semibold)
                                    .fontDesign(.rounded)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 48)
                        .background(Color("blue-button"))
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
    
    func getUserData(username: String, accessToken: String, userId: Binding<Int>, userPicURL: Binding<String>, userInitials: Binding<String>, errorMessage: Binding<String>) {
        isLoading = true
        
        guard let url = URL(string: "https://api.are.na/v2/users/\(username.lowercased())/") else {
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
                    let userData = try decoder.decode(User.self, from: data)
                    DispatchQueue.main.async {
                        userId.wrappedValue = userData.id
                        userPicURL.wrappedValue = userData.avatarImage.display
                        userInitials.wrappedValue = userData.initials
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

struct VerificationView: View {
    @Binding var accessToken: String
    @Binding var username: String
    @Binding var userId: Int
    @Binding var userPicURL: String
    @Binding var userInitials: String
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                VStack(spacing: 16) {
                    ProfilePic(imageURL: userPicURL, initials: userInitials, fontSize: 40, dimension: 120, cornerRadius: 64)
                    Text("\(username)")
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                }
                
                Spacer()
                
                VStack(spacing: 20) {
                    Text("Is this you?")
                        .foregroundStyle(Color("text-secondary"))
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .fontDesign(.rounded)
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("No")
                                .frame(maxWidth: .infinity, maxHeight: 48)
                                .background(Color("surface"))
                                .foregroundColor(Color("text-primary"))
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                                .cornerRadius(16)
                        }
                        
                        NavigationLink(destination: DisclaimerView(accessToken: $accessToken, username: $username, userId: $userId)) {
                            Text("Yes!")
                                .frame(maxWidth: .infinity, maxHeight: 48)
                                .background(Color("blue-button"))
                                .foregroundColor(Color.white)
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                                .cornerRadius(16)
                        }
                    }
                }
            }
            .padding(32)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    BackButton()
                }
            }
        }
        .toolbarBackground(Color("background"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

struct DisclaimerView: View {
    @Binding var accessToken: String
    @Binding var username: String
    @Binding var userId: Int
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    Spacer()
                    
                    Text("Please note that this app is not meant to replace the existing Are.na app. Some key features currently missing include:")
                        .foregroundStyle(Color("text-primary"))
                        .fontWeight(.medium)
                        .fontDesign(.rounded)
                    
                    VStack(spacing: 12 ) {
                        HStack(alignment: .center, spacing: 16) {
                            Image(systemName: "camera.macro.circle.fill")
                                .imageScale(.medium)
                                .foregroundStyle(Color("text-secondary"))
                            
                            Text("Ability to upload photos")
                                .foregroundStyle(Color("text-primary"))
                                .fontWeight(.medium)
                                .fontDesign(.rounded)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color("surface"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        HStack(alignment: .center, spacing: 16) {
                            Image(systemName: "bell.fill")
                                .imageScale(.medium)
                                .foregroundStyle(Color("text-secondary"))
                            
                            Text("Feed and notifications")
                                .foregroundStyle(Color("text-primary"))
                                .fontWeight(.medium)
                                .fontDesign(.rounded)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color("surface"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        HStack(alignment: .top, spacing: 16) {
                            Image(systemName: "doc.fill")
                                .imageScale(.medium)
                                .foregroundStyle(Color("text-secondary"))
                            
                            Text("Viewing attachments (mp4, pdf, etc.)")
                                .foregroundStyle(Color("text-primary"))
                                .fontWeight(.medium)
                                .fontDesign(.rounded)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, maxHeight: 76, alignment: .leading)
                        .background(Color("surface"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    Text("These omissions are due to the current limitations of Are.na's API.")
                        .foregroundStyle(Color("text-primary"))
                        .fontWeight(.medium)
                        .fontDesign(.rounded)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                            
                Button(action: {
                    Defaults[.accessToken] = accessToken
                    Defaults[.username] = username
                    Defaults[.userId] = userId
                    Defaults[.onboardingDone] = true
                }) {
                    Text("I understand")
                        .frame(maxWidth: .infinity, maxHeight: 48)
                        .background(Color("blue-button"))
                        .foregroundColor(Color.white)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        .cornerRadius(16)
                }
            }
            .padding(32)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    BackButton()
                }
            }
        }
        .toolbarBackground(Color("background"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
