//
//  MovieDetailViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//
import Foundation
import Combine

protocol MovieDetailViewModelProtocol: ObservableLoadableProtocol where T == MovieDetailViewModel.MovieDetailItem, U == Int {
    var movieList: MoviesListViewModel.MovieItem { get }
}

final class MovieDetailViewModel: MovieDetailViewModelProtocol{
    
    @Published var state: State
    @InjectedSwinject var service: MovieDetailServiceProtocol
    
    typealias T = MovieDetailItem
    typealias U = Int
    
    var input = PassthroughSubject<Action, Never>()
    var movieList: MoviesListViewModel.MovieItem

    private var cancellables = Set<AnyCancellable>()
    
    init(movieList: MoviesListViewModel.MovieItem){
        self.movieList = movieList
        state = State.start(movieList.id)
        
        self.assignNoRetain(self, to: \.state)
            .store(in: &cancellables)
        
        onResetAction(input: input)
            .store(in: &cancellables)
        
    }
    
    deinit {
        reset()
    }
    
    lazy var reset: () -> Void = { [weak self] in
        self?.cancellables.forEach { cancellable in
            cancellable.cancel() 
        } 
    }
    
    func onResetAction(input: PassthroughSubject<MovieDetailViewModel.Action, Never>) -> AnyCancellable {
        input
            .sink(receiveValue: { [unowned self] action in
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
    var fetch: AnyPublisher<MovieDetailItem, Error> {
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

class AnyMovieDetailViewModelProtocol: MovieDetailViewModelProtocol {
    typealias ViewModel = MovieDetailViewModel
    typealias T = ViewModel.MovieDetailItem

    @Published var state: ViewModel.State
    var input: PassthroughSubject<ViewModel.Action, Never>
    var fetch: AnyPublisher<T, Error>
    var movieList: MoviesListViewModel.MovieItem

    private var cancellable: AnyCancellable?
    init<ViewModel: MovieDetailViewModelProtocol>(_ viewModel: ViewModel) {
        state = viewModel.state
        input = viewModel.input
        fetch = viewModel.fetch
        movieList = viewModel.movieList
        cancellable = self.assignNoRetain(self, to: \.state)
    }
}
