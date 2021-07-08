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
        
        let urlRequest = try! APIRequest.get(path: "Top250Movies")

        cancellable = FeedReaderApp.load(request: urlRequest)
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
    
    static func load(request: URLRequest) -> AnyPublisher<Movies, Error>{
        let networkManager: Service = Service()
        return networkManager.fetchData(request)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
