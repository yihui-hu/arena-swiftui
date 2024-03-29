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
    @State private var path = NavigationPath()
    
    @Default(.widgetTapped) var widgetTapped
    @Default(.widgetBlockId) var widgetBlockId
    
    var body: some View {
        NavigationStack(path: $path) {
            UserInfo(userId: userId, profileView: true)
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
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .scaledToFit()
                                .fontWeight(.ultraLight)
                                .frame(width: 20, height: 20)
                        }
                        .foregroundStyle(Color("surface-text-secondary"))
                    }
                }
                .toolbarBackground(Color("background"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationDestination(isPresented: $widgetTapped) {
                    HistorySingleBlockView(blockId: widgetBlockId)
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color("background"))
        .contentMargins(.leading, 0, for: .scrollIndicators)
        .contentMargins(16)
    }
}

#Preview {
    ProfileView(userId: 49570)
}
