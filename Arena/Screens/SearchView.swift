//
//  SearchChannels.swift
//  Arena
//
//  Created by Yihui Hu on 19/10/23.
//

import SwiftUI
import DebouncedOnChange

struct SearchView: View {
    @State private var searchTerm: String = ""
    @State private var selection: String = "Channels"
    @State private var changedSelection: Bool = false
    @State private var isButtonFaded = false
    @StateObject private var searchData: SearchData
    
    init() {
        self._searchData = StateObject(wrappedValue: SearchData())
    }
    
    let options = ["Channels", "Blocks", "Users"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("background").ignoresSafeArea()
                
                VStack {
                    VStack(spacing: 12) {
                        TextField("Search...", text: $searchTerm)
                            .onChange(of: searchTerm, debounceTime: .seconds(0.5)) { newValue in
                                searchData.searchTerm = newValue
                                searchData.refresh()
                            }
                            .textFieldStyle(WhiteBorder())
                            .autocorrectionDisabled()
                            .onAppear {
                                UITextField.appearance().clearButtonMode = .whileEditing
                            }
                        
                        if searchTerm != "" {
                            HStack {
                                ForEach(options, id: \.self) { option in
                                    Button("\(option)") {
                                        selection = option
                                    }
                                    .fontDesign(.rounded)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color("surface"))
                                    .cornerRadius(20)
                                    .foregroundStyle(Color(selection == option ? "text-primary" : "surface-text-secondary"))
                                }
                                .opacity(isButtonFaded ? 1 : 0)
                                .onAppear {
                                    withAnimation(.easeIn(duration: 0.1)) {
                                        isButtonFaded = true
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                    
                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            if let searchResults = searchData.searchResults {
                                if selection == "Channels" {
                                    ForEach(searchResults.channels, id: \.id) { channel in
                                        NavigationLink(destination: ChannelView(channelSlug: channel.slug)) {
                                            SearchChannelPreview(searchChannel: channel)
                                        }
                                        .onAppear {
                                            if searchResults.channels.last?.id ?? -1 == channel.id {
                                                if !searchData.isLoading {
                                                    searchData.loadMore()
                                                }
                                            }
                                        }
                                    }
                                } else if selection == "Blocks" {
                                    ForEach(searchResults.blocks, id: \.id) { block in
                                        NavigationLink(destination: SingleBlockView(blockId: block.id)) {
                                            SearchBlockPreview(searchBlock: block)
                                        }
                                        .onAppear {
                                            if searchResults.blocks.last?.id ?? -1 == block.id {
                                                if !searchData.isLoading {
                                                    searchData.loadMore()
                                                }
                                            }
                                        }
                                    }
                                } else if selection == "Users" {
                                    ForEach(searchResults.users, id: \.id) { user in
                                        NavigationLink(destination: SingleBlockView(blockId: 9)) {
                                            SearchUserPreview(searchUser: user)
                                        }
                                        .onAppear {
                                            if searchResults.users.last?.id ?? -1 == user.id {
                                                if !searchData.isLoading {
                                                    searchData.loadMore()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        if searchData.isLoading {
                            LoadingSpinner()
                        }
                        
                        // Make a searchData.finishedLoading state
                        if searchData.currentPage > searchData.totalPages {
                            Text("End of search")
                                .foregroundStyle(Color("surface-text-secondary"))
                        }
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .frame(maxHeight: .infinity)
                    .contentMargins(.horizontal, 16)
                    .contentMargins(.bottom, 20)
                }
                .foregroundStyle(Color("text-primary"))
                .background(Color("background"))
                .scrollIndicators(.hidden)
                .refreshable {
                    searchData.refresh()
                }
                .onChange(of: selection, initial: true) { oldSelection, newSelection in
                    if oldSelection != newSelection {
                        searchData.selection = newSelection
                        searchData.refresh()
                    }
                }
            }
        }
    }
}

struct SearchChannelPreview: View {
    let searchChannel: ArenaSearchedChannel
    @State private var isFaded = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "photo")
                .foregroundColor(Color("surface-text-secondary"))
                .frame(width: 40, height: 40)
                .background(Color("surface"))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            //            AsyncImage(url: URL(string: searchUser.avatarImage.thumb)) { phase in
            //                if let image = phase.image {
            //                    ZStack {
            //                        Color("surface")
            //
            //                        Text(searchUser.initials)
            //                            .font(.system(size: 12))
            //                            .foregroundColor(Color("surface-text-secondary"))
            //
            //                        image
            //                            .resizable()
            //                            .aspectRatio(contentMode: .fit)
            //                    }
            //                    .frame(width: 40, height: 40)
            //                    .clipShape(RoundedRectangle(cornerRadius: 8))
            //                } else {
            //                    Image(systemName: "photo")
            //                        .foregroundColor(Color("surface-text-secondary"))
            //                        .frame(width: 40, height: 40)
            //                        .background(Color("surface"))
            //                        .clipShape(RoundedRectangle(cornerRadius: 8))
            //                }
            //            }
            
            HStack(spacing: 8) {
                Text("\(searchChannel.title)")
                
                Text("/")
                    .foregroundStyle(Color("surface-text-secondary"))
                
                Text("\(searchChannel.user.username)")
                    .foregroundStyle(Color("surface-text-secondary"))
            }
            .lineLimit(1)
            .fontWeight(.medium)
            .fontDesign(.rounded)
        }
        .opacity(isFaded ? 1 : 0)
        .onAppear {
            withAnimation(.easeIn(duration: 0.1)) {
                isFaded = true
            }
        }
        .onDisappear {
            withAnimation(.easeOut(duration: 0.1)) {
                isFaded = false
            }
        }
    }
}

struct SearchUserPreview: View {
    let searchUser: ArenaSearchedUser
    @State private var isFaded = false
    
    var body: some View {
        HStack(spacing: 12) {
            ProfilePic(imageURL: searchUser.avatarImage.thumb, initials: searchUser.initials)
            
            Text("\(searchUser.username)")
                .lineLimit(1)
                .fontWeight(.medium)
                .fontDesign(.rounded)
        }
        .opacity(isFaded ? 1 : 0)
        .onAppear {
            withAnimation(.easeIn(duration: 0.1)) {
                isFaded = true
            }
        }
        .onDisappear {
            withAnimation(.easeOut(duration: 0.1)) {
                isFaded = false
            }
        }
    }
}

struct SearchBlockPreview: View {
    let searchBlock: ArenaSearchedBlock
    @State private var isFaded = false

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: searchBlock.image?.thumb.url ?? "")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    Image(systemName: "photo")
                        .foregroundColor(Color("surface-text-secondary"))
                        .frame(width: 40, height: 40)
                        .background(Color("surface"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            
            Text("\(searchBlock.title)")
                .lineLimit(1)
                .fontWeight(.medium)
                .fontDesign(.rounded)
        }
        .opacity(isFaded ? 1 : 0)
        .onAppear {
            withAnimation(.easeIn(duration: 0.1)) {
                isFaded = true
            }
        }
        .onDisappear {
            withAnimation(.easeOut(duration: 0.1)) {
                isFaded = false
            }
        }
    }
}

struct WhiteBorder: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.leading, 20)
            .padding(.trailing, 12)
            .padding(.vertical, 12)
            .foregroundColor(Color("text-primary"))
            .background(Color("surface"))
            .cornerRadius(50)
            .fontDesign(.rounded)
            .fontWeight(.medium)
    }
}

#Preview {
    SearchView()
}
