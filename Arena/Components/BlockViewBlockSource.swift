//
//  BlockViewBlockSource.swift
//  Arena
//
//  Created by Yihui Hu on 18/12/23.
//

import SwiftUI
import Defaults

struct BlockSource: View {
    var source: String
    var sourceURL: String
    
    var body: some View {
        HStack(spacing: 20) {
            Text("Source")
                .fontDesign(.rounded)
                .fontWeight(.semibold)
            Spacer()
            
            Button(action: {
                Defaults[.safariViewURL] = sourceURL
                Defaults[.safariViewOpen] = true
            }) {
                Text("\(source)")
                    .foregroundStyle(Color("text-primary"))
                    .lineLimit(1)
                    .fontWeight(.medium)
            }
        }
        Divider().frame(height: 0.5)
    }
}
