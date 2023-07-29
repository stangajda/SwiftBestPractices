//
//  Protocols.swift
//  FeedReader
//
//  Created by Stan Gajda on 29/07/2023.
//

import Foundation
import SwiftUI

protocol AnyTitleStyleProtocol: ViewModifier{
}

protocol AnyImageStyleProtocol: ViewModifier{
}

protocol AnyOverviewStyleProtocol: ViewModifier{
}

protocol AnyStarsVotedProtocol: ViewModifier{
}

protocol AnyStarsVotedSizeProtocol: ViewModifier{
    init(maxWidth: CGFloat, maxHeight: CGFloat)
}
