//
//  ProfilePic.swift
//  Arena
//
//  Created by Yihui Hu on 21/10/23.
//

import SwiftUI
import Giffy

struct ProfilePic: View {
    let imageURL: String
    let initials: String
    let fontSize: CGFloat?
    let dimension: CGFloat?
    let cornerRadius: CGFloat?
    
    init(imageURL: String, initials: String, fontSize: CGFloat? = 12, dimension: CGFloat? = 40, cornerRadius: CGFloat? = 8) {
        self.imageURL = imageURL
        self.initials = initials
        self.fontSize = fontSize
        self.dimension = dimension
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        let url = URL(string: imageURL)
        let fileExtension = url?.pathExtension
        
        if fileExtension == "gif" {
            AsyncGiffy(url: url!) { phase in
                switch phase {
                case .loading, .error:
                    Image(systemName: "photo")
                        .foregroundColor(Color("surface-text-secondary"))
                        .frame(width: dimension ?? 40, height: dimension ?? 40)
                        .background(Color("surface"))
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius ?? 8))
                case .success(let image):
                    ZStack {
                        Color("surface")
                        
                        Text(initials)
                            .font(.system(size: fontSize ?? 12))
                            .foregroundColor(Color("surface-text-secondary"))
                        
                        image
                    }
                    .frame(width: dimension ?? 40, height: dimension ?? 40)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius ?? 8))
                }
            }
        } else {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    ZStack {
                        Color("surface")
                        
                        Text(initials)
                            .font(.system(size: fontSize ?? 12))
                            .foregroundColor(Color("surface-text-secondary"))
                        
                        image
                    }
                    .frame(width: dimension ?? 40, height: dimension ?? 40)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius ?? 8))
                case .empty, .failure(_):
                    Image(systemName: "photo")
                        .foregroundColor(Color("surface-text-secondary"))
                        .frame(width: dimension ?? 40, height: dimension ?? 40)
                        .background(Color("surface"))
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius ?? 8))
                default:
                    Image(systemName: "photo")
                        .foregroundColor(Color("surface-text-secondary"))
                        .frame(width: dimension ?? 40, height: dimension ?? 40)
                        .background(Color("surface"))
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius ?? 8))
                }
            }
            .frame(alignment: .center)
        }
    }
}

#Preview {
    ProfilePic(imageURL: "https://arena-avatars.s3.amazonaws.com/49570/small_810241674b087520dc397471c60c66dc.gif?1684382532", initials: "YH")
}
