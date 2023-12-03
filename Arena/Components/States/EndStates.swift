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

#Preview {
    EndOfChannel()
}
