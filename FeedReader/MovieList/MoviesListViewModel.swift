//
//  MoviesListViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//

import Foundation
import Combine

protocol MoviesListViewModelProtocol: LifecycleProtocol, ObservableLoadableProtocol where T == Array<MoviesListViewModel.MovieItem>, U == Int {
    func onActive()
    func onBackground()
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
        onAppear()
    }
    
    func onAppear() {
        cancellable = self.assignNoRetain(self, to: \.state)
        send(action: .onAppear)
    }
    
    func onDisappear() {
        send(action: .onReset)
        cancellable?.cancel()
    }
    
    func onActive() {
        onAppear()
    }
    
    func onBackground() {
        onDisappear()
    }
    
}

//MARK:- Fetch
extension MoviesListViewModel {
    func fetch() -> AnyPublisher<Array<MovieItem>, Error>{
        let url = APIUrlBuilder[TrendingPath()]
        let urlRequest = URLRequest(url: url).get()
        return self.service.fetchMovies(urlRequest)
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




