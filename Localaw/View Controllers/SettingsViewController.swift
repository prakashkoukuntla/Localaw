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
        navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
    }

}

extension SettingsViewController: UITableViewDelegate {

}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 2 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        default:
            return 0
        }
    }
    
    func promptForAuthorization(sender: UISwitch, center: UNUserNotificationCenter, key: String) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            DispatchQueue.main.async {
                sender.isOn = granted
                UserDefaults.standard.setValue(granted, forKey: key)
                // TODO: handle error
            }
        }
    }
    
    func promptForChangeNotificationSettings() {
        let url = URL(string: UIApplication.openSettingsURLString)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func handleNotificationToggle(key: String, sender: UISwitch) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { [unowned self] settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined:
                    promptForAuthorization(sender: sender, center: center, key: key)
                case .denied:
                    sender.isOn = false
                    promptForChangeNotificationSettings()
                case .authorized, .ephemeral, .provisional:
                    UserDefaults.standard.setValue(sender.isOn, forKey: key)
                @unknown default:
                    break
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "ToggleCell", for: indexPath)
            guard let toggleCell = cell as? ToggleCell else { return cell }
            switch indexPath.row {
            case 0:
                toggleCell.textLabel?.text = "Notify for Saved Bill Updates"
                toggleCell.toggle.isOn = UserDefaults.standard.bool(forKey: "NotifyForSaved")
                toggleCell.toggle.addAction(.init(handler: { (action) in
                    if let sender = action.sender as? UISwitch {
                        self.handleNotificationToggle(key: "NotifyForSaved", sender: sender)
                    }
                }), for: .valueChanged)
            case 1:
                toggleCell.textLabel?.text = "Notify for Recent Bill Updates"
                toggleCell.toggle.isOn = UserDefaults.standard.bool(forKey: "NotifyForRecent")
                toggleCell.toggle.addAction(.init(handler: { (action) in
                    if let sender = action.sender as? UISwitch {
                        self.handleNotificationToggle(key: "NotifyForRecent", sender: sender)
                    }
                }), for: .valueChanged)
            default:
                fatalError()
            }

        case 1:
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
        case (1, 0):
            UIApplication.shared.open(URL(string: "https://localaw.weebly.com/privacy-policy.html")!, options: [:], completionHandler: nil)
        case (1, 1):
            sendEmail()
        case (1, 2):
            UIApplication.shared.open(URL(string: "https://localaw.weebly.com")!, options: [:], completionHandler: nil)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Notifications"
        case 1:
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
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

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
