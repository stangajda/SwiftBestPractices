//
//  StarsRatingView.swift
//  FeedReader
//
//  Created by Stan Gajda on 27/07/2021.
//

import SwiftUI

struct FDRStarsRatingView: View {
    var rating: Double
    var maxRating: Int

    var body: some View {
        let stars = HStack(spacing: 2) {
            ForEach(0..<maxRating) { _ in
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }

        stars.overlay(
            GeometryReader { geometry in
                let width = CGFloat(rating) / CGFloat(maxRating) * geometry.size.width
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: width)
                        .foregroundColor(.orange)
                }
            }
            .mask(stars)
        )
        .foregroundColor(.gray)
    }
}

#if DEBUG
struct DRStarsRatingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FDRStarsRatingView(rating: 2.7, maxRating: 5).preferredColorScheme(.dark)
            FDRStarsRatingView(rating: 2.7, maxRating: 5)
        }
    }
}
#endif
