//
//  MoviesListViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//

import Foundation
import Combine

protocol MoviesListViewModelProtocol: LifecycleProtocol, ObservableLoadableProtocol
    where GENERIC_REQ_TYPE == Int, GENERIC_RES_TYPE == [MoviesListViewModel.MovieItem] {
    func onActive()
    func onBackground()
}

// MARK: - MoviesViewModel
final class MoviesListViewModel: MoviesListViewModelProtocol {
    @Published fileprivate(set) var state = State.start()
    @Injected fileprivate var service: MovieListServiceProtocol

    fileprivate(set) var statePublisher: Published<State>.Publisher

    typealias GENERIC_REQ_TYPE = Int
    typealias GENERIC_RES_TYPE = [MovieItem]

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
