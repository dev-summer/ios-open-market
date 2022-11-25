//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Jiyoung Lee on 2022/11/25.
//

import UIKit

class ListCollectionViewCell: UICollectionViewListCell {
    
    static let identifier: String = "listCell"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(productImageView)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(priceStackView)
        contentView.addSubview(stockLabel)
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
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .gray
        return label
    }()
    
    private lazy var discountedPriceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .gray
        return label
    }()
    
    private lazy var stockLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .right
        label.textColor = .gray
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(priceLabel)
        stack.addArrangedSubview(discountedPriceLabel)

        return stack
    }()
    
    private func configureUI() {
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            productImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productNameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 5),
            productNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            priceStackView.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor),
            priceStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 5),
            priceStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            stockLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stockLabel.leadingAnchor.constraint(greaterThanOrEqualTo: productNameLabel.trailingAnchor, constant: 5),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
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
}
