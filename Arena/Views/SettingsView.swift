//
//  SettingsView.swift
//  Arena
//
//  Created by Yihui Hu on 1/12/23.
//

import SwiftUI
import Defaults
import BetterSafariView

struct MenuItem: View {
    @State var iconName: String
    @State var text: String
    @State var arrowName: String
    
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .foregroundStyle(Color("surface-text-secondary"))
                    .fontWeight(.semibold)
                    .frame(width: 28, height: 28)
                Text("\(text)")
                    .foregroundStyle(Color.primary)
                    .fontWeight(.medium)
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
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(selectedAppearance == appearance ? "text-primary" : "tab-unselected"))
                
                Text("\(text)")
                    .foregroundStyle(Color(selectedAppearance == appearance ? "text-primary" : "tab-unselected"))
                    .fontDesign(.rounded)
                    .fontWeight(.medium)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(selectedAppearance == appearance ? "text-primary" : "tab-unselected"), lineWidth: 2)
            )
        }
    }
}

struct SettingsView: View {
    @State private var presentingTwitter = false
    @State private var presentingPrivacyPolicy = false
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
                        
                        Button(action: {
                            MailFeedback()
                        }) {
                            MenuItem(iconName: "message.fill", text: "Send Feedback", arrowName: "arrow.up.right")
                        }
                        
                        Button(action: {
                            self.presentingTwitter = true
                        }) {
                            MenuItem(iconName: "at", text: "Follow on Twitter", arrowName: "arrow.up.right")
                        }
                        .safariView(isPresented: $presentingTwitter) {
                            SafariView(
                                url: URL(string: "https://twitter.com/_yihui")!,
                                configuration: SafariView.Configuration(
                                    entersReaderIfAvailable: false,
                                    barCollapsingEnabled: true
                                )
                            )
                            .preferredBarAccentColor(.clear)
                            .preferredControlAccentColor(.accentColor)
                            .dismissButtonStyle(.done)
                        }

                        Button(action: {
                            self.presentingPrivacyPolicy = true
                        }) {
                            MenuItem(iconName: "eyes", text: "Privacy Policy", arrowName: "arrow.up.right")
                        }
                        .safariView(isPresented: $presentingPrivacyPolicy) {
                            SafariView(
                                url: URL(string: "https://arena-ios-app.vercel.app")!,
                                configuration: SafariView.Configuration(
                                    entersReaderIfAvailable: false,
                                    barCollapsingEnabled: true
                                )
                            )
                            .preferredBarAccentColor(.clear)
                            .preferredControlAccentColor(.accentColor)
                            .dismissButtonStyle(.done)
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
                            .foregroundStyle(Color.primary)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(14)
                            .background(Color("surface"))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    
                    Spacer()
                    
                    Text("Are.na (0.0.1)")
                        .font(.system(size: 14))
                        .foregroundStyle(Color("surface-tertiary"))
                        .fontWeight(.semibold)
                }
            }
        }
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
