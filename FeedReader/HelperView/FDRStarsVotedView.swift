//
//  starsVotedView.swift
//  FeedReader
//
//  Created by Stan Gajda on 28/07/2021.
//

import SwiftUI

struct FDRStarsVotedView: View {
    @State private var maxRating = 5
    @State var rating: Double
    @State var voteCount: Int
    
    var body: some View {
        HStack(){
            FDRStarsRatingView(rating: rating, maxRating: maxRating)
                .frame(maxWidth: 120, maxHeight: 20.0, alignment: .leading)
            Text("(\(voteCount))")
        }
    }
}

#if DEBUG
struct FDRStarsVotedView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FDRStarsVotedView(rating: 3.7,voteCount: 1920).preferredColorScheme(.dark)
            FDRStarsVotedView(rating: 3.7,voteCount: 1920)
        }
    }
}
#endif
