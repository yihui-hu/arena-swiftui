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
import Kingfisher

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
                                    withAnimation(.easeIn(duration: 0.2)) {
                                        opacity = 1
                                    }
                                }
                        } else {
                            image
                        }
                    }
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.2)) {
                            opacity = 1
                        }
                    }
                }
            }
            .frame(alignment: .center)
        } else {
            KFImage(url)
                .placeholder {
                    ImageLoading()
                }
                .retry(maxCount: 3, interval: .seconds(5))
//                .onFailureImage(KFImage(url: )) // TODO: Produce onFailureImage lol
                .resizable()
                .animation(nil)
                .aspectRatio(contentMode: .fit)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 0.2)) {
                        opacity = 1
                    }
                }
//            CachedAsyncImage(url: url) { phase in
//                switch phase {
//                case .success(let image):
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .opacity(opacity)
//                        .onAppear {
//                            withAnimation(.easeIn(duration: 0.2)) {
//                                opacity = 1
//                            }
//                        }
//                case .empty:
//                    ImageLoading()
//                case .failure(_):
//                    ImageError()
//                default:
//                    ImageLoading()
//                }
//            }
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
