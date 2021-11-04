//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem.image = UIImage(systemName: "gearshape.fill")
        tabBarItem.title = NSLocalizedString("settings", comment: "")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        // Do any additional setup after loading the view.
    }
    


}

