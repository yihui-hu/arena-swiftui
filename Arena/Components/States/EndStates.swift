//
//  EndStates.swift
//  Arena
//
//  Created by Yihui Hu on 16/11/23.
//

import SwiftUI

struct EndOfChannel: View {
    var body: some View {
        Text("Reached end of channel")
            .font(.system(size: 14))
            .foregroundStyle(Color("surface-tertiary"))
            .fontDesign(.rounded)
            .fontWeight(.semibold)
            .padding(.top, 24)
    }
}

struct EndOfChannelConnections: View {
    var body: some View {
        Text("Reached end of channel connections")
            .font(.system(size: 14))
            .foregroundStyle(Color("surface-tertiary"))
            .fontDesign(.rounded)
            .fontWeight(.semibold)
            .padding(.top, 24)
    }
}

struct EndOfSearch: View {
    var body: some View {
        Text("Reached end of search")
            .font(.system(size: 14))
            .foregroundStyle(Color("surface-tertiary"))
            .fontDesign(.rounded)
            .fontWeight(.semibold)
            .padding(.top, 24)
    }
}

struct EndOfExplore: View {
    var body: some View {
        Text("Reached end of explore")
            .font(.system(size: 14))
            .foregroundStyle(Color("surface-tertiary"))
            .fontDesign(.rounded)
            .fontWeight(.semibold)
            .padding(.top, 24)
    }
}

struct EndOfUser: View {
    var body: some View {
        Text("Finished loading all channels")
            .font(.system(size: 14))
            .foregroundStyle(Color("surface-tertiary"))
            .fontDesign(.rounded)
            .fontWeight(.semibold)
            .padding(.top, 24)
    }
}

struct EndOfFollowView: View {
    let text: String
    
    var body: some View {
        Text("Reached end of \(text)")
            .font(.system(size: 14))
            .foregroundStyle(Color("surface-tertiary"))
            .fontDesign(.rounded)
            .fontWeight(.semibold)
            .padding(.top, 24)
    }
}

#Preview {
    EndOfChannel()
}
