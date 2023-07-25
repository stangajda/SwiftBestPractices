//
//  MovieDetailViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//
import Foundation
import Combine

protocol MovieDetailViewModelProtocol: LifecycleProtocol, ObservableLoadableProtocol where T == MovieDetailViewModel.MovieDetailItem, U == Int {
    var movieList: MoviesListViewModel.MovieItem { get }
}

//MARK:- ViewDetailViewModel
final class MovieDetailViewModel: MovieDetailViewModelProtocol{
    @Published fileprivate(set) var state: State
    @Injected fileprivate var service: MovieDetailServiceProtocol
    var statePublisher: Published<State>.Publisher
    
    typealias T = MovieDetailItem
    typealias U = Int
    
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
    
    fileprivate init(_ movieList: MoviesListViewModel.MovieItem){
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
    
    fileprivate func reset(){
        cancellable?.cancel()
        Self.deallocateCurrentInstances()
    }
}

//MARK:- Fetch
extension MovieDetailViewModel {
    func fetch() -> AnyPublisher<MovieDetailItem, Error> {
        let url = APIUrlBuilder[MoviePath(movieList.id)]
        return self.service.fetchMovieDetail(URLRequest(url: url).get())
            .map { item in
                MovieDetailItem(item)
            }
            .eraseToAnyPublisher()
    }
}

extension MovieDetailViewModel{
    struct MovieDetailItem: Identifiable, Hashable {
        let id: Int
        let title: String
        let overview: String
        let backdrop_path: String
        let vote_average: Double
        let vote_count: Int
        var budget: String
        var release_date: String
        var genres: Array<String>
        var spoken_languages: String
        init(_ movie: MovieDetail) {
            id = movie.id
            title = movie.title
            overview = movie.overview
            backdrop_path = movie.backdrop_path
            vote_average = movie.vote_average.halfDivide()
            vote_count = movie.vote_count
            budget = movie.budget.formatNumber()
            release_date = movie.release_date.toStringDate()
            genres = movie.genres.getNameOnly()
            spoken_languages = movie.spoken_languages.groupValues()
        }
    }
}
