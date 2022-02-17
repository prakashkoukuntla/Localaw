//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import Foundation
import UIKit
import CoreData

class CategorySelectionViewController: UIViewController {
    lazy var numberSelectedLabel = makeNumberSelectedLabel()
    var categorySelectionView = CategorySelectionView()
    let database: Database
    
    init(database: Database) {
        self.database = database
        super.init(nibName: nil, bundle: nil)
        categorySelectionView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(handleBillsUpdated(_:)), name: .billsUpdated, object: nil)
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
        stackView.addArrangedSubview(numberSelectedLabel)
        stackView.addArrangedSubview(SpacerView())
        stackView.addArrangedSubview(makeContinueButton())

        containerView.embed(view: stackView,
                            padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        view = containerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        categorySelectionView.applyInitialSnapshot()
    }

    func makeWelcomeLabel() -> UILabel {
        let label = UILabel()
        label.text = "Welcome To:"
        return label
    }

    func makeContinueButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.addAction(.init(handler: { [weak self] _ in
            guard let self = self else { return }
            let categories = Array(self.categorySelectionView.selectedCategories)
            UserDefaults.standard.set(categories, forKey: "selectedCategories")
            self.dismiss(animated: true, completion: nil)
        }), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .purple
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.cornerCurve = .continuous
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 120),
            button.heightAnchor.constraint(equalToConstant: 44)
            // button.leadingAnchor.constraint(equalToConstant: 110),
            // button.widthAnchor.constraint(equalToConstant: 110),
        ])
        return button
    }

    func makeNumberSelectedLabel() -> UILabel {
        let label = UILabel()
        label.text = makeNumberSelectedLabelText(number: 0)
        return label
    }

    func makeNumberSelectedLabelText(number: Int) -> String {
        return "Number Selected: \(number)"
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
    
    @objc func handleBillsUpdated(_ notification: Notification) {
        categorySelectionView.applyInitialSnapshot()
    }

}

extension CategorySelectionViewController: CategorySelectionDelegate {
    func allCategories() -> [CDBillCategory] {
        let fetchRequest: NSFetchRequest<CDBillCategory> = CDBillCategory.fetchRequest()
        return try! database.context.fetch(fetchRequest)
    }
    
    func numberOfSelectedCategoriesChanged(to number: Int) {
        numberSelectedLabel.text = makeNumberSelectedLabelText(number: number)
    }
}
