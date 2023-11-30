//
//  ErrorView.swift
//  FeedReader
//
//  Created by Stan Gajda on 16/07/2021.
//

import SwiftUI
import PreviewSnapshots

struct ErrorView: View {
    let error: Error

    var body: some View {
        VStack {
            Text("An Error Occured")
                .withTextStyle(ErrorViewTitleStyle())
            Text(error.localizedDescription)
                .withTextStyle(ErrorViewDescriptionStyle())
        }
        .padding()
    }
}

#if DEBUG
struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        snapshots.previews.previewLayout(.sizeThatFits)
    }
    static var snapshots: PreviewSnapshots<Any> {
        return PreviewSnapshots(
            configurations: [
                .init()
            ],
            configure: { _ in
                ErrorView(error: NSError(domain: "", code: 0, userInfo: [
                                            NSLocalizedDescriptionKey: "Something went wrong"]))
            }
        )
    }
}
#endif
