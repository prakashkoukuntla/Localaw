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
    typealias DataSource = UICollectionViewDiffableDataSource<BillDetailSection, BillDetailItem>
    typealias CellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, BillDetailItem>
    var collectionView: UICollectionView
    lazy var billStatusCellRegistration = CellRegistration { cell, indexPath, item in
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = "hello"
        contentConfiguration.textProperties.color = .lightGray
        cell.contentConfiguration = contentConfiguration
    }
    
    lazy var dataSource: DataSource = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let cellProvider: DataSource.CellProvider = { [unowned self] collectionView, indexPath, item in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.billStatusCellRegistration, for: indexPath, item: item)
            return cell
        }
        return DataSource(collectionView: collectionView, cellProvider: cellProvider)
    }()
    
    init() {
        collectionView = UICollectionView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        collectionView.dataSource = dataSource
        view = collectionView
    }
    
    func applyInitialSnapshot() {
        var initialSnapshot = NSDiffableDataSourceSnapshot<BillDetailSection, BillDetailItem>()
        initialSnapshot.appendSections([.billStatus])
        initialSnapshot.appendItems([.billStatus(.init(statues: [.passed, .inDiscussion, .introduced]))])
        dataSource.apply(initialSnapshot, animatingDifferences: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyInitialSnapshot()
    }
    
}

