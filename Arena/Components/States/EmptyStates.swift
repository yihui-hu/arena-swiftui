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
            .fontWeight(.semibold)
            .padding(.top, 24)
    }
}

struct EmptySearch: View {
    let items: String
    let searchTerm: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .imageScale(.large)
                .fontWeight(.black)
                .foregroundStyle(Color("surface-text-secondary"))
                .frame(width: 52, height: 52)
                .background(Color("surface"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            Text("No \(items) found for search term: \(searchTerm)")
                .font(.system(size: 14))
                .foregroundStyle(Color("surface-tertiary"))
                .fontDesign(.rounded)
                .fontWeight(.semibold)
        }
        .padding(.top, 24)
    }
}


struct EmptyUserChannels: View {
    var body: some View {
        Text("User has no channels")
            .font(.system(size: 14))
            .foregroundStyle(Color("surface-tertiary"))
            .fontDesign(.rounded)
            .fontWeight(.semibold)
            .padding(.top, 24)
    }
}

struct EmptyBlockComments: View {
    var body: some View {
        Text("No comments found")
            .font(.system(size: 14))
            .foregroundStyle(Color("surface-tertiary"))
            .fontDesign(.rounded)
            .fontWeight(.semibold)
            .padding(.vertical, 12)
    }
}

struct EmptyFollowView: View {
    let text: String
    
    var body: some View {
        Text("No \(text)")
            .font(.system(size: 14))
            .foregroundStyle(Color("surface-tertiary"))
            .fontDesign(.rounded)
            .fontWeight(.semibold)
            .padding(.vertical, 12)
    }
}

#Preview {
    EmptySearch(items: "blocks", searchTerm: "hi")
}
