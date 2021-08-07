//
//  LabeledValue.swift
//  FeedReader
//
//  Created by Stan Gajda on 28/07/2021.
//

import SwiftUI

struct FDRIconValueView: View {
    @State var iconName: String
    @State var textValue: String
    var body: some View {
        HStack(spacing:8){
            Image(systemName: iconName )
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.orange)
                .frame(maxWidth: 40, maxHeight: 25, alignment: .leading)
            Text(textValue)
                .font(.callout)
        }
        .padding(.bottom)
    }
}

#if DEBUG
struct FDRIconValueView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FDRIconValueView(iconName: "banknote", textValue: "17,000,000").preferredColorScheme(.dark)
            FDRIconValueView(iconName: "banknote", textValue: "17,000,000")
        }
    }
}
#endif
