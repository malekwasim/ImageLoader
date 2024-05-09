//
//  HomeViewModel.swift
//  ImageLoader
//
//  Created by Apple on 08/05/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var articles: [Articles] = []
    @Published var showAlert = false
        @Published var alertMessage = ""

     func fetchData() {
         guard let url = URL(string: "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100") else {
             return
         }
         
         URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
             guard let data = data, error == nil else {
                 // Handle error
                 self?.alertMessage = "Error: \(error?.localizedDescription ?? "Unknown error")"
                 self?.showAlert = true
                 return
             }

             do {
                 let decodedData = try JSONDecoder().decode([Articles].self, from: data)
                 DispatchQueue.main.async {
                     self?.articles = decodedData
                 }
             } catch {
                 self?.alertMessage = "Error decoding data: \(error)"
                 self?.showAlert = true
             }
         }.resume()
     }
}

