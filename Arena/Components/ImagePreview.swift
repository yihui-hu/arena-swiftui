//
//  ImagePreview.swift
//  Arena
//
//  Created by Yihui Hu on 21/10/23.
//

import SwiftUI
import Giffy
import CachedAsyncImage

struct ImagePreview: View {
    let imageURL: String
    let isChannelCard: Bool?
    
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

// TODO: Change to shimmer
struct ImageLoading: View {
    var body: some View {
        ProgressView()
            .frame(minWidth: 132, minHeight: 132)
            .progressViewStyle(CircularProgressViewStyle(tint: Color("surface-text-secondary")))
            .aspectRatio(contentMode: .fit)
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
