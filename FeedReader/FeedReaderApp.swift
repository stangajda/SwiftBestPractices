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
        
        let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_66zz106x")!

        cancellable = FeedReaderApp.load(url: url)
//            .print("received", to: nil)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
            }, receiveValue: { data in
                //guard let response = String(data: data, encoding: .utf8) else { return }
                print(data.items[0].title)
            })
    }
    
    static func load(url: URL) -> AnyPublisher<Movies, Error>{
        let networkManager: Service = Service()
        return networkManager.fetchData(url)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
