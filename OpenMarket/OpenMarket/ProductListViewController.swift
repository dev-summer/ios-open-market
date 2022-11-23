//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

// TODO: - 데이터 받아오기
class ProductListViewController: UIViewController {
    
    private var gridCollectionView: UICollectionView!
    private let gridCellIdentifier: String = "gridCell"
    private var products: [Product] = [] {
        didSet {
            gridCollectionView.reloadData()
        }
    }
    private var dummy: [String] = ["a", "b", "c", "d", "e"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGridCollectionView()
        
        gridCollectionView.delegate = self
        gridCollectionView.dataSource = self
        gridCollectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: gridCellIdentifier)
        view.addSubview(gridCollectionView ?? UICollectionView())

        // 네트워크 매니저가 request -> escaping이고, async 하게 수행된다
        // request가 끝나고 나서! products에 product를 넣고,
        // 그 이후에 셀을 만들어서 빼도록 해야한다.
        let networkManager = NetworkManager()
        networkManager.request(endpoint: OpenMarketAPI.productList(pageNumber: 1, itemsPerPage: 100), dataType: ProductList.self) { result in
            switch result {
            case .success(let productList):
                print("성공")
                DispatchQueue.main.async {
                    self.products = productList.products
                }
            case .failure(let error):
                print("실패")
                print(error)
            }
        }
        
    }
    
    func configureGridCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let halfWidth: CGFloat = UIScreen.main.bounds.width / 2.0
        let itemHeight: CGFloat = UIScreen.main.bounds.height / 3.8
        layout.itemSize = CGSize(width: halfWidth, height: itemHeight)
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 15
        
        gridCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        gridCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(gridCollectionView)
        gridCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        gridCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        gridCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        gridCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
    }
}

extension ProductListViewController: UICollectionViewDelegate {
    
}

extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: GridCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: gridCellIdentifier, for: indexPath) as? GridCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let product: Product = products[indexPath.item]
        let thumbnailURL = URL(string: product.thumbnailURL)
        var image: UIImage?
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: thumbnailURL!)
            DispatchQueue.main.async {
                image = UIImage(data: data!)
                cell.productImage.image = image
            }
        }
        cell.productNameLabel.text = product.name
//        cell.productNameLabel.text = dummy[indexPath.item]
        
        return cell
    }
    
    
}


