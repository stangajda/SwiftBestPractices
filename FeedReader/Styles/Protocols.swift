//
//  Protocols.swift
//  FeedReader
//
//  Created by Stan Gajda on 29/07/2023.
//

import Foundation
import SwiftUI

protocol AnyTextStyleProtocol: ViewModifier{
}

protocol AnyAsyncImageStyleProtocol: ViewModifier{
}

protocol AnyImageStyleProtocol: ViewModifier{
}

protocol AnyStarsVotedProtocol: ViewModifier{
}

protocol AnyStarsRatingViewProtocol: ViewModifier{
}

protocol AnyStarsVotedSizeProtocol: ViewModifier{
    init(maxWidth: CGFloat, maxHeight: CGFloat)
}

protocol AnyHStackStyleProtocol: ViewModifier{
}
