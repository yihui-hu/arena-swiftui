//
//  ProfileView.swift
//  Arena
//
//  Created by Yihui Hu on 22/10/23.
//

import SwiftUI
import Defaults

struct ProfileView: View {
    let userId: Int
    @Binding var tab: Int
        
    var body: some View {
        NavigationStack {
            UserInfo(userId: userId)
                .padding(.bottom, 4)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Profile")
                            .foregroundStyle(Color("text-primary"))
                            .font(.system(size: 20))
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack(spacing: 8) {
                            Button(action: {
                                self.tab = 1
                            }) {
                                Image(systemName: "magnifyingglass")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                            }
                            .fontWeight(.bold)
                            .foregroundStyle(Color("surface-text-secondary"))
                            
                            NavigationLink(destination: SettingsView()) {
                                Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            }
                            .foregroundStyle(Color("surface-text-secondary"))
                        }
                    }
                }
                .toolbarBackground(Color("background"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color("background"))
        .contentMargins(.leading, 0, for: .scrollIndicators)
        .contentMargins(16)
    }
}
