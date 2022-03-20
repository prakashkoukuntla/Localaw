//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import Foundation
import UIKit
import CoreData

protocol CategorySelectionDelegate: AnyObject {
    func numberOfSelectedCategoriesChanged(to number: Int)
    func allCategories() -> [CDBillCategory]
}

class CategorySelectionView: UIView {
    var selectAllView: UIView
    var tagView: UICollectionView
    var selectedCategories = Set<String>()
    weak var delegate: CategorySelectionDelegate?

    lazy var dataSource: UICollectionViewDiffableDataSource<Int, String> = {
        .init(collectionView: tagView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Tag", for: indexPath)
            if let cell = cell as? TagCell {
                cell.label.text = itemIdentifier
                cell.isChosen = self.selectedCategories.contains(itemIdentifier)
            }
            return cell
        })
    }()

    init(selectedCategories: Set<String>) {
        self.selectedCategories = selectedCategories
        selectAllView = UIView()
        let layout = LeftAlignedUICollectionViewFlowLayout()
        // layout.itemSize = .init(width: 50, height: 20)
        layout.estimatedItemSize = .init(width: 1, height: 1)
        // layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        tagView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tagView.backgroundColor = .white
        tagView.layer.borderColor = UIColor.lightGray.cgColor
        tagView.layer.borderWidth = 1
        tagView.layer.cornerRadius = 8
        tagView.layer.masksToBounds = true
        tagView.layer.cornerCurve = .continuous
        tagView.allowsMultipleSelection = true
        tagView.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        super.init(frame: .zero)
        // backgroundColor = .gray
        let stack = UIStackView(arrangedSubviews: [/*selectAllView,*/tagView])

        // re add select all view

        // embed(view: stack, width: 300, height: 300)
        embed(view: stack)
        let lessThanAnchor = tagView.heightAnchor.constraint(lessThanOrEqualToConstant: 300)
        lessThanAnchor.priority = .required
        let greaterThanAnchor = tagView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        greaterThanAnchor.priority = .required
        let heightAnchor = tagView.heightAnchor.constraint(equalToConstant: 300)
        heightAnchor.priority = .defaultLow
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 300),
            heightAnchor,
            lessThanAnchor,
            greaterThanAnchor
        ])

        tagView.delegate = self
        tagView.dataSource = dataSource
        tagView.register(TagCell.self, forCellWithReuseIdentifier: "Tag")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applyInitialSnapshot() {
        guard let categories = delegate?.allCategories() else { return }
        let categoryStrings = categories.compactMap {
            $0.cdName
        }
        let uniqueCategoryStrings = Array(Set(categoryStrings))
        var initialSnapshot = NSDiffableDataSourceSnapshot<Int, String>()
        initialSnapshot.appendSections([0])
        initialSnapshot.appendItems(uniqueCategoryStrings)

        dataSource.apply(initialSnapshot, animatingDifferences: false, completion: nil)
    }
}

extension CategorySelectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        guard let category = dataSource.itemIdentifier(for: indexPath) else { return false }
        guard let cell = collectionView.cellForItem(at: indexPath) as? TagCell else { return false }
        
        if selectedCategories.contains(category) {
            cell.isChosen = false
            selectedCategories.remove(category)
        } else {
            cell.isChosen = true
            selectedCategories.insert(category)
        }
        
        delegate?.numberOfSelectedCategoriesChanged(to: selectedCategories.count)
        
        return false
    }
}
