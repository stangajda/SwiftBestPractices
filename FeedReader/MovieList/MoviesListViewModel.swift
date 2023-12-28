//
//  MoviesListViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//

import Foundation
import Combine

protocol MoviesListViewModelProtocol: LifecycleProtocol, ObservableLoadableProtocol
    where TP1 == [MoviesListViewModel.MovieItem], TP2 == Int {
    func onActive()
    func onBackground()
}

// MARK: - MoviesViewModel
final class MoviesListViewModel: MoviesListViewModelProtocol {
    @Published fileprivate(set) var state = State.start()
    @Injected fileprivate var service: MovieListServiceProtocol

    fileprivate(set) var statePublisher: Published<State>.Publisher

    typealias TP1 = [MovieItem]
    typealias TP2 = Int

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

// MARK: - Fetch
extension MoviesListViewModel {
    func fetch() -> AnyPublisher<[MovieItem], Error> {
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
        let posterPath: String
        let voteAverage: Double
        let voteCount: Int
        init(_ movie: Movie) {
            id = movie.id
            title = movie.title
            posterPath = movie.posterPath
            voteAverage = movie.voteAverage.halfDivide()
            voteCount = movie.voteCount
        }
    }
}
