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
        
        let mask = StarsRatingMask(rating: rating, maxRating: maxRating)
        return stars.overlay(
            mask.addMask(stars)
                .foregroundColor(.orange)
        )
        .foregroundColor(.gray)
    }
}

struct StarsRatingMask {
    let rating: Double
    let maxRating: Int
    
    fileprivate func addMask(_ stars: HStack<ForEach<Range<Int>, Int, some View>>) -> some View {
        return GeometryReader { geometry in
            let width = CGFloat(rating) / CGFloat(maxRating) * geometry.size.width
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: width)
            }
        }
        .mask(stars)
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
