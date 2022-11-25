//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ProductListViewController: UIViewController {

    private enum ProductListSection: Int {
        case main
    }
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["LIST", "GRID"])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private var listCollectionView: UICollectionView?
    private var gridCollectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<ProductListSection, Product>?
    private var products: [Product] = [] {
        didSet {
            configureListCollectionView()
            configureGridCollectionView()
            configureDataSource()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        self.navigationItem.titleView = segmentedControl
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add)
        segmentedControl.addTarget(self, action: #selector(changeView), for: .touchUpInside)
        self.segmentedControl.selectedSegmentIndex = 0
    }
    
    @objc private func changeView() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            gridCollectionView?.isHidden = true
            listCollectionView?.isHidden = false
        case 1:
            listCollectionView?.isHidden = true
            gridCollectionView?.isHidden = false
        default:
            gridCollectionView?.isHidden = true
            listCollectionView?.isHidden = false
        }
    }
    
    func fetchData() {
        // 네트워크 매니저가 request -> escaping이고, async 하게 수행된다
        // request가 끝나고 나서! products에 product를 넣고,
        // 그 이후에 셀을 만들어서 빼도록 해야한다.
        let networkManager = NetworkManager()
        networkManager.request(endpoint: OpenMarketAPI.productList(pageNumber: 1, itemsPerPage: 1000), dataType: ProductList.self) { result in
            switch result {
            case .success(let productList):
                DispatchQueue.main.async {
                    self.products = productList.products
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configureGridCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        gridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let gridCollectionView = gridCollectionView else { return }
        view.addSubview(gridCollectionView)
        
        gridCollectionView.delegate = self
        
        gridCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gridCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            gridCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gridCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            gridCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func configureListCollectionView() {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let listCollectionView = listCollectionView else { return }
        view.addSubview(listCollectionView)
        
        listCollectionView.delegate = self
        
        listCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            listCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            listCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            listCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func configureDataSource() {
        guard let gridCollectionView = gridCollectionView,
              let listCollectionView = listCollectionView else { return }
        gridCollectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: GridCollectionViewCell.identifier)
        listCollectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.identifier)
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            configureListDataSource(listCollectionView)
        case 1:
            configureGridDataSource(gridCollectionView)
        default:
            configureListDataSource(listCollectionView)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<ProductListSection, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(products)
        
        guard let dataSource = dataSource else { return }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureGridDataSource(_ gridCollectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource<ProductListSection, Product>(collectionView: gridCollectionView) { (collectionView, indexPath, product) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as? GridCollectionViewCell
            cell?.contentView.backgroundColor = .white
            cell?.contentView.layer.borderColor = UIColor.gray.cgColor
            cell?.contentView.layer.borderWidth = 1.0
            cell?.contentView.layer.cornerRadius = 10.0
            cell?.contentView.layer.masksToBounds = true
            cell?.updateContents(product)
            return cell
        }
    }
    
    private func configureListDataSource(_ listCollectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource<ProductListSection, Product>(collectionView: listCollectionView) {
            (collectionView, indexPath, product) -> UICollectionViewListCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath) as? ListCollectionViewCell
            cell?.accessories = [.disclosureIndicator()]
            cell?.updateContents(product)
            return cell
        }
    }
}

extension ProductListViewController: UICollectionViewDelegate {
    
}

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width / 2 - 15
        let height: CGFloat = collectionView.frame.height / 3 - 20
        return CGSize(width: width, height: height)
    }
}


