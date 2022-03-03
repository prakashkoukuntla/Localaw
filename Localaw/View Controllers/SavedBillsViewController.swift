//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//

import UIKit
import CoreData
import WebKit

class SavedBillsDataSource: BillsDataSource {

    override class func makeController(context: NSManagedObjectContext) -> Controller {
        let fetchRequest: NSFetchRequest<CDBill> = CDBill.fetchRequest()
        fetchRequest.sortDescriptors = [.init(keyPath: \CDBill.billNum, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "saved == YES")
        return Controller(fetchRequest: fetchRequest,
                                                  managedObjectContext: context,
                                                  sectionNameKeyPath: "category.cdName",
                                                  cacheName: nil)
    }
}

class SavedBillsViewController: BillsViewController<SavedBillsDataSource> {

    // MARK: - Initialization

    override init(context: NSManagedObjectContext) {
        super.init(context: context)

        tabBarItem.image = UIImage(systemName: "bookmark.fill")
        tabBarItem.title = NSLocalizedString("saved_bills", comment: "")
        title = NSLocalizedString("saved_bills", comment: "")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View lifecycle

    override func loadView() {
        view = tableView
    }

    // MARK: - Configuration

    override func configureNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
