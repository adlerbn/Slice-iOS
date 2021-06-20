//
//  HomeViewController.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/12/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 40),
            button.widthAnchor.constraint(equalToConstant: 40)
        ])
        button.tintColor = .label
        return button
    }()
    
    let profileButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "person.circle.fill"), for: .normal)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 40),
            button.widthAnchor.constraint(equalToConstant: 40)
        ])
        button.tintColor = .label
        return button
    }()
    
    let basketButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "tray.fill"), for: .normal)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 40),
            button.widthAnchor.constraint(equalToConstant: 40)
        ])
        button.tintColor = .label
        return button
    }()
    
    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet weak var discountFoodCollectionView: UICollectionView!
    @IBOutlet weak var favoriteFoodCollectionView: UICollectionView!
    @IBOutlet weak var popularFoodCollectionView: UICollectionView!
    
    let widthScreen: CGFloat = {
        UIScreen.main.bounds.width
    }()
    
    let heightScreen: CGFloat = {
        UIScreen.main.bounds.height
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    
}

//MARK: - Help Method
extension HomeViewController {
    func initialize() {
        setupTitleView()
        setupCollectionViews()
    }
    
    fileprivate func setupTitleView() {
        
        let hRightStack = UIStackView(arrangedSubviews: [basketButton, profileButton])
        hRightStack.spacing = 16
        hRightStack.alignment = .center
        
        let hLeftStack = UIStackView(arrangedSubviews: [searchButton, hRightStack])
        NSLayoutConstraint.activate([
            hLeftStack.widthAnchor.constraint(equalToConstant: widthScreen - 60)
        ])
        hLeftStack.alignment = .center
        hLeftStack.distribution = .equalCentering
        
        navigationItem.titleView = hLeftStack
    }
    
    fileprivate func setupCollectionViews() {
        typeCollectionView.register(
            TypeCollectionCell.nib(),
            forCellWithReuseIdentifier: TypeCollectionCell.identifier
        )
        
        discountFoodCollectionView.register(
            ItemCollectionCell.nib(),
            forCellWithReuseIdentifier: ItemCollectionCell.identifier
        )
        
        favoriteFoodCollectionView.register(
            ItemCollectionCell.nib(),
            forCellWithReuseIdentifier: ItemCollectionCell.identifier
        )
        
        popularFoodCollectionView.register(
            ItemCollectionCell.nib(),
            forCellWithReuseIdentifier: ItemCollectionCell.identifier
        )
    }
}

//MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == typeCollectionView {
            return 5
        }
        
        return 5
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == typeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeCollectionCell.identifier, for: indexPath) as! TypeCollectionCell
            
            cell.typeTitleLabel.text = "Pizza"
            cell.typeImageView.image = UIImage(named: "salad")
            cell.layer.cornerRadius = 25
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionCell.identifier, for: indexPath) as! ItemCollectionCell
        cell.itemTitleLabel.text = "Pizza"
        cell.itemPriceLabel.text = "$93"
        cell.itemImageView.image = UIImage(named: "Slice")
        cell.layer.cornerRadius = 25
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == typeCollectionView {
            if let cell = collectionView.cellForItem(at: indexPath) as? TypeCollectionCell {
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TypeCollectionCell {
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView == typeCollectionView {
            return
                CGSize(width: 100, height: 130)
        }
        
        return
            CGSize(width: 180, height: 250)
        
    }
}
