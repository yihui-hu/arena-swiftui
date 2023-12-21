//
//  RabbitHoleView.swift
//  Arena
//
//  Created by Yihui Hu on 20/12/23.
//

import SwiftUI
import Defaults

struct RabbitHoleView: View {
    @Default(.rabbitHole) var rabbitHole

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Button(action: {
                    rabbitHole = []
                }) {
                    Text("Clear rabbit hole")
                }
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(rabbitHole, id: \.self.id) { rabbitHoleItem in
                            VStack(spacing: 4) {
                                Text("\(rabbitHoleItem.type)")
                                Text("\(rabbitHoleItem.itemId)")
                                Text("\(rabbitHoleItem.timestamp)")
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 4)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("🕳️")
                        .foregroundStyle(Color("text-primary"))
                        .font(.system(size: 20))
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                }
            }
            .toolbarBackground(Color("background"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .background(Color("background"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color("background"))
        .contentMargins(.leading, 0, for: .scrollIndicators)
        .contentMargins(16)
    }
}

#Preview {
    RabbitHoleView()
}
