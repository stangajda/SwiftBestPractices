//
//  MoviesListViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//

import Foundation
import Combine

protocol MoviesListViewModelProtocol: ObservableLoadableProtocol where T == Array<MoviesListViewModel.MovieItem>, U == Int {
}

//MARK:- MoviesViewModel
final class MoviesListViewModel: MoviesListViewModelProtocol {
    @Published fileprivate(set) var state = State.start()
    @Injected fileprivate var service: MovieListServiceProtocol
    
    fileprivate(set) var statePublisher: Published<State>.Publisher
    
    typealias T = Array<MovieItem>
    typealias U = Int
    
    var input = PassthroughSubject<Action, Never>()
    
    fileprivate var cancellable: AnyCancellable?
    
    init() {
        statePublisher = _state.projectedValue
        cancellable = self.assignNoRetain(self, to: \.state)
    }
    
}

//MARK:- Fetch
extension MoviesListViewModel {
    func fetch() -> AnyPublisher<Array<MovieItem>, Error>{
        
        guard let url = APIUrlBuilder[TrendingPath()] else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return self.service.fetchMovies(URLRequest(url: url).get())
            .map { item in
                item.results.map(MovieItem.init)
            }
            .eraseToAnyPublisher()
    }
}

extension MoviesListViewModel {
    struct MovieItem: Identifiable, Hashable {
        let id: Int
        let title: String
        let poster_path: String
        let vote_average: Double
        let vote_count: Int
        init(_ movie: Movie) {
            id = movie.id
            title = movie.title
            poster_path = movie.poster_path
            vote_average = movie.vote_average.halfDivide()
            vote_count = movie.vote_count
        }
    }
}




