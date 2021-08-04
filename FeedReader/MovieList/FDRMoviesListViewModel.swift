//
//  FDRMoviesListViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//

import Foundation
import Combine
import Resolver

class FDRMoviesListViewModel: ObservableObject{
    @Published private(set) var state = State.start()
    @Injected private var service: FDRMovieListServiceInterface
    
    typealias T = Array<FDRMoviesListViewModel.MovieItem>
    typealias U = Any
    
    var input = PassthroughSubject<Action, Never>()
    
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = self.publishersSystem(state)
                        .assignNoRetain(to: \.state, on: self)
    }
    
    deinit {
        cancel()
    }
    
    func cancel(){
        cancellable?.cancel()
    }
    
}

extension FDRMoviesListViewModel: FDRLoadableProtocol{
    var fetch: AnyPublisher<T, Error>{
        let url = FDRAPIRequest.getRequest("trending/movie/day")
        guard let url = url else {
            return Fail(error: FDRAPIError.invalidURL)
                .eraseToAnyPublisher()
        }
        return self.service.fetchMovies(URLRequest(url: url).get())
            .map { item in
                item.results.map(MovieItem.init)
            }
            .eraseToAnyPublisher()
    }
}

extension FDRMoviesListViewModel {
    struct MovieItem: Identifiable {
        let id: Int
        let title: String
        let poster_path: String
        
        init(_ movie: FDRMovie) {
            id = movie.id
            title = movie.title
            poster_path = movie.poster_path
        }
    }
}
