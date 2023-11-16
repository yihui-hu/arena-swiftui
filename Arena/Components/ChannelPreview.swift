//
//  ChannelPreview.swift
//  Arena
//
//  Created by Yihui Hu on 16/10/23.
//

import SwiftUI

struct ChannelPreview: View {
    let blockData: Block // I know semantically this doesn't make sense, but just roll with it for previews
    let fontSize: CGFloat?
    let display: String
    
    var body: some View {
        VStack {
            Text("\(blockData.title)")
                .foregroundStyle(Color("arena-orange"))
            Text("by \(blockData.user.username)")
                .foregroundStyle(Color("text-primary"))
        }
        .font(.system(size: fontSize ?? 16))
        .padding(display == "Table" ? 4 : display == "Large Grid" ? 12 : 16)
    }
}
