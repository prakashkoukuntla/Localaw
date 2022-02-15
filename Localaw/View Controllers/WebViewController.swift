//
//  Copyright © 2022 Prakash Koukuntla. All rights reserved.
//  

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController {

    // MARK: - Variables

    var loadingIndicator = UIActivityIndicatorView(style: .large)
    var webView = WKWebView()
    private var url: URL?

    // MARK: - Initialization

    init(url: String) {
        self.url = URL(string: url)
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        view.addSubview(webView)
        view.addSubview(loadingIndicator)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = url else {
            dismiss(animated: true, completion: nil)
            return
        }

        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        loadingIndicator.startAnimating()

        let request = URLRequest(url: url)
        webView.navigationDelegate = self
        webView.load(request)
    }
}

extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
    }
}
