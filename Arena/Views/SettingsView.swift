//
//  SettingsView.swift
//  Arena
//
//  Created by Yihui Hu on 1/12/23.
//

import SwiftUI
import Defaults

struct MenuItem: View {
    @State var iconName: String
    @State var text: String
    @State var arrowName: String
    
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: iconName)
                    .foregroundStyle(Color("surface-text-secondary"))
                    .fontWeight(.semibold)
                    .frame(width: 28, height: 28)
                Text("\(text)")
                    .foregroundStyle(Color("text-primary"))
                    .fontWeight(.medium)
                    .fontDesign(.rounded)
            }
            
            Spacer()
            
            Image(systemName: arrowName)
                .foregroundStyle(Color("surface-tertiary"))
                .fontWeight(.semibold)
                .frame(width: 24, height: 24)
        }
    }
}

struct ThemeButton: View {
    @Binding var selectedAppearance: Int
    @State var appearance: Int
    @State var iconName: String
    @State var text: String
    
    var body: some View {
        Button(action: {
            self.selectedAppearance = appearance
        }) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: iconName)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(selectedAppearance == appearance ? "text-primary" : "text-secondary"))
                    .opacity(selectedAppearance == appearance ? 1 : 0.4)
                
                Text("\(text)")
                    .foregroundStyle(Color(selectedAppearance == appearance ? "text-primary" : "text-secondary"))
                    .fontDesign(.rounded)
                    .fontWeight(.medium)
                    .opacity(selectedAppearance == appearance ? 1 : 0.4)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(selectedAppearance == appearance ? "text-primary" : "text-secondary"), lineWidth: 2)
                    .opacity(selectedAppearance == appearance ? 1 : 0.4)
            )
        }
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) var openURL
    @AppStorage("selectedAppearance") private var selectedAppearance = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Theme")
                                .foregroundStyle(Color("text-primary"))
                                .fontDesign(.rounded)
                                .fontWeight(.medium)
                            
                            HStack(spacing: 16) {
                                ThemeButton(selectedAppearance: $selectedAppearance, appearance: 1, iconName: "sun.max.fill", text: "Light")
                                ThemeButton(selectedAppearance: $selectedAppearance, appearance: 2, iconName: "moon.fill", text: "Dark")
                                ThemeButton(selectedAppearance: $selectedAppearance, appearance: 0, iconName: "circle.lefthalf.filled", text: "System")
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("App Icon")
                                .foregroundStyle(Color("text-primary"))
                                .fontDesign(.rounded)
                                .fontWeight(.medium)
                            
                            ChangeAppIconView()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(Color("surface"))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    
                    VStack(alignment: .leading, spacing: 16) {
                        NavigationLink(destination: ChannelView(channelSlug: "are-na-changelog")) {
                            MenuItem(iconName: "sparkle", text: "What's New", arrowName: "arrow.right")
                        }
                        
                        NavigationLink(destination: ChannelView(channelSlug: "arena-widget")) {
                            MenuItem(iconName: "square.split.bottomrightquarter.fill", text: "Add Widget", arrowName: "arrow.right")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(Color("surface"))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Button(action: {
                            MailFeedback()
                        }) {
                            MenuItem(iconName: "message.fill", text: "Send Feedback", arrowName: "arrow.up.right")
                        }
                        
                        Button(action: {
                            Defaults[.safariViewURL] = "https://twitter.com/_yihui"
                            Defaults[.safariViewOpen] = true
                        }) {
                            MenuItem(iconName: "at", text: "Follow on Twitter", arrowName: "arrow.up.right")
                        }
                        
                        ShareLink(item: URL(string: "https://arena-ios-app.vercel.app")!) {
                            MenuItem(iconName: "square.and.arrow.up.fill", text: "Share Are:na", arrowName: "arrow.up.right")
                        }
                        
                        Button(action: {
                            Defaults[.safariViewURL] = "https://gist.github.com/yihui-hu/96718f208b46784fe35eb9a3d274b375"
                            Defaults[.safariViewOpen] = true
                        }) {
                            MenuItem(iconName: "eyes", text: "Privacy Policy", arrowName: "arrow.up.right")
                        }
                        
                        Button(action: {
                            Defaults[.safariViewURL] = "https://ko-fi.com/yihui"
                            Defaults[.safariViewOpen] = true
                        }) {
                            MenuItem(iconName: "hands.clap.fill", text: "Leave A Tip", arrowName: "arrow.up.right")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(Color("surface"))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    
                    
                    Button(action: {
                        Defaults[.accessToken] = ""
                        Defaults[.username] = ""
                        Defaults[.onboardingDone] = false
                    }) {
                        Text("Log Out")
                            .foregroundStyle(Color("text-primary"))
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(14)
                            .background(Color("surface"))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    
                    Spacer()
                    
                    Text("Are.na (0.0.2)")
                        .font(.system(size: 14))
                        .foregroundStyle(Color("surface-tertiary"))
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
            }
            .scrollIndicators(.never)
        }
        .padding(.bottom, 4)
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
    
    private func MailFeedback() {
        let email = "yyihui.hu@gmail.com"
        let subject = "Are:na Feedback"
        let body = "Please provide your feedback here :)"
        guard let url = URL(string: "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")") else { return }
        
        openURL(url)
    }
}

#Preview {
    SettingsView()
}
