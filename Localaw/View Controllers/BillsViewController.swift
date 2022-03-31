//
//  Copyright © 2022 Prakash Koukuntla. All rights reserved.
//  

import Foundation
import UIKit
import CoreData

open class BillsDataSource: UITableViewDiffableDataSource<String, NSManagedObjectID> {

    public typealias CellProvider = UITableViewDiffableDataSource<String, NSManagedObjectID>.CellProvider
    public typealias Controller = NSFetchedResultsController<CDBill>
    public typealias Request = NSFetchRequest<CDBill>

    // MARK: - Variables

    weak var context: NSManagedObjectContext?

    /// The `fetchedResultsController` is an object that listens to changes in the CoreData managed
    /// object context and will help update the table view (via the delegate that we specify)
    var fetchedResultsController: Controller

    // MARK: - Initialization

    required public init(context: NSManagedObjectContext, tableView: UITableView) {
        self.context = context
        let controller = Self.makeController(context: context)
        self.fetchedResultsController = controller
        super.init(tableView: tableView, cellProvider: Self.makeCellProvider(controller: controller))
    }

    /// Tells the fetchedResultsController to get all of the relevant `CDBills` from the
    /// database as well as to begin monitoring for update events
    func setDelegate(delegate: NSFetchedResultsControllerDelegate) {
        fetchedResultsController.delegate = delegate

        do {
            try fetchedResultsController.performFetch()
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }

    // MARK: - Factory

    open class func makeController(context: NSManagedObjectContext) -> Controller {
        fatalError("Implement in subclasses")
    }

    static func makeCellProvider(
        controller: Controller) -> CellProvider {
            return { tableView, indexPath, _ in
                
                let bill = controller.object(at: indexPath)
                let cell = tableView.dequeueReusableCell(withIdentifier: "BillCell", for: indexPath)
                
                if let cell = cell as? BillCell {
                    cell.configure(with: bill)
                }

                return cell
            }
        }

    // MARK: - Table view data source

    open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        fetchedResultsController.sections?[section].name
    }

    open override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        fetchedResultsController.sectionIndexTitles
    }

    public func bill(at indexPath: IndexPath) -> CDBill? {
        let sectionInfo = fetchedResultsController.sections?[indexPath.section]
        return sectionInfo?.objects?[indexPath.row] as? CDBill
    }
}

/// Abstract class that contains shared functionality for both the RecentBills and SavedBills
/// view controllers.
open class BillsViewController<DataSource: BillsDataSource>: UIViewController, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    // MARK: - Variables

    weak var context: NSManagedObjectContext?
    var dataSource: DataSource
    var tableView = UITableView(frame: .zero, style: .insetGrouped)

    // MARK: - Initialization

    init(context: NSManagedObjectContext) {
        self.context = context
        self.dataSource = .init(context: context, tableView: tableView)
        super.init(nibName: nil, bundle: nil)
        dataSource.setDelegate(delegate: self)

        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(BillCell.self, forCellReuseIdentifier: "BillCell")
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View lifecycle

    open override func loadView() {
        view = tableView
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationController()
    }

    open func configureNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - UITableViewDelegate

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let bill = dataSource.bill(at: indexPath) else { return }
        guard let websiteLink = bill.websiteLink else { return }
        let webViewController = WebViewController(url: websiteLink)
        navigationController?.pushViewController(webViewController, animated: true)
    }

    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        guard let bill = self.dataSource.bill(at: indexPath) else {
            return nil
        }

        let action = UIContextualAction(style: .normal, title: nil, handler: { _, _, callback in
            bill.saved.toggle()
            try? self.context?.save()
            callback(true)
        })
        action.image = bill.saved ? UIImage(systemName: "bookmark.slash.fill") : UIImage(systemName: "bookmark.fill")
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }

    // MARK: - NSFetchedResultsControllerDelegate
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        dataSource.apply(snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>)
    }
}
