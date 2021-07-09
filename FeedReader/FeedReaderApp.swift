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
        
//        let urlRequest = APIRequest["Top250Movies"].get()
//
//        cancellable = FeedReaderApp.load(request: urlRequest)
////            .print("received", to: nil)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                    case .finished:
//                        break
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    }
//            }, receiveValue: { data in
//                //guard let response = String(data: data, encoding: .utf8) else { return }
//                print(data.items[0].image)
//            })
        
        let urlString = "https://imdb-api.com/images/original/MV5BMDFkYTc0MGEtZmNhMC00ZDIzLWFmNTEtODM1ZmRlYWMwMWFmXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_Ratio0.6716_AL_.jpg"
        
        let request = URLRequest(url: URL(string: urlString)!)
        cancellable = FeedReaderApp.loadImage(request: request)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                            case .finished:
                                break
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                    }, receiveValue: { image in
                        //guard let response = String(data: data, encoding: .utf8) else { return }
                        print(image)
                    })
    }
    
    static func load(request: URLRequest) -> AnyPublisher<Movies, Error>{
        let networkManager: Service = Service()
        return networkManager.fetchData(request)
    }
    
    static func loadImage(request: URLRequest) -> AnyPublisher<UIImage, Error>{
        let networkManager: Service = Service()
        return networkManager.fetchImage(request)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
