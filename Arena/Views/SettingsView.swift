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
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .foregroundStyle(Color("surface-text-secondary"))
                .frame(width: 28, height: 28)
            Text("\(text)")
                .fontWeight(.medium)
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
    @State var isThemeModalPresented = false
    @State var isAppIconModalPresented = false
    @Environment(\.dismiss) private var dismiss
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
                            MenuItem(iconName: "sparkle", text: "What's New")
                        }
                        MenuItem(iconName: "message.fill", text: "Contact / Feedback")
                        MenuItem(iconName: "at", text: "Follow on Twitter")
                        MenuItem(iconName: "eyes", text: "Privacy Policy")
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
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
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

#Preview {
    SettingsView()
}
