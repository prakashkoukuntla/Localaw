//
//  Copyright © 2022 Prakash Koukuntla. All rights reserved.
//
import Foundation
import UIKit

struct SummaryItem: Hashable, Identifiable {
    let id = UUID()
    var content: String
}

struct BillStatus: Hashable, Identifiable {
    let id = UUID()
    var statues: [Status]
    
    enum Status {
        case introduced
        case passed
        case signed
        case inDiscussion
    }
}

enum BillDetailSection: Int, CaseIterable, Comparable {
    case billStatus
    case header
    case summary
    case sponsors
    case committees
    case content
    
    static func < (lhs: BillDetailSection, rhs: BillDetailSection) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

enum BillDetailItem: Hashable {
    case summary(SummaryItem)
    case billStatus(BillStatus)
}

class BillDetailViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, UUID>
    
    var collectionView: UICollectionView
    override func loadView() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let cellProvider: DataSource.CellProvider { cell, indexPath, }
        collectionView.dataSource = DataSource(collectionView: collectionView, cellProvider: <#T##UICollectionViewDiffableDataSource<Int, UUID>.CellProvider##UICollectionViewDiffableDataSource<Int, UUID>.CellProvider##(UICollectionView, IndexPath, UUID) -> UICollectionViewCell?#>)
    }
}
