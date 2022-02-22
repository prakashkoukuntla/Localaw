//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import UIKit
import CoreData
import WebKit

class RecentBillsViewController: UIViewController {

    // MARK: - Variables
    
    lazy var dataSource: UITableViewDiffableDataSource<Int, NSManagedObjectID> = {
        .init(tableView: tableView) { tableView, indexPath, id in
            let bill = self.fetchedResultsController.object(at: indexPath)
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)
            
            var configuration = UIListContentConfiguration.subtitleCell()
            configuration.text = bill.title
            configuration.secondaryText = bill.longTitle
            
            cell.accessoryType = .disclosureIndicator
            cell.contentConfiguration = configuration

            return cell
        }
    }()
    
    var tableView: UITableView
    weak var context: NSManagedObjectContext?

    /// The `fetchedResultsController` is an object that listens to changes in the CoreData managed
    /// object context and will help update the table view (via the delegate that we specify)
    lazy var fetchedResultsController: NSFetchedResultsController<CDBill> = {

        guard let context = context else {
            fatalError("If there's no context, the app should crash.")
        }

        /// A fetch request is responsible for narrowing down which data to search the database for. The first
        /// filter is by entity type (in this case `CDBill`) and we can narrow it further with a predicate.
        let fetchRequest: NSFetchRequest<CDBill> = CDBill.fetchRequest()
        fetchRequest.sortDescriptors = [.init(keyPath: \CDBill.billNum, ascending: true)]
        let controller = NSFetchedResultsController<CDBill>(fetchRequest: fetchRequest,
                                                            managedObjectContext: context,
                                                            sectionNameKeyPath: nil,
                                                            cacheName: nil)
        controller.delegate = self
        return controller
    }()

    // MARK: - Initialization

    init(context: NSManagedObjectContext) {
        self.context = context
        self.tableView = UITableView(frame: .zero, style: .insetGrouped)

        super.init(nibName: nil, bundle: nil)
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(TextCell.self, forCellReuseIdentifier: "TextCell")

        tabBarItem.image = UIImage(systemName: "envelope.fill")
        tabBarItem.title = NSLocalizedString("recent_bills", comment: "")
        title = NSLocalizedString("recent_bills", comment: "")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View lifecycle

    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationController()

        /// Tells the fetchedResultsController to get all of the relevant `CDBills` from the data base as well as
        /// to begin monitoring for update events
        do {
            try fetchedResultsController.performFetch()
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }

    // MARK: - Configuration

    private func configureNavigationController() {
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
        //print("Filter")
    }
}

extension RecentBillsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let bill = fetchedResultsController.fetchedObjects?[indexPath.row] else { return }
        guard let websiteLink = bill.websiteLink else { return }
        let webViewController = WebViewController(url: websiteLink)
        navigationController?.pushViewController(webViewController, animated: true)
    }
}

//extension RecentBillsViewController: UITableViewDataSource {

//    func numberOfSections(in tableView: UITableView) -> Int {
//        fetchedResultsController.sections?.count ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        guard let sections = fetchedResultsController.sections else { return nil }
//        return sections[section].indexTitle ?? ""
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let sections = fetchedResultsController.sections else { return 0 }
//        return sections[section].numberOfObjects
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let bill = fetchedResultsController.object(at: indexPath)
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)
//
//        var configuration = UIListContentConfiguration.subtitleCell()
//        configuration.text = bill.title
//        configuration.secondaryText = bill.longTitle
//
//        cell.accessoryType = .disclosureIndicator
//        cell.contentConfiguration = configuration
////        let accessory = UIView()
////        accessory.backgroundColor = .yellow
////        if .random() {
////            cell.accessoryView = accessory
////        }
//
//        return cell
//    }
//}

extension RecentBillsViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        dataSource.apply(snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>)
    }
}
