//
//  BlockView.swift
//  Arena
//
//  Created by Yihui Hu on 14/10/23.
//

import SwiftUI
import Modals
import BetterSafariView
import SmoothGradient

struct BlockView: View {
    let blockData: Block
    let channelSlug: String
    @ObservedObject private var channelData: ChannelData
    @StateObject private var connectionsViewModel = BlockConnectionsData()
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentIndex: Int
    @State private var presentingSafariView = false
    @State private var isInfoModalPresented: Bool = false
    @State private var isLoadingBlockConnections: Bool = false
    @State private var shouldNavigateToChannelView = false
    @State private var selectedConnectionSlug: String?
    
    init(blockData: Block, channelData: ChannelData, channelSlug: String) {
        self.blockData = blockData
        self.channelData = channelData
        self.channelSlug = channelSlug
        _currentIndex = State(initialValue: channelData.contents?.firstIndex(where: { $0.id == blockData.id }) ?? 0)
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $currentIndex) {
                ForEach(channelData.contents ?? [], id: \.self.id) { block in
                    let screenHeight = UIScreen.main.bounds.size.height
                    
                    // Display only block content in this TabView
                    if block.baseClass == "Block" {
                        HStack(alignment: .top) {
                            BlockPreview(blockData: block, fontSize: 16)
                                .padding(.horizontal, 4)
                                .padding(.bottom, 24)
                                .frame(maxHeight: screenHeight * 0.64)
                        }
                        .foregroundColor(Color("text-primary"))
                        .tag(channelData.contents?.firstIndex(of: block) ?? 0)
                        .onAppear {
                            if channelData.contents?.last?.id ?? -1 == block.id {
                                if !channelData.isContentsLoading {
                                    channelData.loadMore(channelSlug: self.channelSlug)
                                }
                            }
                        }
                    }
                }
            }
            .modal(isPresented: $isInfoModalPresented, size: .small, options: [.prefersDragHandle, .disableContentDragging]) {
                ZStack {
                    GeometryReader { geometry in
                        LinearGradient(
                            gradient: .smooth(from: Color("modal"), to: Color("modal").opacity(0), curve: .easeInOut),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 88)
                        .position(x: geometry.size.width / 2, y: 44)
                    }
                    .zIndex(2)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            // TODO: Handle channels (!)
                            let currentBlock = channelData.contents?[currentIndex]
                            let title = currentBlock?.title ?? ""
                            let description = currentBlock?.description ?? ""
                            let createdAt = currentBlock?.createdAt ?? ""
                            let updatedAt = currentBlock?.updatedAt ?? ""
                            let connectedBy = currentBlock?.connectedByUsername ?? ""
                            let source = currentBlock?.source?.title ?? currentBlock?.source?.url ?? ""
                            let sourceURL = currentBlock?.source?.url ?? "https://are.na/block/\(currentBlock?.id ?? 435)" // TODO: Have an error block, lol
                            
                            VStack(spacing: 4) {
                                Text("\(title != "" ? title : "No title")")
                                    .fontDesign(.rounded)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 18))
                                    .lineLimit(2) // TODO: Add ability to expand title
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                Text("\(description != "" ? description : "No description")")
                                    .font(.system(size: 16))
                                    .lineLimit(3) // TODO: Add ability to expand description
                                    .foregroundStyle(Color("surface-text-secondary"))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                            }
                            
                            VStack(spacing: 4) {
                                HStack(spacing: 20) {
                                    Text("Added")
                                        .fontDesign(.rounded)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Text("\(createdAt != "" ? relativeTime(createdAt) : "unknown")")
                                        .foregroundStyle(Color("surface-text-secondary"))
                                }
                                Divider()
                                
                                HStack(spacing: 20) {
                                    Text("Updated")
                                        .fontDesign(.rounded)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Text("\(updatedAt != "" ? relativeTime(updatedAt) : "unknown")")
                                        .foregroundStyle(Color("surface-text-secondary"))
                                }
                                Divider()
                                
                                HStack(spacing: 20) {
                                    Text("Connected by")
                                        .fontDesign(.rounded)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Text("\(connectedBy != "" ? connectedBy : "unknown")")
                                        .fontWeight(.medium)
                                }
                                Divider()
                                
                                if source != "" {
                                    HStack(spacing: 20) {
                                        Text("Source")
                                            .fontDesign(.rounded)
                                            .fontWeight(.semibold)
                                        Spacer()
                                        
                                        Button(action: {
                                            self.presentingSafariView = true
                                        }) {
                                            Text("\(source)")
                                                .lineLimit(1)
                                                .fontWeight(.medium)
                                        }
                                        .safariView(isPresented: $presentingSafariView) {
                                            SafariView(
                                                url: URL(string: sourceURL)!,
                                                configuration: SafariView.Configuration(
                                                    entersReaderIfAvailable: false,
                                                    barCollapsingEnabled: true
                                                )
                                            )
                                            .preferredBarAccentColor(.clear)
                                            .preferredControlAccentColor(.accentColor)
                                            .dismissButtonStyle(.done)
                                        }
                                    }
                                    Divider()
                                }
                                
                                // TODO: Handle different block types (dimensions for images, fileSize for attachments, etc.)
                                //                        HStack(spacing: 20) {
                                //                            Text("Dimensions")
                                //                                .fontDesign(.rounded)
                                //                                .fontWeight(.semibold)
                                //                            Spacer()
                                //                            Text("656 x 454")
                                //                                .foregroundStyle(Color("surface-text-secondary"))
                                //                        }
                                //                        Divider()
                            }
                            .font(.system(size: 16))
                            
                            HStack {
                                Button(action: {
                                    print("Connect")
                                }) {
                                    Text("Connect")
                                        .fontDesign(.rounded)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color("surface"))
                                }
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(Color("backdrop-inverse"))
                                .cornerRadius(16)
                                
                                Spacer().frame(width: 16)
                                
                                Button(action: {
                                    print("Actions")
                                }) {
                                    Text("Actions")
                                        .fontDesign(.rounded)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color("text-primary"))
                                }
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("backdrop-inverse"), lineWidth: 2)
                                )
                                .cornerRadius(16)
                            }
                            
                            VStack {
                                HStack {
                                    Spacer()
                                    Button(action: { print("Comments") }) {
                                        Text("Connections (\(connectionsViewModel.connections.count))")
                                            .frame(maxWidth: .infinity)
                                    }
                                    Spacer()
                                    Button(action: { print("Comments") }) {
                                        Text("Comments (200)")
                                            .frame(maxWidth: .infinity)
                                            .foregroundStyle(Color("surface-text-secondary"))
                                    }
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .font(.system(size: 14))
                                
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .fill(Color("text-primary"))
                                        .frame(maxWidth: .infinity, maxHeight: 1)
                                    Rectangle()
                                        .fill(Color("surface"))
                                        .frame(maxWidth: .infinity, maxHeight: 1)
                                }
                                
                                if isLoadingBlockConnections {
                                    ProgressView("Loading...")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity) }
                                else {
                                    LazyVStack(spacing: 12) {
                                        ForEach(connectionsViewModel.connections, id: \.id) { connection in
                                            Button(action: {
                                                isInfoModalPresented = false // TODO: Figure out why this isn't working
                                                selectedConnectionSlug = connection.slug
                                                shouldNavigateToChannelView = true
                                            }) {
                                                VStack(spacing: 4) {
                                                    HStack(spacing: 4) {
                                                        if connection.status != "closed" {
                                                            Image(systemName: "circle.fill")
                                                                .scaleEffect(0.5)
                                                                .foregroundColor(connection.status == "public" ? Color.green : Color.red)
                                                        }
                                                        Text("\(connection.title)")
                                                            .font(.system(size: 16))
                                                            .lineLimit(1)
                                                            .fontDesign(.rounded)
                                                            .fontWeight(.medium)
                                                            .frame(maxWidth: .infinity, alignment: .leading)
                                                    }
                                                    
                                                    Text("\(connection.length) items") // TODO: Get user data, replace userId lol
                                                        .font(.system(size: 14))
                                                        .lineLimit(1)
                                                        .foregroundStyle(Color("surface-text-secondary"))
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                }
                                                .padding(12)
                                                .frame(maxWidth: .infinity)
                                                .cornerRadius(12)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(Color("surface"), lineWidth: 2)
                                                )
                                            }
                                        }
                                    }
                                    .padding(.top, 12)
                                }
                            }
                            .padding(.top, 16)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding(.horizontal, 20)
                        .padding(.top, 64)
                    }
                }
            }
            .padding(.horizontal, 12)
            .background(Color("background"))
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        BackButton()
                    }
                }
            }
            .toolbarBackground(Color("background"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            
            HStack(spacing: 12) {
                Button(action: {
                    print("Connect")
                }) {
                    Image(systemName: "arrow.right.square")
                        .frame(width: 40, height: 40)
                        .background(.thinMaterial)
                        .clipShape(Circle())
                }
                
                Button(action: {
                    // TODO: FIX ASYNC LOADING !!! I want optimistic loading
                    if let blockId = channelData.contents?[currentIndex].id {
                        isLoadingBlockConnections = true
                        connectionsViewModel.fetchBlockConnections(blockId: blockId) { success in
                            isLoadingBlockConnections = false
                            isInfoModalPresented = true
                        }
                    }
                }) {
                    Image(systemName: "info.circle")
                        .frame(width: 40, height: 40)
                        .background(.thinMaterial)
                        .clipShape(Circle())
                }
            }
            .frame(maxWidth: .infinity, alignment: .bottomTrailing)
            .padding(.top, UIScreen.main.bounds.size.height * 0.68)
            .padding(.trailing, 20)
            .foregroundStyle(Color("surface-text-secondary"))
        }
        
        NavigationLink("", destination: ChannelView(channelSlug: selectedConnectionSlug ?? ""), isActive: $shouldNavigateToChannelView)
            .opacity(0) // Hide the link
    }
}

class BlockConnectionsData: ObservableObject {
    @Published var connections: [BlockConnection] = []
    @State private var isLoading: Bool = false
    
    func fetchBlockConnections(blockId: Int, completion: @escaping (Bool) -> Void) {
        isLoading = true
        
        // Perform the API request and update the connections property
        let apiURL = URL(string: "http://api.are.na/v2/blocks/\(blockId)")!
        URLSession.shared.dataTask(with: apiURL) { data, _, error in
            if let data = data {
                do {
                    let blockConnections = try JSONDecoder().decode(BlockConnections.self, from: data)
                    DispatchQueue.main.async {
                        self.connections = blockConnections.connections
                        completion(true)
                        self.isLoading = false
                    }
                } catch {
                    print("Error decoding connections data: \(error)")
                    completion(false)
                    self.isLoading = false
                }
            } else if let error = error {
                print("Error fetching connections: \(error)")
                completion(false)
                self.isLoading = false
            }
        }.resume()
    }
}
