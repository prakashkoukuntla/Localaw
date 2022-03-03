//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import UIKit
import CoreData

class RecentBillsDataSource: BillsDataSource {

    override class func makeController(context: NSManagedObjectContext) -> BillsDataSource.Controller {
            let request: Request = CDBill.fetchRequest()
            request.sortDescriptors = [.init(keyPath: \CDBill.billNum, ascending: true)]
            return .init(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "category.cdName", cacheName: nil)
    }
}

class RecentBillsViewController: BillsViewController<RecentBillsDataSource> {

    // MARK: - Initialization

    override init(context: NSManagedObjectContext) {
        super.init(context: context)

        tabBarItem.image = UIImage(systemName: "envelope.fill")
        tabBarItem.title = NSLocalizedString("recent_bills", comment: "")
        title = NSLocalizedString("recent_bills", comment: "")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    override func configureNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Filter"),
            style: .plain,
            target: self,
            action: #selector(isClicked(_:)))
        navigationItem.rightBarButtonItem?.tintColor = .legalPurple
    }

    // MARK: - Actions

    @objc func isClicked(_ item: UIBarButtonItem) {
        guard let context = context else { return }
        let categorySelectionViewController = CategorySelectionViewController(context: context)
        present(categorySelectionViewController, animated: true, completion: nil)
    }
}
