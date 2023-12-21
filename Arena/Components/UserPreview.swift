//
//  UserPreview.swift
//  Arena
//
//  Created by Yihui Hu on 3/12/23.
//

import SwiftUI

struct UserPreview: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 12) {
            ProfilePic(imageURL: user.avatarImage.display, initials: user.initials, cornerRadius: 64)
            
            Text("\(user.username)")
                .foregroundStyle(Color("text-primary"))
                .lineLimit(1)
                .fontWeight(.medium)
                .fontDesign(.rounded)
            
            Spacer()
            
            Text("\(user.channelCount) channels")
                .font(.system(size: 14))
                .foregroundStyle(Color("text-secondary"))
                .lineLimit(1)
                .fontWeight(.regular)
                .fontDesign(.rounded)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
