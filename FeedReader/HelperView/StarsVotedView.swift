//
//  starsVotedView.swift
//  FeedReader
//
//  Created by Stan Gajda on 28/07/2021.
//

import SwiftUI
import PreviewSnapshots

struct StarsVotedView: View {
    @State private var maxRating = 5
    @State var rating: Double
    @State var voteCount: Int
    
    var body: some View {
        HStack(){
            StarsRatingView(rating: rating, maxRating: maxRating)
                .frame(maxWidth: 120, maxHeight: 20.0, alignment: .leading)
            Text("(\(voteCount))")
        }
    }
}

#if DEBUG
struct StarsVotedView_Previews: PreviewProvider {
    static var previews: some View {
        snapshots.previews.previewLayout(.sizeThatFits)
    }
    static var snapshots: PreviewSnapshots<Any> {
        return PreviewSnapshots(
            configurations: [
                .init()
            ],
            configure: { _ in
                StarsVotedView(rating: 8.5, voteCount: 100)
            }
        )
    }
}
#endif
