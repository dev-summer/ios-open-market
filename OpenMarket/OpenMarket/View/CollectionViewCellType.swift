//  CollectionViewCellType.swift
//  OpenMarket
//  Created by Jiyoung Lee on 2022/12/06.

import UIKit

protocol CollectionViewCellType: AnyObject {
    static var identifier: String { get }
    var product: Product? { get }
    var task: URLSessionDataTask? { get set }
    
    var productImageView: UIImageView { get set }
    var productNameLabel: UILabel { get }
    var stockLabel: UILabel { get }
    var priceLabel: UILabel { get }
    var bargainPriceLabel: UILabel { get }
}

extension CollectionViewCellType {
    func updateContents(_ product: Product) {
        self.productNameLabel.text = product.name
        self.updatePriceLabel(product)
        self.updateStockLabel(product)
    }

    func updateImage(_ product: Product) {
        guard let url = URL(string: product.thumbnailURL) else { return }
        fetchImage(url) { image in
            DispatchQueue.main.async {
                if self.product == product {
                    self.productImageView.image = image
                }
            }
        }
    }
    
    private func fetchImage(_ url: URL, completion: @escaping (UIImage) -> Void) {
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else { return }
            
            guard let data else { return }
            
            guard let image = UIImage(data: data) else { return }
            
            completion(image)
        }
        
        task?.resume()
    }
    
    private func updatePriceLabel(_ product: Product) {
        priceLabel.attributedText = product.price.formatPrice(product.currency)
            .flatMap { NSAttributedString(string: $0) }
        
        bargainPriceLabel.attributedText = product.bargainPrice.formatPrice(product.currency)
            .flatMap { NSAttributedString(string: $0) }
        
        bargainPriceLabel.isHidden = product.price == product.bargainPrice

        if product.price != product.bargainPrice {
            priceLabel.attributedText = product.price.formatPrice(product.currency)?.invalidatePrice()
        }
    }
    
    private func updateStockLabel(_ product: Product) {
        guard product.stock > 0 else {
            stockLabel.attributedText = StockStatus.soldOut.rawValue.markSoldOut()
            return
        }
        
        if product.stock > 10_000 {
            stockLabel.attributedText = NSAttributedString(string: StockStatus.enoughStock.rawValue)
            return
        }
        
        let remainingStock = StockStatus.remainingStock.rawValue + " : " + (Double(product.stock).formatToDecimal() ?? StockStatus.stockError.rawValue)
        
        stockLabel.attributedText = NSAttributedString(string: remainingStock)
    }

}