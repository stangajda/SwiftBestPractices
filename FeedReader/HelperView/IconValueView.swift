//
//  LabeledValue.swift
//  FeedReader
//
//  Created by Stan Gajda on 28/07/2021.
//

import SwiftUI

struct IconValueView: View {
    @State var iconName: String
    @State var textValue: String
    var body: some View {
        HStack(spacing:8){
            Image(systemName: iconName )
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.orange)
                .frame(maxWidth: 30, maxHeight: 20, alignment: .leading)
            Text(textValue)
                .font(.callout)
        }
    }
}

struct IconValueView_Previews: PreviewProvider {
    static var previews: some View {
        IconValueView(iconName: "banknote", textValue: "17,000,000")
    }
}