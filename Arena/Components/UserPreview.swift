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
                .foregroundStyle(Color.primary)
                .lineLimit(1)
                .fontWeight(.medium)
                .fontDesign(.rounded)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
