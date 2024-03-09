//
//  CommonImage.swift
//  Effem
//
//  Created by Thomas Rademaker on 11/2/23.
//

import SwiftUI
import NukeUI

enum ImageType {
    case url(url: String?, sfSymbol: String)
    case asset(Image)
    case diskURL(path: URL, sfSymbol: String)
    case data(Data?, sfSymbol: String)
}

@MainActor
struct CommonImage: View {
    let image: ImageType
    
    var body: some View {
        switch image {
        case .url(let imageURL, let symbol):
            if let imageURL {
                LazyImage(url: URL(string: imageURL)) { state in
                    if let image = state.image {
                        image
                            .resizable()
                    } else {
                        CommonSystemImage(systemName: symbol)
                    }
                }
            } else {
                CommonSystemImage(systemName: symbol)
            }
        case .asset(let image):
            image
                .resizable()
        case .diskURL(let path, let symbol):
            if let imageData = try? Data(contentsOf: path),
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                CommonSystemImage(systemName: symbol)
            }
        case .data(let data, let symbol):
            if let data, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                CommonSystemImage(systemName: symbol)
            }
        }
    }
}

@MainActor
fileprivate struct CommonSystemImage: View {
    var systemName: String
    
    var body: some View {
        Text(" ")
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .background(.primaryBackground)
            .overlay(
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
            )
    }
}

#Preview {
    ZStack {
        Color.black
        CommonImage(image: .url(url: "", sfSymbol: "person"))
            .frame(width: 30)
            .clipShape(Circle())
    }
}
