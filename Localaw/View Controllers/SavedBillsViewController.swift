//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//

import UIKit
import CoreData
import WebKit

class SavedBillsViewController: UIViewController {

    // MARK: - Variables

    lazy var dataSource: UITableViewDiffableDataSource<Int, NSManagedObjectID> = {
        .init(tableView: tableView) { tableView, indexPath, _ in
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
        fetchRequest.predicate = NSPredicate(format: "saved == YES")
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
    }
}

extension SavedBillsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let bill = fetchedResultsController.fetchedObjects?[indexPath.row] else { return }
        guard let websiteLink = bill.websiteLink else { return }
        let webViewController = WebViewController(url: websiteLink)
        navigationController?.pushViewController(webViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        .init(actions: [
            .init(style: .normal, title: "Unsave", handler: { _, _, callback in
                guard let bill = self.fetchedResultsController.fetchedObjects?[indexPath.row] else {
                    callback(false)
                    return
                }
                bill.saved = false
                callback(true)
            })
        ])
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
}

extension SavedBillsViewController: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        dataSource.apply(snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>)
    }
}
