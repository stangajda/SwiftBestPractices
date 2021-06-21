//
//  FeedReaderApp.swift
//  FeedReader
//
//  Created by Stan Gajda on 16/06/2021.
//

import SwiftUI
import Combine

@main
struct FeedReaderApp: App {
    var cancellable: AnyCancellable
    
    init(){
        let networkManager: NetworkManager = NetworkManager()
        let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_66zz106x")!

        cancellable = networkManager.fetchData(url: url)
            .print("received", to: nil)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
            }, receiveValue: { data in
                guard let response = String(data: data, encoding: .utf8) else { return }
                print(response)
            })
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
