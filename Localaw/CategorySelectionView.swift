//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import Foundation
import UIKit

class CategorySelectionView: UIView {
    var selectAllView: UIView
    var tagView: UICollectionView
    
    init() {
        selectAllView = UIView()
        let layout = UICollectionViewFlowLayout()
        tagView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: .zero)
        backgroundColor = .gray
        let stack = UIStackView(arrangedSubviews: [selectAllView, tagView])
        embed(view: stack, width: 300, height: 300)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
