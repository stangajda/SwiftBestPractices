//
//  MovieDetailViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//
import Foundation
import Combine

protocol MovieDetailViewModelProtocol: LifecycleProtocol, ObservableLoadableProtocol
    where GENERIC_REQ_TYPE == Int, GENERIC_RES_TYPE == MovieDetailViewModel.MovieDetailItem  {
    var movieList: MoviesListViewModel.MovieItem { get }
}

// MARK: - ViewDetailViewModel
final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    @Published fileprivate(set) var state: State
    @Injected fileprivate var service: MovieDetailServiceProtocol
    var statePublisher: Published<State>.Publisher

    typealias GENERIC_REQ_TYPE = Int
    typealias GENERIC_RES_TYPE = MovieDetailItem

    var input = PassthroughSubject<Action, Never>()
    var movieList: MoviesListViewModel.MovieItem

    fileprivate var cancellable: AnyCancellable?
    fileprivate static var movieListId: Int = 0

    static var instances: [Int: MovieDetailViewModel] = [:]

    static func instance(_ movieList: MoviesListViewModel.MovieItem) -> MovieDetailViewModel {
        movieListId = movieList.id
        if let instance = instances[movieListId] {
            return instance
        } else {
            let instance = MovieDetailViewModel(movieList)
            instances[movieList.id] = instance
            return instance
        }
    }

    static func deallocateCurrentInstances() {
        instances.removeValue(forKey: movieListId)
    }

    fileprivate init(_ movieList: MoviesListViewModel.MovieItem) {
        self.movieList = movieList
        state = State.start(movieList.id)
        statePublisher = _state.projectedValue
        self.onAppear()
    }

    deinit {
        reset()
    }

    func onAppear() {
        cancellable = self.assignNoRetain(self, to: \.state)
        send(action: .onAppear)
    }

    func onDisappear() {
        reset()
    }

    fileprivate func reset() {
        cancellable?.cancel()
        Self.deallocateCurrentInstances()
    }
}

// MARK: - Fetch
extension MovieDetailViewModel {
    func fetch() -> AnyPublisher<MovieDetailItem, Error> {
        let url = APIUrlBuilder[MoviePath(movieList.id)]
        let urlRequest = URLRequest(url: url).get()
        return self.service.fetchMovieDetail(urlRequest)
            .map { item in
                MovieDetailItem(item)
            }
            .eraseToAnyPublisher()
    }
}

extension MovieDetailViewModel {
    struct MovieDetailItem: Identifiable, Hashable {
        let id: Int
        let title: String
        let overview: String
        let backdropPath: String
        let voteAverage: Double
        let voteCount: Int
        var budget: String
        var releaseDate: String
        var genres: [String]
        var spokenLanguages: String
        init(_ movie: MovieDetail) {
            id = movie.id
            title = movie.title
            overview = movie.overview
            backdropPath = movie.backdropPath
            voteAverage = movie.voteAverage.halfDivide()
            voteCount = movie.voteCount
            budget = movie.budget.formatNumber()
            releaseDate = movie.releaseDate.toStringDate()
            genres = movie.genres.getNameOnly()
            spokenLanguages = movie.spokenLanguages.groupValues()
        }
    }
}
