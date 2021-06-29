//
//  HomeViewController.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/12/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet weak var specialOfferCollectionView: UICollectionView!
    @IBOutlet weak var highestScoreCollectionView: UICollectionView!
    @IBOutlet weak var bestSellingCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var apiManager: ApiManager?
    var categories: [Category] = [
        .Pizza,
        .Sandwich,
        .Salad,
        .Baverage,
        .Sandwich,
        .Appetizer,
        .Sauce
    ]
    var specialOfferData: [Food] = []
    var highestScoreData: [Food] = []
    var bestSellingData: [Food] = []
    
    var specialOfferCount: Int?
    var highestScoreCount: Int?
    var bestSellingCount: Int?
    
    var foodSelectedId: Int?
    var categorySelected: Category?
    
    let widthScreen: CGFloat = {
        UIScreen.main.bounds.width
    }()
    
    let heightScreen: CGFloat = {
        UIScreen.main.bounds.height
    }()
    
    var refreshControl: UIRefreshControl!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }
    
    @objc func refresh()
    {
        // Code to refresh table view
        refreshControl.endRefreshing()
        reloadCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        sendingFoodsLoadingAlert()
        perform(#selector(reloadCollectionView), with: self, afterDelay: 4)
    }
    
}
//MARK: - API Delegate
extension HomeViewController: ApiManagerDelegateHome {
    func didUpdateFoodItems(with foodsData: FoodsData, apiType: ApiType) {
        print("didUpdateFoodItems")
        
        switch apiType {
        case .specialOffer:
            specialOfferData = foodsData.foodItems
            specialOfferCount = 5
        case .highestScores:
            highestScoreData = foodsData.foodItems
            highestScoreCount = 5
        case .bestSelling:
            bestSellingData = foodsData.foodItems
            bestSellingCount = 5
        default:
            print("ERROR TYPE")
        }
    }
    
    func foodsRequest(apiType: ApiType) {
        print("foodsRequest")
        apiManager = ApiManager(type: apiType, httpMethod: .GET)
        apiManager?.getFoodsList(limit: 100, page: 1)
        apiManager?.delegateHome = self
    }
    
    func sendingFoodsLoadingAlert() {
        
        DispatchQueue.main.async {
            self.foodsRequest(apiType: .specialOffer)
            self.foodsRequest(apiType: .bestSelling)
            self.foodsRequest(apiType: .highestScores)
        }
        
        let loader = self.loadAlert(message: "Loading Foods", animationName: .loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            loader.dismiss(animated: true)
        }
    }
}


//MARK: - Help Method
extension HomeViewController {
    func initialize() {
        setupCollectionViews()
    }
    
    fileprivate func setupCollectionViews() {
        print("setupCollectionViews")
        typeCollectionView.register(
            TypeCollectionCell.nib(),
            forCellWithReuseIdentifier: TypeCollectionCell.identifier
        )
        
        specialOfferCollectionView.register(
            HomeItemCollectionCell.nib(),
            forCellWithReuseIdentifier: HomeItemCollectionCell.identifier
        )
        
        highestScoreCollectionView.register(
            HomeItemCollectionCell.nib(),
            forCellWithReuseIdentifier: HomeItemCollectionCell.identifier
        )
        
        bestSellingCollectionView.register(
            HomeItemCollectionCell.nib(),
            forCellWithReuseIdentifier: HomeItemCollectionCell.identifier
        )
    }
    
    @objc func reloadCollectionView() {
        DispatchQueue.main.async {
            self.specialOfferCollectionView.reloadData()
            self.bestSellingCollectionView.reloadData()
            self.highestScoreCollectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "goToDetails":
            print("goToDetails")
            let vc = segue.destination as! DetailsViewController
            vc.foodSelectedId = foodSelectedId
        case "goToSpecialOfferList":
            let vc = segue.destination as! CategoryViewController
            vc.foodItems = specialOfferData
            vc.titleCategory = "Special Offer"
        case "goToBestSellingList":
            let vc = segue.destination as! CategoryViewController
            vc.foodItems = bestSellingData
            vc.titleCategory = "Best Selling"
        case "goToHighestScoreList":
            let vc = segue.destination as! CategoryViewController
            vc.foodItems = highestScoreData
            vc.titleCategory = "Highest Score"
        case "goToWishList":
            let vc = segue.destination as! CategoryViewController
            vc.foodItems = []
            vc.titleCategory = "Wish List"
        case "goToBasketList":
            let vc = segue.destination as! CategoryViewController
            vc.foodItems = []
            vc.titleCategory = "Basket"
        case "goToCategoryList":
            let vc = segue.destination as! CategoryViewController
            vc.categorySelected = categorySelected
            vc.titleCategory = categorySelected?.rawValue
        default:
            print("Another Segue")
        }
    }
}

//MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case typeCollectionView:
            return categories.count
        case specialOfferCollectionView:
            return specialOfferCount ?? 0
        case highestScoreCollectionView:
            return highestScoreCount ?? 0
        case bestSellingCollectionView:
            return bestSellingCount ?? 0
        default:
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == typeCollectionView {
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: TypeCollectionCell.identifier, for: indexPath) as! TypeCollectionCell

            cell1.typeTitleLabel.text = categories[indexPath.row].rawValue
            cell1.typeImageView.image = UIImage(named: "\(categories[indexPath.row])")
            cell1.layer.cornerRadius = 25
            
            cell1.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
            UIView.animate(withDuration: 0.2, animations: {
                cell1.layer.transform = CATransform3DMakeScale(1,1,1)
            })
            
            return cell1
        } else if collectionView == specialOfferCollectionView {

            if !specialOfferData.isEmpty {
                let food = specialOfferData[indexPath.row]

                let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: HomeItemCollectionCell.identifier, for: indexPath) as! HomeItemCollectionCell
                let url = URL(string: food.picture)
                ImageDownloader.getData(from: url!) { data, response, error in
                    guard let data = data, error == nil else { return }
                    // always update the UI from the main thread
                    DispatchQueue.main.async() {
                        cell2.homeItemImageView.image = UIImage(data: data)
                    }
                }
                
                if food.discount == 0 {
                    cell2.homeItemDiscountLabel.isHidden = true
                    cell2.discountIcon.isHidden = true
                } else {
                    cell2.homeItemDiscountLabel.text = "\(food.discount)"
                }
                
                cell2.homeItemTitleLabel.text = food.name
                cell2.homeItemPriceLabel.text = "$\(food.price)"
                cell2.homeItemScoreLabel.text = "\(food.score)"
                cell2.foodId = food.id
                cell2.visualEffect.layer.cornerRadius = 20
                cell2.visualEffect.layer.maskedCorners = [.layerMinXMaxYCorner]
                cell2.homeItemImageView.layer.cornerRadius = 20
                cell2.homeItemImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                cell2.contentView.backgroundColor = .red
                cell2.layer.cornerRadius = 20
                
                cell2.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
                UIView.animate(withDuration: 0.2, animations: {
                    cell2.layer.transform = CATransform3DMakeScale(1,1,1)
                })
                
                return cell2
            }
        } else if collectionView == highestScoreCollectionView {
            if !highestScoreData.isEmpty {
                let food = highestScoreData[indexPath.row]

                let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: HomeItemCollectionCell.identifier, for: indexPath) as! HomeItemCollectionCell
                let url = URL(string: food.picture)
                ImageDownloader.getData(from: url!) { data, response, error in
                    guard let data = data, error == nil else { return }
                    // always update the UI from the main thread
                    DispatchQueue.main.async() {
                        cell3.homeItemImageView.image = UIImage(data: data)
                    }
                }
                
                if food.discount == 0 {
                    cell3.homeItemDiscountLabel.isHidden = true
                    cell3.discountIcon.isHidden = true
                } else {
                    cell3.homeItemDiscountLabel.text = "\(food.discount)"
                }
                
                cell3.homeItemTitleLabel.text = food.name
                cell3.homeItemPriceLabel.text = "$\(food.price)"
                cell3.homeItemScoreLabel.text = "\(food.score)"
                cell3.foodId = food.id
                cell3.visualEffect.layer.cornerRadius = 20
                cell3.visualEffect.layer.maskedCorners = [.layerMinXMaxYCorner]
                cell3.homeItemImageView.layer.cornerRadius = 20
                cell3.homeItemImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                cell3.layer.cornerRadius = 20
                
                cell3.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
                UIView.animate(withDuration: 0.2, animations: {
                    cell3.layer.transform = CATransform3DMakeScale(1,1,1)
                })
                
                return cell3
            }
        } else if collectionView == bestSellingCollectionView {
            if !bestSellingData.isEmpty {
                let food = bestSellingData[indexPath.row]

                let cell4 = collectionView.dequeueReusableCell(withReuseIdentifier: HomeItemCollectionCell.identifier, for: indexPath) as! HomeItemCollectionCell
                let url = URL(string: food.picture)
                ImageDownloader.getData(from: url!) { data, response, error in
                    guard let data = data, error == nil else { return }
                    // always update the UI from the main thread
                    DispatchQueue.main.async() {
                        cell4.homeItemImageView.image = UIImage(data: data)
                    }
                }
                
                if food.discount == 0 {
                    cell4.homeItemDiscountLabel.isHidden = true
                    cell4.discountIcon.isHidden = true
                } else {
                    cell4.homeItemDiscountLabel.text = "\(food.discount)"
                }
                
                cell4.homeItemTitleLabel.text = food.name
                cell4.homeItemPriceLabel.text = "$\(food.price)"
                cell4.homeItemScoreLabel.text = "\(food.score)"
                cell4.foodId = food.id
                cell4.visualEffect.layer.cornerRadius = 20
                cell4.visualEffect.layer.maskedCorners = [.layerMinXMaxYCorner]
                cell4.homeItemImageView.layer.cornerRadius = 20
                cell4.homeItemImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                cell4.layer.cornerRadius = 20
                
                cell4.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
                UIView.animate(withDuration: 0.2, animations: {
                    cell4.layer.transform = CATransform3DMakeScale(1,1,1)
                })
                
                return cell4
            }
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeItemCollectionCell.identifier, for: indexPath) as! HomeItemCollectionCell
        cell.homeItemTitleLabel.text = "name"
        cell.homeItemPriceLabel.text = "$price"
        cell.homeItemImageView.image = UIImage(named: "pizza_loader")
        cell.layer.cornerRadius = 20
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == typeCollectionView {
            categorySelected = categories[indexPath.row]
            performSegue(withIdentifier: "goToCategoryList", sender: self)
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as! HomeItemCollectionCell
            foodSelectedId = cell.foodId
            performSegue(withIdentifier: "goToDetails", sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
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
