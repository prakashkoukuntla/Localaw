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
    
    var imageView: UIImageView = CategorySelectionViewController.makeLogoImageView()

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
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        if UserDefaults.standard.array(forKey: "selectedCategories") == nil {
            stackView.addArrangedSubview(makeWelcomeLabel())
            stackView.addArrangedSubview(makeNameLabel())
            stackView.addArrangedSubview(imageView)
            stackView.addArrangedSubview(makeDescriptionLabel())
        } else {
            stackView.addArrangedSubview(makeNameLabel())
            stackView.addArrangedSubview(imageView)
            stackView.addArrangedSubview(makeSecondDescriptionLabel())
        }
        stackView.addArrangedSubview(categorySelectionView)
        stackView.addArrangedSubview(numberSelectedLabel)
        stackView.addArrangedSubview(makeContinueButton())
        
        if UserDefaults.standard.bool(forKey: "wasLaunched") == false {
            stackView.addSubview(loadingIndicator)
            loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                loadingIndicator.centerXAnchor.constraint(equalTo: categorySelectionView.centerXAnchor),
                loadingIndicator.centerYAnchor.constraint(equalTo: categorySelectionView.centerYAnchor)
            ])
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 20),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 20),
            containerView.bottomAnchor.constraint(greaterThanOrEqualTo: stackView.bottomAnchor, constant: 20),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        view = containerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        categorySelectionView.applyInitialSnapshot()

        loadingIndicator.startAnimating()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        imageView.isHidden = size.height < 500
    }

    func makeWelcomeLabel() -> UILabel {
        let label = UILabel()
        label.text = "Welcome To:"
        label.font = .preferredFont(forTextStyle: .subheadline)
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
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }

    static func makeLogoImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "InvertedLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let height = imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 100)
        let width = imageView.widthAnchor.constraint(lessThanOrEqualToConstant: 100)
        
        NSLayoutConstraint.activate([
            height,
            width
        ])
        
        return imageView
    }

    func makeDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.text = "Learn about your community's legislation. To start, select bill categories you're interested in:"
        label.numberOfLines = 0
        label.textAlignment = .natural
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
