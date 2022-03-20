//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import Foundation
import UIKit
import CoreData

class CategorySelectionViewController: UIViewController {
    lazy var numberSelectedLabel = makeNumberSelectedLabel()
    var categorySelectionView: CategorySelectionView
    weak var context: NSManagedObjectContext?
    var selectedCategories: Set<String>
    var loadingIndicator = UIActivityIndicatorView(style: .large)

    init(context: NSManagedObjectContext, selectedCategories: Set<String>) {
        self.context = context
        self.categorySelectionView = CategorySelectionView(selectedCategories: selectedCategories)
        self.selectedCategories = selectedCategories
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
        if UserDefaults.standard.array(forKey: "selectedCategories") == nil {
            stackView.addArrangedSubview(makeWelcomeLabel())
            stackView.addArrangedSubview(makeNameLabel())
            stackView.addArrangedSubview(makeLogoImageView())
            stackView.addArrangedSubview(makeDescriptionLabel())
        } else {
            // stackView.addArrangedSubview(SpacerView()) //SPACER VIEW DOES NOT WORK
            stackView.addArrangedSubview(makeBadSpacer())
            stackView.addArrangedSubview(makeNameLabel())
            stackView.addArrangedSubview(makeLogoImageView())
            stackView.addArrangedSubview(makeSecondDescriptionLabel())
        }
        stackView.addArrangedSubview(categorySelectionView)
        stackView.addArrangedSubview(numberSelectedLabel)
        stackView.addArrangedSubview(SpacerView())
        stackView.addArrangedSubview(makeContinueButton())
        
        stackView.addSubview(loadingIndicator)
        
        containerView.embed(view: stackView,
                            padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        view = containerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        categorySelectionView.applyInitialSnapshot()
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: categorySelectionView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: categorySelectionView.centerYAnchor)
        ])

        loadingIndicator.startAnimating()
    }

    func makeWelcomeLabel() -> UILabel {
        let label = UILabel()
        label.text = "Welcome To:"
        return label
    }

    func makeContinueButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .legalPurple
        button.setTitle("Continue", for: .normal)
        button.addAction(.init(handler: { [weak self] _ in
            guard let self = self else { return }
            let categories = Array(self.categorySelectionView.selectedCategories)
            UserDefaults.standard.set(categories, forKey: "selectedCategories")
            NotificationCenter.default.post(name: .categoriesUpdated, object: categories)
            self.dismiss(animated: true, completion: nil)
        }), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
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
        label.text = makeNumberSelectedLabelText(number: selectedCategories.count)
        return label
    }

    func makeNumberSelectedLabelText(number: Int) -> String {
        return "Number Selected: \(number)"
    }

    func makeNameLabel() -> UILabel {
        let label = UILabel()
        label.text = "Localaw"
        return label
    }

    func makeBadSpacer() -> UILabel {
        let label = UILabel()
        label.text = "\n"
        return label
    }

    func makeLogoImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "InvertedLogo")
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

    func makeSecondDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.text = "Select bill categories you're interested in:"
        label.numberOfLines = 0
        return label
    }

    @objc func handleBillsUpdated(_ notification: Notification) {
        categorySelectionView.applyInitialSnapshot()
        loadingIndicator.stopAnimating()
    }
}

extension CategorySelectionViewController: CategorySelectionDelegate {
    
    func allCategories() -> [CDBillCategory] {
        let fetchRequest: NSFetchRequest<CDBillCategory> = CDBillCategory.fetchRequest()
        return (try? context?.fetch(fetchRequest)) ?? []
    }

    func numberOfSelectedCategoriesChanged(to number: Int) {
        numberSelectedLabel.text = makeNumberSelectedLabelText(number: number)
    }
}

extension Notification.Name {
    static let categoriesUpdated = Notification.Name("categoriesUpdated")
}
