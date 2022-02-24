//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import UIKit
import CoreData
import WebKit

class RecentBillsDataSource: UITableViewDiffableDataSource<Int, NSManagedObjectID> {
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
                                                            sectionNameKeyPath: "category.cdName",
                                                            cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
    init(context: NSManagedObjectContext, tableView: UITableView, delegate: NSFetchedResultsControllerDelegate) {
        self.context = context
        super.init(tableView: tableView, cellProvider: {tableView, cell, id in
            let bill = self.fetchedResultsController.object(at: indexPath)
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)
            
            var configuration = UIListContentConfiguration.subtitleCell()
            configuration.text = bill.title
            configuration.secondaryText = bill.longTitle
            
            cell.accessoryType = .disclosureIndicator
            cell.contentConfiguration = configuration

            return cell
        })
        fetchedResultsController.delegate = delegate
        /// Tells the fetchedResultsController to get all of the relevant `CDBills` from the data base as well as
        /// to begin monitoring for update events
        do {
            try fetchedResultsController.performFetch()
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        fetchedResultsController.sectionIndexTitles[section]
    }
}

class RecentBillsViewController: UIViewController {

    // MARK: - Variables
    
    lazy var dataSource: RecentBillsDataSource = {
        .init(context: context, tableView: tableView)
    }()
    
    var tableView: UITableView
    weak var context: NSManagedObjectContext?

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
    }
}

extension RecentBillsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let bill = fetchedResultsController.fetchedObjects?[indexPath.row] else { return }
        guard let websiteLink = bill.websiteLink else { return }
        let webViewController = WebViewController(url: websiteLink)
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [.init(style: .normal, title: "Save", handler: { (action, view, callback) in
            guard let bill = self.fetchedResultsController.fetchedObjects?[indexPath.row] else {
                callback(false)
                return
            }
            bill.saved = true
        })])
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
}

extension RecentBillsViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        dataSource.apply(snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>)
    }
}
