//
//  ImagePreview.swift
//  Arena
//
//  Created by Yihui Hu on 21/10/23.
//

import SwiftUI
import Giffy
import CachedAsyncImage
import Shimmer

struct ImagePreview: View {
    let imageURL: String
    let isChannelCard: Bool?
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
                    if isChannelCard != nil, isChannelCard == true {
                        image
                            .aspectRatio(contentMode: .fit)
                            .opacity(opacity)
                            .onAppear {
                                withAnimation(.easeIn(duration: 0.2)) {
                                    opacity = 1
                                }
                            }
                    } else {
                        image
                    }
                }
            }
            .frame(alignment: .center)
        } else {
            CachedAsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 0.2)) {
                                opacity = 1
                            }
                        }
                case .empty:
                    ImageLoading()
                case .failure(_):
                    ImageError()
                default:
                    ImageError()
                }
            }
            .frame(alignment: .center)
        }
    }
}

struct ImageLoading: View {
    var body: some View {
        ProgressView()
            .frame(minWidth: 132, minHeight: 132)
            .progressViewStyle(CircularProgressViewStyle(tint: Color("surface-text-secondary")))
            .aspectRatio(contentMode: .fit)
            .opacity(0.5)
    }
}

struct ImageError: View {
    var body: some View {
        Image(systemName: "questionmark.folder")
            .frame(minWidth: 132, minHeight: 132)
            .foregroundStyle(Color("surface-text-secondary"))
            .aspectRatio(contentMode: .fit)
    }
}
