//
//  ContentView.swift
//  ImageLoader
//
//  Created by Apple on 08/05/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var imageViewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            if imageViewModel.articles.isEmpty {
                ProgressView("Loading...")
                    .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 10) {
                        ForEach(imageViewModel.articles, id: \.id) { article in
                            AsyncImageView(article: article)
                                .frame(width: 100, height: 100)
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                        }
                    }
                    .padding()
                }
                .navigationBarTitle("Media Coverages", displayMode: .inline)
                .navigationBarHidden(false)
            }

        }
        .onAppear {
            imageViewModel.fetchData()
        }
        .alert(isPresented: $imageViewModel.showAlert) {
            Alert(title: Text("Error"), message: Text(imageViewModel.alertMessage), dismissButton: .default(Text("OK")))   
        }


    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
