//
//  SearchChannels.swift
//  Arena
//
//  Created by Yihui Hu on 19/10/23.
//

import SwiftUI
import DebouncedOnChange

struct SearchChannels: View {
    @State private var searchTerm = ""
    @State private var selection = "All"
    @StateObject private var searchChannelsData: SearchChannelsData

    init() {
        self._searchChannelsData = StateObject(wrappedValue: SearchChannelsData())
    }

    let options = ["All", "Channels", "Blocks", "Users"]
    
    var body: some View {
        VStack {
            TextField("Search...", text: $searchTerm)
                .onChange(of: searchTerm, debounceTime: .seconds(0.5)) { newValue in
                    searchChannelsData.searchTerm = newValue
                    searchChannelsData.refresh()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 12)
                .textFieldStyle(WhiteBorder())
                .onAppear {
                    UITextField.appearance().clearButtonMode = .whileEditing
                }
            
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
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            
            ScrollView {
                LazyVStack {
                    if let searchResults = searchChannelsData.searchResults {
                        ForEach(searchResults.channels, id: \.id) { channel in
                            NavigationLink(destination: ChannelView(channelSlug: channel.slug)) {
                                VStack {
                                    Text(channel.title)
                                        .foregroundStyle(Color("text-primary"))
                                }
                                .onAppear {
                                    if searchResults.channels.last?.id ?? -1 == channel.id {
                                        if !searchChannelsData.isLoading {
                                            searchChannelsData.loadMore()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .contentMargins(.horizontal, 20)
            .contentMargins(.bottom, 20)
        }
        .background(Color("background"))
        .scrollIndicators(.hidden)
        .refreshable {
            searchChannelsData.refresh()
        }
        .onChange(of: selection, initial: true) { oldSelection, newSelection in
            if oldSelection != newSelection {
                searchChannelsData.selection = newSelection
                searchChannelsData.refresh()
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
            .foregroundColor(Color("surface-text-secondary"))
            .background(Color("surface"))
            .cornerRadius(50)
            .fontDesign(.rounded)
            .fontWeight(.medium)
    }
}

#Preview {
    SearchChannels()
}
