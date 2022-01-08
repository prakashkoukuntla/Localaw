//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import Foundation
import UIKit

class CategorySelectionViewController: UIViewController {
    
    var categorySelectionView = CategorySelectionView()
    
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
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.addArrangedSubview(makeWelcomeLabel())
        stackView.addArrangedSubview(makeColoradoLabel())
        stackView.addArrangedSubview(makeLogoImageView())
        stackView.addArrangedSubview(makeDescriptionLabel())
        stackView.addArrangedSubview(categorySelectionView)
        
        containerView.embed(view: stackView,
                            padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        view = containerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categorySelectionView.applyInitialSnapshot()
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
    
    func makeDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.text = "Learn about your community's legislation. To get started, select bill categories you're interested in:"
        label.numberOfLines = 0
        return label
    }
    
}
