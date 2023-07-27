//
//  LabeledValue.swift
//  FeedReader
//
//  Created by Stan Gajda on 28/07/2021.
//

import SwiftUI
import PreviewSnapshots

struct IconValueView: View {
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
struct IconValueView_Previews: PreviewProvider {
    static var previews: some View {
        snapshots.previews.previewLayout(.sizeThatFits)
    }
    static var snapshots: PreviewSnapshots<Any> {
        return PreviewSnapshots(
            configurations: [
                .init()
            ],
            configure: { _ in
                IconValueView(iconName: "star.fill", textValue: "8.5")
            }
        )
    }
}
#endif
