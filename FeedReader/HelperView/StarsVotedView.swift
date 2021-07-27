//
//  starsVotedView.swift
//  FeedReader
//
//  Created by Stan Gajda on 28/07/2021.
//

import SwiftUI

struct StarsVotedView: View {
    @State private var maxRating = 5
    @State var rating: Double
    @State var voteCount: Int
    
    var body: some View {
        HStack(){
            StarsRatingView(rating: rating, maxRating: maxRating)
                .frame(maxWidth: 100, maxHeight: 20.0, alignment: .leading)
            Text("(\(voteCount))")
        }
    }
}

struct StarsVotedView_Previews: PreviewProvider {
    static var previews: some View {
        StarsVotedView(rating: 3.7,voteCount: 212)
    }
}
