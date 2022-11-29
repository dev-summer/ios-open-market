//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Jiyoung Lee on 2022/11/29.
//

import UIKit

final class ListCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "listCell"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        productImageView.image = .none
        productNameLabel.text = .none
        priceLabel.attributedText = nil
        priceLabel.text = nil
        bargainPriceLabel.text = nil
        stockLabel.attributedText = nil
        stockLabel.text = .none
    }
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .left
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        label.textColor = .gray
        return label
    }()
    
    private let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        label.textColor = .gray
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .right
        label.textColor = .gray
        return label
    }()
    
    private let disclosureButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(systemName: "chevron.forward")
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    private let priceStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()
    
    private func configureUI() {
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(bargainPriceLabel)
        
        contentView.addSubview(productImageView)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(priceStackView)
        contentView.addSubview(stockLabel)
        contentView.addSubview(disclosureButton)
        
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 3),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productNameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 2),
            productNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            priceStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 2),
            priceStackView.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor),
            stockLabel.leadingAnchor.constraint(greaterThanOrEqualTo: productNameLabel.trailingAnchor, constant: 5),
            stockLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            disclosureButton.leadingAnchor.constraint(equalTo: stockLabel.trailingAnchor, constant: 3),
            disclosureButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            disclosureButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            disclosureButton.widthAnchor.constraint(equalTo: disclosureButton.heightAnchor)
        ])
    }
    
    func updateContents(_ product: Product) {
        DispatchQueue.global().async {
            guard let url = URL(string: product.thumbnailURL),
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.productImageView.image = image
                self.productNameLabel.text = product.name
                self.updatePriceLabel(product)
                self.updateStockLabel(product)
            }
        }
    }
    
    private func updatePriceLabel(_ product: Product) {
        let price: String = Formatter.format(product.price, product.currency)
        let bargainPrice: String = Formatter.format(product.bargainPrice, product.currency)
        priceLabel.attributedText = NSAttributedString(string: price)
        bargainPriceLabel.attributedText = NSAttributedString(string: bargainPrice)
        bargainPriceLabel.isHidden = product.price == product.bargainPrice

        if product.price != product.bargainPrice {
            priceLabel.attributedText = price.invalidatePrice()
        }
    }
    
    private func updateStockLabel(_ product: Product) {
        guard product.stock > 0 else {
            stockLabel.text = "품절"
            stockLabel.attributedText = stockLabel.text?.markSoldOut()
            return
        }
        
        stockLabel.text = "잔여수량 : \(product.stock)"
    }
}