//
//  MockImageViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 23/07/2021.
//

import Foundation
import UIKit

class MockImageViewModel: ImageViewModel{
    override var state: State{
        guard let image = UIImage(named: "StubImageMovieMedium") else {
                return .start
        }
        let imageItem: ImageItem = ImageItem(image)
        return .loaded(imageItem)
    }
    
    init(){
        super.init(imageURL: "mockUrl")
    }
}
