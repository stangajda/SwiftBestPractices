//
//  FDRErrorView.swift
//  FeedReader
//
//  Created by Stan Gajda on 16/07/2021.
//

import SwiftUI

struct FDRErrorView: View {
    let error: Error
    
    var body: some View {
        VStack {
            Text("An Error Occured")
                .font(.headline)
                .minimumScaleFactor(0.5)
                .lineLimit(2)
                .padding(.bottom)
            Text(error.localizedDescription)
                .font(.callout)
                .minimumScaleFactor(0.5)
                .lineLimit(2)
                .padding(.bottom)
        }
    }
}

#if DEBUG
struct FDRErrorView_Previews: PreviewProvider {
    static var previews: some View {
        FDRErrorView(error: NSError(domain: "", code: 0, userInfo: [
                                        NSLocalizedDescriptionKey: "Something went wrong"])).frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}
#endif
