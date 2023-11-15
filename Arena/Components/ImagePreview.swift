//
//  ImagePreview.swift
//  Arena
//
//  Created by Yihui Hu on 21/10/23.
//

import SwiftUI
import Giffy
import Shimmer
import Nuke
import NukeUI

struct ImagePreview: View {
    let imageURL: String
    var isChannelCard: Bool? = false
    @State private var opacity: Double = 0
    
    var body: some View {
        let url = URL(string: imageURL)
        let fileExtension = url?.pathExtension
        
        if fileExtension == "gif" {
            AsyncGiffy(url: url!) { phase in
                switch phase {
                case .loading:
                    ImageLoading()
                case .error:
                    ImageError()
                case .success(let image):
                    HStack {
                        if isChannelCard == true {
                            image
                                .aspectRatio(contentMode: .fit)
                                .opacity(opacity)
                                .onAppear {
                                    withAnimation(.easeIn(duration: 0.1)) {
                                        opacity = 1
                                    }
                                }
                        } else {
                            image
                        }
                    }
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.1)) {
                            opacity = 1
                        }
                    }
                }
            }
            .frame(alignment: .center)
        } else {
            LazyImage(url: url) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(alignment: .center)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 0.1)) {
                                opacity = 1
                            }
                        }
                } else if state.error != nil {
                    ImageError()
                } else {
                    ImageLoading()
                }
            }
        }
    }
}

struct ImageLoading: View {
    var body: some View {
        ProgressView()
            .frame(minWidth: 132, minHeight: 132)
            .progressViewStyle(CircularProgressViewStyle(tint: Color("surface-text-secondary")))
            .aspectRatio(contentMode: .fit)
            .opacity(0.64)
    }
}

struct ImageError: View {
    var body: some View {
        Image(systemName: "questionmark.folder")
            .imageScale(.small)
            .frame(minWidth: 132, minHeight: 132)
            .foregroundStyle(Color("surface-text-secondary"))
            .aspectRatio(contentMode: .fit)
    }
}
