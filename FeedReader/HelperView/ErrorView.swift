//
//  ErrorView.swift
//  FeedReader
//
//  Created by Stan Gajda on 16/07/2021.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    
    var body: some View {
        VStack {
            Text("An Error Occured")
                .font(.title)
            Text(error.localizedDescription)
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(.bottom, 40)
                .padding()
        }
    }
}

#if DEBUG
struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: NSError(domain: "", code: 0, userInfo: [
            NSLocalizedDescriptionKey: "Something went wrong"]))
    }
}
#endif
