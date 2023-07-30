//
//  Protocols.swift
//  FeedReader
//
//  Created by Stan Gajda on 29/07/2023.
//

import Foundation
import SwiftUI

protocol StyleAnyViewProtocol: ViewModifier{
}

protocol StyleAnyTextProtocol: ViewModifier{
}

protocol StyleAnyAsyncImageProtocol: ViewModifier{
}

protocol StyleAnyImageProtocol: ViewModifier{
}

protocol StyleAnyStarsVotedProtocol: ViewModifier{
}

protocol StyleAnyStarsRatingViewProtocol: ViewModifier{
}

protocol StyleAnyStarsVotedSizeProtocol: ViewModifier{
    init(maxWidth: CGFloat, maxHeight: CGFloat)
}

protocol StyleAnyOverlayProtocol: ViewModifier{
}
