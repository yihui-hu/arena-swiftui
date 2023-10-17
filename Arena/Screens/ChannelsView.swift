//
//  ChannelsView.swift
//  Arena
//
//  Created by Yihui Hu on 12/10/23.
//

import SwiftUI

struct ChannelsView: View {
    @StateObject var channelsData = ChannelsData()
    @State private var selectedChannelSlug: String?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(channelsData.channels?.channels ?? [], id: \.self.id) { channel in
                        NavigationLink(destination: ChannelView(channelSlug: channel.slug)) {
                            HStack {
                                // move this logic to a different view, probably, dedicated for handling image previews
                                if let contents = channel.contents, !contents.isEmpty {
                                    let firstImage = contents[0].image?.thumb.url ?? ""
                                    
                                    AsyncImage(url: URL(string: firstImage)) { phase in
                                        if let image = phase.image {
                                            // if the image is valid
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                        } else {
                                            // placeholder / error image
                                            Image(systemName: "photo")
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(Color.gray)
                                        }
                                    }.frame(height: 100, alignment: .center)
                                } else {
                                    Image(systemName: "photo")
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(Color.gray)
                                }
                                // move the logic above to a different view, probably
                                
                                Spacer()
                                
                                VStack {
                                    Text("\(channel.title):")
                                    Text("\(channel.length) blocks")
                                }
                                
                                Spacer()
                            }
                            .foregroundColor(Color(red: 0.3333, green: 0.3333, blue: 0.3333, opacity: 0.8))
                            .font(.system(.body, design: .rounded))
                            .fontWeight(.semibold)
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 40, style: .continuous)
                                    .stroke(Color(red: 0.3333, green: 0.3333, blue: 0.3333, opacity: 0.2), lineWidth: 3)
                            )
                        }
                        .contentMargins(.bottom, 10)
                    }
                    
                    if channelsData.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                    } else {
                        Color.clear
                            .onAppear {
                                channelsData.loadMore()
                            }
                    }
                    
                    if channelsData.currentPage > channelsData.totalPages {
                        Text("Finished loading all channels")
                            .foregroundStyle(Color.gray)
                    }
                    
                    Text("\n\n")
                }
            }
            .contentMargins(20)
            .scrollIndicators(.hidden)
            .refreshable {
                channelsData.refresh()
            }
        }
    }
}

#Preview {
    ChannelsView()
}

