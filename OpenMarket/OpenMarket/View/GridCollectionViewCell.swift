//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Jiyoung Lee on 2022/11/23.
//

import UIKit

// TODO: - 셀 정의하기
class GridCollectionViewCell: UICollectionViewCell {
    var productImage: UIImageView!
    var productNameLabel: UILabel!
    var priceLabel: UILabel!
    var stockLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureCell()
    }
    
    // TODO: - 기본설정하는것 나중에 함수로 묶어주기
    func configureCell() {
        productImage = UIImageView()
        contentView.addSubview(productImage)
        productImage.translatesAutoresizingMaskIntoConstraints = false
        productImage.contentMode = .scaleToFill
        productImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        productImage.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        productImage.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        productNameLabel = UILabel()
        contentView.addSubview(productNameLabel)
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 10).isActive = true
        productNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        productNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        priceLabel = UILabel()
        contentView.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 5).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        stockLabel = UILabel()
        contentView.addSubview(stockLabel)
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 7).isActive = true
        stockLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stockLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        stockLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
