//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import UIKit
import CoreData

class RecentBillsDataSource: BillsDataSource {
    
    class func makePredicate() -> NSPredicate {
        let categories = UserDefaults.standard.array(forKey: "selectedCategories") as? [String] ?? []
        let weekAgo = Date(timeIntervalSinceNow: -60 * 60 * 24 * 17)
        return NSPredicate(format: "(SUBQUERY(summarizedHistory.date, $date, $date >= %@) .@count > 0) AND category.cdName IN %@",
                           weekAgo as NSDate,
                           categories)
    }
    
    class func makeFetchRequest() -> NSFetchRequest<CDBill> {
        let request: Request = CDBill.fetchRequest()
        request.sortDescriptors = [.init(key: "category.cdName", ascending: true), .init(key: "title", ascending: true)]
        request.predicate = makePredicate()
        return request
    }
    
    override class func makeController(context: NSManagedObjectContext) -> BillsDataSource.Controller {
        return .init(fetchRequest: makeFetchRequest(),
                     managedObjectContext: context,
                     sectionNameKeyPath: "category.cdName",
                     cacheName: nil)
    }
}

class RecentBillsViewController: BillsViewController<RecentBillsDataSource> {
    
    // MARK: - Variables
    
    override var noDataLabelText: String { return "No recent bills for the categories you've selected." }
    
    // MARK: - Initialization
    
    override init(context: NSManagedObjectContext) {
        super.init(context: context)
        
        tabBarItem.image = UIImage(systemName: "envelope.fill")
        tabBarItem.title = NSLocalizedString("recent_bills", comment: "")
        title = NSLocalizedString("recent_bills", comment: "")
        
        handleNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    override func configureNavigationController() {
        super.configureNavigationController()
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
        let categories = UserDefaults.standard.array(forKey: "selectedCategories") as? [String] ?? []
        let categorySelectionViewController = CategorySelectionViewController(context: context, selectedCategories: Set(categories))
        present(categorySelectionViewController, animated: true, completion: nil)
    }
}

extension RecentBillsViewController {
    
    func handleNotifications() {
        NotificationCenter.default.addObserver(forName: .categoriesUpdated, object: nil, queue: .main) { notification in
            self.dataSource.fetchedResultsController.fetchRequest.predicate = type(of: self.dataSource).makePredicate()
            try? self.dataSource.fetchedResultsController.performFetch()
        }
    }
}
