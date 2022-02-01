//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        title = NSLocalizedString("settings", comment: "")
        tabBarItem.image = UIImage(systemName: "gearshape.fill")
        tabBarItem.title = NSLocalizedString("settings", comment: "")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: "TextFieldCell")
        tableView.register(ToggleCell.self, forCellReuseIdentifier: "ToggleCell")
        tableView.register(TextCell.self, forCellReuseIdentifier: "TextCell")
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }

}

extension SettingsViewController: UITableViewDelegate {

}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 3 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 3
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath)
            guard let textFieldCell = cell as? TextFieldCell else { return cell }
            textFieldCell.textField.delegate = self
            textFieldCell.textField.placeholder = "example@email.com"
            textFieldCell.textField.text = UserDefaults.standard.string(forKey: "email")

        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "ToggleCell", for: indexPath)
            guard let toggleCell = cell as? ToggleCell else { return cell }
            switch indexPath.row {
            case 0:
                toggleCell.textLabel?.text = "Notify for Saved Bill Updates"
                toggleCell.toggle.isOn = UserDefaults.standard.bool(forKey: "Saved")
                toggleCell.toggle.addAction(.init(handler: { (action) in
                    if let sender = action.sender as? UISwitch {
                        UserDefaults.standard.set(sender.isOn, forKey: "Saved")
                    }
                }), for: .valueChanged)
            case 1:
                toggleCell.textLabel?.text = "Notify for Recent Bill Updates"
                toggleCell.toggle.isOn = UserDefaults.standard.bool(forKey: "Recent")
                toggleCell.toggle.addAction(.init(handler: { (action) in
                    if let sender = action.sender as? UISwitch {
                        UserDefaults.standard.set(sender.isOn, forKey: "Recent")
                    }
                }), for: .valueChanged)
            default:
                fatalError()
            }

        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Privacy Policy"
            case 1:
                cell.textLabel?.text = "App Feedback"
            case 2:
                cell.textLabel?.text = "About Us"
            default:
                fatalError()
            }
        default:
            fatalError()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (2, 0):
            UIApplication.shared.open(URL(string: "https://google.com")!, options: [:], completionHandler: nil)
        case (2, 1):
            sendEmail()
        case (2, 2):
            UIApplication.shared.open(URL(string: "https://localaw.weebly.com")!, options: [:], completionHandler: nil)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Email Information"
        case 1:
            return "Notifications"
        case 2:
            return "Other"
        default:
            return nil
        }
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UserDefaults.standard.setValue(textField.text, forKey: "email")
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["pkoukuntla1@gmail.com"])
            mail.setSubject("Localaw Feedback")
            // mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
            let alert = UIAlertController(title: "Error", message: "This device is not configured to send emails", preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
