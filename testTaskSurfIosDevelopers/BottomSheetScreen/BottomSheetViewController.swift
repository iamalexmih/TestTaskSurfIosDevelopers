//
//  ViewController.swift
//  testTaskSurfIosDevelopers
//
//  Created by Алексей Попроцкий on 06.02.2023.
//

import UIKit

protocol BottomSheetViewControllerProtocol: AnyObject {
    func setLabelTry(_ text: String)
    func setLabelThinksComputer(_ text: String)
    func setLabelHumanAnswer(_ text: String)
}


class BottomSheetViewController: UIViewController {

    var presenter: PresenterProtocol!
    
    var sections: [SectionModel] = []
    var createLayout: CreateLayout = CreateLayout()
    var numbItems = 10000
    private var collectionView: UICollectionView!

    
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Стажировка в Surf"
        label.font = UIFont.systemFont(ofSize: 24, weight: .black)
        label.textColor = UIColor(named: "colorDark")
        return label
    }()
    
    
    private let labelDoYouWant: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Хочешь к нам?"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let buttonSendRequest: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отправить заявку", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(named: "colorDark")
        button.tintColor = .white
        button.layer.cornerRadius = 35
        button.addTarget(self, action: #selector(alertWindow), for: .touchUpInside)
        return button
    }()
    
    private let bottomStackViewForRequest: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        sections = MockData.shared.getSections()
        
        setupCollectionView()
        addSubviewOnView()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let indexForReverseScroll = IndexPath(item: numbItems / 2, section: 0)
        collectionView.scrollToItem(at: indexForReverseScroll, at: .left, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        ///pri
        collectionView.collectionViewLayout = createLayout.createCompositionalLayout(isLarge: true)
        
    }
}


// MARK: Constraints and addSubview

private extension BottomSheetViewController {
    
    private func addSubviewOnView() {
        view.addSubview(bottomStackViewForRequest)
        
        bottomStackViewForRequest.addArrangedSubview(labelDoYouWant)
        bottomStackViewForRequest.addArrangedSubview(buttonSendRequest)
    
        view.addSubview(collectionView)
        view.addSubview(labelTitle)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            labelTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            labelTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            buttonSendRequest.widthAnchor.constraint(equalToConstant: 220),
            
            bottomStackViewForRequest.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomStackViewForRequest.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bottomStackViewForRequest.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            bottomStackViewForRequest.heightAnchor.constraint(equalToConstant: 70),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: bottomStackViewForRequest.topAnchor, constant: -10),
        ])
    }
}



// MARK: config collection view
extension BottomSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: createLayout.createCompositionalLayout(isLarge: false))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: UICollectionViewCell.cellId)
        collectionView.register(DirecionCollectionViewCell.self,
                                forCellWithReuseIdentifier: DirecionCollectionViewCell.cellId)
        collectionView.register(SectionHeaderForOneRow.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderForOneRow.reuseId)
        
    }

    // MARK: Manage the data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return numbItems
        } else {
            return sections[section].items.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.sections[indexPath.section].type {
        case "TwoRows":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DirecionCollectionViewCell.cellId,
                                                          for: indexPath) as! DirecionCollectionViewCell
            let item = sections[indexPath.section].items[indexPath.row]
            cell.setup(title: item.direction, section: 1)
            cell.sizeToFit()
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DirecionCollectionViewCell.cellId,
                                                          for: indexPath) as! DirecionCollectionViewCell
            let indexForCirlceScroll = indexPath.row % sections[indexPath.section].items.count
            let item = sections[0].items[indexForCirlceScroll]
            cell.setup(title: item.direction, section: 0)
            cell.sizeToFit()
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: SectionHeaderForOneRow.reuseId,
                                                                         for: indexPath) as! SectionHeaderForOneRow
            sectionHeader.configHeader(textHeader: self.sections[indexPath.section].title)
            return sectionHeader
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let indexForCirlceScroll = indexPath.row % sections[indexPath.section].items.count
            let removeItem = sections[indexPath.section].items.remove(at: indexForCirlceScroll)
            sections[indexPath.section].items.insert(removeItem, at: 0)
            let index = IndexPath(item: 0, section: indexPath.section)
            collectionView.moveItem(at: indexPath, to: index)
        }
    }

   
    

}


extension BottomSheetViewController: UICollectionViewDelegateFlowLayout {
    
}

// MARK: config collection view
private extension BottomSheetViewController {
    @objc func alertWindow() {
        let alert = UIAlertController(title: "Поздравляем!", message: "Ваша заявка успешно отправлена!", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Закрыть", style: .default)
        alert.addAction(closeAction)
        present(alert, animated: true)
    }
}
