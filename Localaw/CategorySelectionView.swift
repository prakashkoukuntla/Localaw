//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import Foundation
import UIKit

class CategorySelectionView: UIView {
    var selectAllView: UIView
    var tagView: UICollectionView
    lazy var dataSource: UICollectionViewDiffableDataSource<Int, String> = {
        UICollectionViewDiffableDataSource<Int, String>(collectionView: tagView, cellProvider: {collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Tag", for: indexPath)
            if let cell = cell as? TagCell {
                cell.label.text = itemIdentifier
                
            
            }
            return cell
        })
    }()
    
    init() {
        selectAllView = UIView()
        let layout = UICollectionViewFlowLayout()
        //layout.itemSize = .init(width: 50, height: 20)
        layout.estimatedItemSize = .init(width: 1, height: 1)
        //layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        tagView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tagView.backgroundColor = .orange
        super.init(frame: .zero)
        backgroundColor = .gray
        let stack = UIStackView(arrangedSubviews: [/*selectAllView,*/tagView])
        
        // re add select all view
        
        embed(view: stack, width: 300, height: 300)
        tagView.delegate = self
        tagView.dataSource = dataSource
        tagView.register(TagCell.self, forCellWithReuseIdentifier: "Tag")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyInitialSnapshot() {
        var initialSnapshot = NSDiffableDataSourceSnapshot<Int, String>()
        initialSnapshot.appendSections([0])
        initialSnapshot.appendItems(["Roads", "Cars", "Schools", "Other Laws", "More Stuff", "Trucks", "Buses", "Laptops", "Computers", "Cows", "Pigs", "Sheep"])
        //dataSource.apply(initialSnapshot)
        
        dataSource.apply(initialSnapshot, animatingDifferences: false, completion: nil)
    }
}

extension CategorySelectionView: UICollectionViewDelegate {
    
}
