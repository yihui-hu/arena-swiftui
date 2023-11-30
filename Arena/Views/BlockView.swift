//
//  BlockView.swift
//  Arena
//
//  Created by Yihui Hu on 14/10/23.
//

import SwiftUI
import BetterSafariView
import SmoothGradient
import AlertToast
import Defaults

struct BlockView: View {
    let blockData: Block
    let channelSlug: String
    @ObservedObject private var channelData: ChannelData
    @StateObject private var connectionsViewModel = BlockConnectionsData()
    @StateObject private var commentsViewModel = BlockCommentsData()
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentIndex: Int
    @State private var presentingSafariView = false
    @State private var showInfoModal: Bool = false
    @State private var isLoadingBlockConnectionsComments: Bool = false
    @State private var shouldNavigateToChannelView: Bool = false
    @State private var selectedConnectionSlug: String?
    @State private var scrollOffset: CGFloat = 0
    @State private var showGradient: Bool = false
    @State private var titleExpanded: Bool = false
    @State private var descriptionExpanded: Bool = false
    @State private var isToastPresenting = false
    @State private var isConnectionsView = true
    
    init(blockData: Block, channelData: ChannelData, channelSlug: String) {
        self.blockData = blockData
        self.channelData = channelData
        self.channelSlug = channelSlug
        _currentIndex = State(initialValue: channelData.contents?.firstIndex(where: { $0.id == blockData.id }) ?? 0)
    }
    
    struct InfoModalButton: View {
        @Binding var showInfoModal: Bool
        var icon: String
        
        var body: some View {
            Button(action: {
                withAnimation(.bouncy(duration: 0.3, extraBounce: -0.1)) {
                    showInfoModal.toggle()
                }
            }) {
                Image(systemName: icon)
            }
            .sensoryFeedback(.impact(flexibility: .solid, intensity: 0.4), trigger: showInfoModal)
        }
    }
    
    var body: some View {
        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth = UIScreen.main.bounds.size.width
        
        ZStack {
            TabView(selection: $currentIndex) {
                ForEach(channelData.contents ?? [], id: \.self.id) { block in
                    if block.baseClass == "Block" {
                        BlockPreview(blockData: block, fontSize: 16)
                            .padding(.horizontal, 4)
                            .padding(.bottom, showInfoModal ? 308 : 48)
                            .frame(maxHeight: screenHeight * 0.72)
                            .foregroundColor(Color("text-primary"))
                            .tag(channelData.contents?.firstIndex(of: block) ?? 0)
                            .onAppear {
                                if channelData.contents?.last?.id ?? -1 == block.id {
                                    if !channelData.isContentsLoading {
                                        channelData.loadMore(channelSlug: self.channelSlug)
                                        isToastPresenting = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            isToastPresenting = false
                                        }
                                    }
                                }
                            }
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
            
            // Floating action buttons
            ZStack {
                ShareLink(item: URL(string: "https://are.na/block/\(blockData.id)")!) {
                    Image(systemName: "square.and.arrow.up")
                        .padding(.bottom, 4)
                        .frame(width: 40, height: 40)
                        .background(.thickMaterial)
                        .clipShape(Circle())
                }
                .padding(.top, screenHeight * 0.7)
                .offset(x: -80)
                
                VStack {
                    Button(action: {
                        print("Connect")
                    }) {
                        Text("Connect")
                            .font(.system(size: 16))
                            .fontDesign(.rounded)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 11)
                    .background(.thickMaterial)
                    .cornerRadius(16)
                }
                .padding(.top, screenHeight * 0.7)
                
                ZStack {
                    if showInfoModal {
                        GeometryReader { geometry in
                            LinearGradient(gradient: .smooth(from: Color("surface"), to: Color("surface").opacity(0), curve: .easeInOut),
                                           startPoint: .top,
                                           endPoint: .bottom
                            )
                            .frame(height: 88)
                            .position(x: geometry.size.width / 2, y: 44)
                            .opacity(showGradient ? 1 : 0)
                            .animation(.easeInOut(duration: 0.2), value: UUID())
                        }
                        .zIndex(2)
                        .allowsHitTesting(false)
                        
                        HStack(alignment: .top) {
                            ScrollView(showsIndicators: false) {
                                ScrollViewReader { proxy in
                                    VStack(spacing: 20) {
                                        let currentBlock = channelData.contents?[currentIndex]
                                        let title = currentBlock?.title ?? ""
                                        let description = currentBlock?.description ?? ""
                                        let connectedAt = currentBlock?.connectedAt ?? ""
                                        let updatedAt = currentBlock?.updatedAt ?? ""
                                        let connectedBy = currentBlock?.connectedByUsername ?? ""
                                        let connectedById = currentBlock?.connectedByUserId ?? 0
                                        let source = currentBlock?.source?.title ?? currentBlock?.source?.url ?? ""
                                        let sourceURL = currentBlock?.source?.url ?? "https://are.na/block/\(currentBlock?.id ?? 0)"
                                        
                                        // Title and Description
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("\(title != "" ? title : "No title")")
                                                .fontDesign(.rounded)
                                                .fontWeight(.semibold)
                                                .font(.system(size: 18))
                                                .lineLimit(titleExpanded ? nil : 2)
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: screenWidth * 0.72, alignment: .topLeading)
                                                .onTapGesture {
                                                    withAnimation(.easeInOut(duration: 0.2)) {
                                                        titleExpanded.toggle()
                                                    }
                                                }
                                                .sensoryFeedback(.impact(flexibility: .solid, intensity: 0.4), trigger: titleExpanded)
                                            
                                            Text("\(description != "" ? description : "No description")")
                                                .font(.system(size: 16))
                                                .lineLimit(descriptionExpanded ? nil : 3)
                                                .multilineTextAlignment(.leading)
                                                .foregroundStyle(Color("surface-text-secondary"))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .onTapGesture {
                                                    withAnimation(.easeInOut(duration: 0.2)) {
                                                        descriptionExpanded.toggle()
                                                    }
                                                }
                                                .sensoryFeedback(.impact(flexibility: .solid, intensity: 0.4), trigger: descriptionExpanded)
                                        }
                                        
                                        // Metadata
                                        VStack(spacing: 4) {
                                            HStack(spacing: 20) {
                                                Text("Added")
                                                    .fontDesign(.rounded)
                                                    .fontWeight(.semibold)
                                                Spacer()
                                                Text("\(connectedAt != "" ? relativeTime(connectedAt) : "unknown")")
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
                                                NavigationLink(destination: UserView(userId: connectedById)) {
                                                    Text("\(connectedBy != "" ? connectedBy : "unknown")")
                                                        .fontWeight(.medium)
                                                        .lineLimit(1)
                                                }
                                                .id(connectedById)
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
                                        }
                                        .font(.system(size: 15))
                                        
                                        // Connect and Actions Button
                                        HStack {
                                            Button(action: {
                                                print("Connect")
                                            }) {
                                                Text("Connect")
                                                    .font(.system(size: 15))
                                                    .fontDesign(.rounded)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(Color("surface"))
                                            }
                                            .padding(.vertical, 8)
                                            .frame(maxWidth: .infinity)
                                            .background(Color("backdrop-inverse"))
                                            .cornerRadius(12)
                                            
                                            Spacer().frame(width: 16)
                                            
                                            Button(action: {
                                                print("Actions")
                                            }) {
                                                Text("Actions")
                                                    .font(.system(size: 15))
                                                    .fontDesign(.rounded)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(Color("text-primary"))
                                            }
                                            .padding(.vertical, 8)
                                            .frame(maxWidth: .infinity)
                                            .cornerRadius(12)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color("backdrop-inverse"), lineWidth: 2)
                                            )
                                        }
                                        
                                        // Connections and Comments
                                        VStack {
                                            HStack {
                                                Spacer()
                                                Button(action: { isConnectionsView = true }) {
                                                    Text("Connections (\(connectionsViewModel.connections.count))")
                                                        .frame(maxWidth: .infinity)
                                                        .foregroundStyle(Color(isConnectionsView ? "text-primary" : "surface-text-secondary"))
                                                }
                                                Spacer()
                                                Button(action: { isConnectionsView = false }) {
                                                    Text("Comments (\(commentsViewModel.comments.count))")
                                                        .frame(maxWidth: .infinity)
                                                        .foregroundStyle(Color(isConnectionsView ? "surface-text-secondary" : "text-primary"))
                                                }
                                                Spacer()
                                            }
                                            .frame(maxWidth: .infinity)
                                            .font(.system(size: 14))
                                            
                                            HStack(spacing: 0) {
                                                Rectangle()
                                                    .fill(Color(isConnectionsView ? "text-primary" : "surface"))
                                                    .frame(maxWidth: .infinity, maxHeight: 1)
                                                Rectangle()
                                                    .fill(Color(isConnectionsView ? "surface" : "text-primary"))
                                                    .frame(maxWidth: .infinity, maxHeight: 1)
                                            }
                                            
                                            if isLoadingBlockConnectionsComments {
                                                CircleLoadingSpinner()
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                    .padding(.vertical, 12)
                                            } else {
                                                LazyVStack(spacing: isConnectionsView ? 12 : 24) {
                                                    if isConnectionsView {
                                                        ForEach(connectionsViewModel.connections, id: \.id) { connection in
                                                            NavigationLink(destination: ChannelView(channelSlug: connection.slug)) {
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
                                                                    
                                                                    Text("\(connection.length) items")
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
                                                                        .stroke(Color("surface-tertiary"), lineWidth: 2)
                                                                )
                                                            }
                                                        }
                                                    } else {
                                                        if (commentsViewModel.comments.count == 0) {
                                                            EmptyBlockComments()
                                                        } else {
                                                            ForEach(commentsViewModel.comments, id: \.id) { comment in
                                                                HStack(alignment: .top, spacing: 8) {
                                                                    ProfilePic(imageURL: comment.user.avatarImage.display, initials: comment.user.initials)
                                                                    
                                                                    VStack(alignment: .leading, spacing: 4) {
                                                                        HStack {
                                                                            Text("\(comment.user.fullName)")
                                                                                .fontDesign(.rounded)
                                                                                .fontWeight(.medium)
                                                                            Spacer()
                                                                            Text("\(relativeTime(comment.createdAt))")
                                                                                .foregroundStyle(Color("surface-text-secondary"))
                                                                                .font(.system(size: 14))
                                                                        }
                                                                        Text("\(comment.body)")
                                                                    }
                                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                                    .font(.system(size: 15))
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                .padding(.top, 12)
                                            }
                                        }
                                    }
                                    .onChange(of: scrollOffset) { _, offset in
                                        withAnimation {
                                            showGradient = offset > 1
                                        }
                                    }
                                    .background(GeometryReader { proxy -> Color in
                                        DispatchQueue.main.async {
                                            scrollOffset = -proxy.frame(in: .named("scrollModal")).origin.y
                                        }
                                        return Color.clear
                                    })
                                }
                                .coordinateSpace(name: "scrollModal")
                                .opacity(showInfoModal ? 1 : 0)
                            }
                        }
                    }
                    
                    ZStack {
                        InfoModalButton(showInfoModal: $showInfoModal, icon: "info.circle")
                            .offset(x: showInfoModal ? 120 : 0, y: showInfoModal ? -40 : 0)
                            .opacity(showInfoModal ? 0 : 1)
                            .scaleEffect(showInfoModal ? 0 : 1)
                        
                        InfoModalButton(showInfoModal: $showInfoModal, icon: "x.circle")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            .offset(x: showInfoModal ? -16 : 24, y: showInfoModal ? 16 : -24)
                            .opacity(showInfoModal ? 1 : 0)
                            .scaleEffect(showInfoModal ? 1 : 0)
                    }
                    .onChange(of: showInfoModal) { _ in
                        if showInfoModal {
                            fetchConnectionsData()
                            fetchCommentsData()
                        }
                    }
                    .onChange(of: currentIndex) { _ in
                        if showInfoModal {
                            fetchConnectionsData()
                            fetchCommentsData()
                        }
                    }
                }
                .frame(maxWidth: showInfoModal ? 360 : 40, maxHeight: showInfoModal ? screenHeight * 0.4 : 40, alignment: .top)
                .background(Color("surface"))
                .clipShape(showInfoModal ? RoundedRectangle(cornerRadius: 24) : RoundedRectangle(cornerRadius: 100))
                .offset(x: showInfoModal ? 0 : 80, y: showInfoModal ? -8 : 0)
                .padding(.top, showInfoModal ? screenHeight * 0.4 : screenHeight * 0.7)
                .padding(.horizontal, 16)
                .zIndex(9)
            }
        }
        .toast(isPresenting: $isToastPresenting, offsetY: 64) {
            AlertToast(displayMode: .hud, type: .regular, title: "Loading...")
        }
    }
    
    private func fetchConnectionsData() {
        if let blockId = channelData.contents?[currentIndex].id {
            isLoadingBlockConnectionsComments = true
            connectionsViewModel.fetchBlockConnections(blockId: blockId) { success in
                isLoadingBlockConnectionsComments = false
            }
        }
    }
    
    private func fetchCommentsData() {
        if let blockId = channelData.contents?[currentIndex].id {
            isLoadingBlockConnectionsComments = true
            commentsViewModel.fetchBlockComments(blockId: blockId) { success in
                isLoadingBlockConnectionsComments = false
            }
        }
    }
    
    class BlockConnectionsData: ObservableObject {
        @Published var connections: [BlockConnection] = []
        @State private var isLoading: Bool = false
        
        func fetchBlockConnections(blockId: Int, completion: @escaping (Bool) -> Void) {
            isLoading = true
            
            guard let url = URL(string: "https://api.are.na/v2/blocks/\(blockId)") else {
                self.isLoading = false
                return
            }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(Defaults[.accessToken])", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { [unowned self] (data, _, error) in
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
    
    class BlockCommentsData: ObservableObject {
        @Published var comments: [BlockComment] = []
        @State private var isLoading: Bool = false
        
        var currentPage: Int = 1
        var totalPages: Int = 1
        
        func fetchBlockComments(blockId: Int, completion: @escaping (Bool) -> Void) {
            var allComments: [BlockComment] = []
            currentPage = 1
            totalPages = 1

            func fetchData() {
                isLoading = true
                
                guard let url = URL(string: "https://api.are.na/v2/blocks/\(blockId)/comments?page=\(currentPage)") else {
                    self.isLoading = false
                    completion(false)
                    return
                }
                
                var request = URLRequest(url: url)
                request.setValue("Bearer \(Defaults[.accessToken])", forHTTPHeaderField: "Authorization")
                
                URLSession.shared.dataTask(with: request) { [unowned self] (data, _, error) in
                    if let data = data {
                        do {
                            let blockComments = try JSONDecoder().decode(BlockComments.self, from: data)
                            DispatchQueue.main.async {
                                allComments.append(contentsOf: blockComments.comments)
                                self.totalPages = Int(ceil(Double(blockComments.length) / Double(20)))
                                self.currentPage += 1
                                
                                if self.currentPage <= self.totalPages {
                                    fetchData()
                                } else {
                                    self.comments = allComments.reversed()
                                    completion(true)
                                    self.isLoading = false
                                }
                            }
                        } catch {
                            print("Error decoding comments data: \(error)")
                            completion(false)
                            self.isLoading = false
                        }
                    } else if let error = error {
                        print("Error fetching comments: \(error)")
                        completion(false)
                        self.isLoading = false
                    }
                }.resume()
            }

            fetchData()
        }
    }
}
