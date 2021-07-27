//
//  LabeledValue.swift
//  FeedReader
//
//  Created by Stan Gajda on 28/07/2021.
//

import SwiftUI

struct LabeledValue: View {
    @State var label: String
    @State var value: String
    var body: some View {
        HStack(spacing:8){
            Text(label)
                .fontWeight(.bold)
            Text(value)
        }
    }
}

struct LabeledValue_Previews: PreviewProvider {
    static var previews: some View {
        LabeledValue(label: "label", value: "value")
    }
}
