//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//

import UIKit

class SavedBillsViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem.image = UIImage(systemName: "bookmark.fill")
        tabBarItem.title = NSLocalizedString("saved_bills", comment: "")
        title = NSLocalizedString("saved_bills", comment: "")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TextCell.self, forCellReuseIdentifier: "TextCell")
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
    }
    
    @objc func isClicked(_ item: UIBarButtonItem) {
        print("hi")
    }

}

extension SavedBillsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let array = UserDefaults.standard.array(forKey: "selectedCategories") as? [String] else { return nil }
        return array[section]
    }
}

extension SavedBillsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        UserDefaults.standard.array(forKey: "selectedCategories")?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)
        if let cell = cell as? TextCell {
            cell.textLabel?.text = "hello"
        }
        return cell
    }
}
