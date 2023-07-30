//
//  StarsRatingView.swift
//  FeedReader
//
//  Created by Stan Gajda on 27/07/2021.
//

import SwiftUI
import PreviewSnapshots

struct StarsRatingView: View {
    let rating: Double
    let maxRating: Int
    
    var body: some View {
        let stars = HStack(spacing: 2) {
            ForEach(0..<maxRating, id: \.self) { _ in
                Image(systemName: Config.Icon.starFill)
                    .resizable()
                    .withImageStyle(StarsRatingImageStyle())
            }
        }
        
        let starsRatingMask = StarsRatingMask(rating: rating, maxRating: maxRating)
                                    .withStarsRatingViewStyle(StarsRatingMaskStyle())
        return stars.overlay(
            starsRatingMask.mask(stars)
        )
        .withViewStyle(StarsRatingOverlayStyle())
    }
}

struct StarsRatingMask: View {
    let rating: Double
    let maxRating: Int
    
    var body: some View {
        return GeometryReader { geometry in
            let width = CGFloat(rating) / CGFloat(maxRating) * geometry.size.width
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: width)
            }
        }
    }
}

#if DEBUG
struct StarsRatingView_Previews: PreviewProvider {
    static var previews: some View {
        snapshots.previews.previewLayout(.sizeThatFits)
    }
    static var snapshots: PreviewSnapshots<Any> {
        return PreviewSnapshots(
            configurations: [
                .init()
            ],
            configure: { _ in
                StarsRatingView(rating: 8.5, maxRating: 10)
            }
        )
    }
}
#endif
