//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import Foundation
import UIKit

class CategorySelectionViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(makeWelcomeLabel())
        stackView.addArrangedSubview(makeColoradoLabel())
        stackView.addArrangedSubview(makeLogoImageView())
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            //stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
        ])
        view = containerView
    }
    
    func makeWelcomeLabel() -> UILabel {
        let label = UILabel()
        label.text = "Welcome To:"
        return label
    }
    
    func makeColoradoLabel() -> UILabel {
        let label = UILabel()
        label.text = "Colorado"
        return label
    }
    
    func makeLogoImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        return imageView
    }
    
}
