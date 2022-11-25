//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Jiyoung Lee on 2022/11/23.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "gridCell"

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(stackView)
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        productNameLabel.text = nil
        priceLabel.text = nil
        discountedPriceLabel.text = nil
        stockLabel.text = nil
    }
    
    private lazy var productImageView: UIImageView = {
        let productImage: UIImageView = UIImageView()
        productImage.contentMode = .scaleAspectFill
        productImage.clipsToBounds = true
        productImage.translatesAutoresizingMaskIntoConstraints = false
        productImage.layer.cornerRadius = 5
        return productImage
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    private lazy var discountedPriceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    private lazy var stockLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(priceLabel)
        stack.addArrangedSubview(discountedPriceLabel)

        return stack
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(productImageView)
        stack.addArrangedSubview(productNameLabel)
        stack.addArrangedSubview(priceStackView)
        stack.addArrangedSubview(stockLabel)
  
        return stack
    }()
    
    private func configureUI() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            productImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.95),
            productImageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.6),
            productNameLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.1),
            priceLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.1),
            discountedPriceLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.1),
            stockLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.1)
        ])
    }

    func updateContents(_ product: Product) {
        var image: UIImage?
        guard let thumbnailURL = URL(string: product.thumbnailURL) else { return }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: thumbnailURL) else { return }
            DispatchQueue.main.async {
                image = UIImage(data: data)
                self.productImageView.image = image
            }
        }
        
        productNameLabel.text = product.name
        priceLabel.text = product.currency.rawValue + " \(product.price)"
        discountedPriceLabel.text = product.currency.rawValue + " \(product.discountedPrice)"
        stockLabel.text = "잔여수량 : \(product.stock)"
    }
    
    // TODO: - 할인가격, 품절 등 함수로 빼서 처리
}
