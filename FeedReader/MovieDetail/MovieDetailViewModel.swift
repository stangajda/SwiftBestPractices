//
//  MovieDetailViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//
import Foundation
import Combine
import Resolver


protocol  MovieDetailViewModelProtocol {
    var state: MovieDetailViewModel.State { get }
    var input: PassthroughSubject<MovieDetailViewModel.Action, Never> { get }
    var movieList: MoviesListViewModel.MovieItem { get }
}


class MovieDetailViewModel: ObservableObject{
    @Published private(set) var state: State
    @Injected var service: MovieDetailServiceProtocol
    
    typealias T = MovieDetailViewModel.MovieDetailItem
    typealias U = Int
    
    var input = PassthroughSubject<Action, Never>()
    var movieList: MoviesListViewModel.MovieItem

    private var cancellables = Set<AnyCancellable>()
    
    init(movieList: MoviesListViewModel.MovieItem){
        self.movieList = movieList
        state = State.start(movieList.id)
        self.publishersSystem(state)
            .assignNoRetain(to: \.state, on: self)
                .store(in: &cancellables)
        
        onResetAction(input: input)
            .store(in: &cancellables)
        
    }
    
    deinit {
        reset()
    }
    
    lazy var reset: () -> Void = { [self] in
        cancellables.forEach { cancellable in
            cancellable.cancel() 
        } 
    }
    
    func onResetAction(input: PassthroughSubject<MovieDetailViewModel.Action, Never>) -> AnyCancellable {
        input
            .sink(receiveValue: { [self] action in
                switch action {
                case .onReset:
                    reset()
                default:
                    break
                }
            })
    }
    
}

extension MovieDetailViewModel: LoadableProtocol {
    var fetch: AnyPublisher<T, Error> {
        guard let url = APIUrlBuilder[MoviePath(movieList.id)] else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        return self.service.fetchMovieDetail(URLRequest(url: url).get())
            .map { item in
                MovieDetailItem(item)
            }
            .eraseToAnyPublisher()
    }
}

extension MovieDetailViewModel{
    struct MovieDetailItem {
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
            release_date = movie.release_date.formatDate()
            genres = movie.genres.getNameOnly()
            spoken_languages = movie.spoken_languages.groupValues()
        }
    }
}
