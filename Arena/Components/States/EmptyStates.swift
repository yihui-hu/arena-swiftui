//
//  EmptyStates.swift
//  Arena
//
//  Created by Yihui Hu on 16/11/23.
//

import SwiftUI

struct EmptyChannel: View {
    var body: some View {
        Text("Channel is empty")
            .font(.system(size: 14))
            .foregroundStyle(Color("surface-tertiary"))
            .fontDesign(.rounded)
            .fontWeight(.medium)
            .padding(.top, 24)
    }
}

struct EmptySearch: View {
    let items: String
    let searchTerm: String
    
    var body: some View {
        // TODO: Emulate Family's browser search empty state
        Text("No \(items) found for search term: \(searchTerm)")
            .font(.system(size: 14))
            .foregroundStyle(Color("surface-tertiary"))
            .fontDesign(.rounded)
            .fontWeight(.medium)
            .padding(.top, 24)
    }
}


struct EmptyUserChannels: View {
    var body: some View {
        Text("User has no channels")
            .font(.system(size: 14))
            .foregroundStyle(Color("surface-tertiary"))
            .fontDesign(.rounded)
            .fontWeight(.medium)
            .padding(.top, 24)
    }
}

struct EmptyBlockComments: View {
    var body: some View {
        Text("No comments found")
            .font(.system(size: 14))
            .foregroundStyle(Color("surface-tertiary"))
            .fontDesign(.rounded)
            .fontWeight(.medium)
            .padding(.vertical, 12)
    }
}

#Preview {
    EmptyChannel()
}
