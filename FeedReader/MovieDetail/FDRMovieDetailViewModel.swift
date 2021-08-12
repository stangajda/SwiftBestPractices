//
//  FDRMovieDetailViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//
import Foundation
import Combine
import Resolver

class FDRMovieDetailViewModel: ObservableObject{
    @Published private(set) var state: State
    @Injected var service: FDRMovieDetailServiceInterface
    
    typealias T = FDRMovieDetailViewModel.MovieDetailItem
    typealias U = Int
    
    var input = PassthroughSubject<Action, Never>()
    var movieList: FDRMoviesListViewModel.MovieItem
    
    private var cancellable: AnyCancellable?
    
    init(movieList: FDRMoviesListViewModel.MovieItem){
        state = State.start(movieList.id)
        self.movieList = movieList
        cancellable = self.publishersSystem(state)
            .assignNoRetain(to: \.state, on: self)
        
    }
    
    deinit {
        cancel()
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}

extension FDRMovieDetailViewModel: FDRLoadableProtocol {
    var fetch: AnyPublisher<T, Error> {
        let url = FDRAPIUrlBuilder.getUrl(.movie(movieList.id))
        guard let url = url else {
            return Fail(error: FDRAPIError.invalidURL)
                .eraseToAnyPublisher()
        }
        return self.service.fetchMovieDetail(URLRequest(url: url).get())
            .map { item in
                MovieDetailItem(item)
            }
            .eraseToAnyPublisher()
    }
}

extension FDRMovieDetailViewModel{
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
        init(_ movie: FDRMovieDetail) {
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
