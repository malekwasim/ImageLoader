//
//  ImageLoader.swift
//  ImageLoader
//
//  Created by Apple on 08/05/24.
//

import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    func loadImage(from url: URL) {
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data,
            let image = UIImage(data: data) {
            self.image = image
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response, error == nil else {
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data), let httpResponse = response as? HTTPURLResponse {
                    let cachedData = CachedURLResponse(response: httpResponse, data: data)
                    cache.storeCachedResponse(cachedData, for: request)

                    self.image = image
                }
            }
        }.resume()
    }
}
