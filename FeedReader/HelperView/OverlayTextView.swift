//
//  OverlayTextView.swift
//  FeedReader
//
//  Created by Stan Gajda on 28/07/2021.
//

import SwiftUI

struct OverlayTextView: View {
    @State var stringArray: Array<String>
    var body: some View {
        
        HStack {
            ForEach(stringArray, id: \.self) { string in
                Text(string)
                        .padding(4.0)
                        .foregroundColor(.primary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(lineWidth: 2.0)
                        )
                        .foregroundColor(.orange)
            }
        }
    }
}

struct OverlayTextView_Previews: PreviewProvider {
    static var previews: some View {
        OverlayTextView(stringArray: ["thriller","horror","comedy"])
    }
}
