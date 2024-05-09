//
//  AsyncImageView.swift
//  ImageLoader
//
//  Created by Apple on 08/05/24.
//

import SwiftUI

struct AsyncImageView: View {
    @StateObject private var imageLoader = ImageLoader()
        var article: Articles?

        var body: some View {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ProgressView()
                    .onAppear {
                        if let article = article,
                           let domain = article.thumbnail?.domain,
                           let base = article.thumbnail?.basePath,
                           let key = article.thumbnail?.key,
                           let url = URL(string: domain + "/" + base + "/0/" + key) {
                            imageLoader.loadImage(from: url)
                        }
                    }
            }
        }
}

#Preview {
    AsyncImageView()
}

