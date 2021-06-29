//
//  DetailsViewController.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/12/21.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var favoriteView: UIView!
    @IBOutlet var shadowViews: [UIView]!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var commentTableView: UITableView!
    
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodSize: UILabel!
    @IBOutlet weak var preparationTime: UILabel!
    @IBOutlet weak var foodDetails: UILabel!
    @IBOutlet weak var foodScoreLabel: UILabel!
    @IBOutlet weak var foodCommentsLabel: UILabel!
    
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var plusAmountButton: UIButton!
    @IBOutlet weak var minusAmountButton: UIButton!
    
    var apiManager: ApiManager?
    var foodSelectedId: Int?
    var food: AdvanceFood?
    var foodForBuy: FoodCoreData?
    var comments: [Comment]?
    var amountFood: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initialize()
        perform(#selector(setDetails), with: self, afterDelay: 1.5)
        sendingFoodLoadingAlert()
    }
    
    @IBAction func wishButton(_ sender: UIButton) {
        if sender.currentBackgroundImage == UIImage(named: "Bookmarrk-Solid") {
            sender.setBackgroundImage(UIImage(named: "Bookmarrk-Line"), for: .normal)
        } else {
            sender.setBackgroundImage(UIImage(named: "Bookmarrk-Solid"), for: .normal)
        }
    }
    
}

//MARK: - Help Method
extension DetailsViewController {
    func initialize() {
        initializeUI()
        addTarget()
    }
    
    func initializeUI() {
        setCornerRadius()
        setShadow()
    }
    
    func setCornerRadius() {
        infoView.layer.cornerRadius = 50
        infoView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        blurView.layer.cornerRadius = 15
        topButton.layer.cornerRadius = 2
    }
    
    func setShadow() {
        for shadowView in shadowViews {
            shadowView.layer.shadowColor = UIColor.systemGray4.cgColor
            shadowView.layer.shadowOpacity = 0.2
            shadowView.layer.shadowOffset = .zero
            shadowView.layer.shadowRadius = 5
        }
    }
    
    @objc func setDetails() {
        DispatchQueue.main.async { [self] in
            
            let url = URL(string: food?.picture ?? "")
            
            if let url = url {
                ImageDownloader.getData(from: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    // always update the UI from the main thread
                    DispatchQueue.main.async() {
                        foodImage.image = UIImage(data: data)
                    }
                }
            }
            
            foodName.text = food?.name
            foodSize.text = "(\(food?.size ?? Size.Medium.rawValue))"
            categoryLabel.text = food?.category
            preparationTime.text = "\(food?.preparationTime ?? 10) Min"
            if let details = food?.details {
                foodDetails.text = fixEndLineDetails(details: details)
            }
            foodDetails.numberOfLines = 0
            foodScoreLabel.text = "\(food?.score ?? 0)"
            foodName.text = food?.name
            foodCommentsLabel.text = "\(food?.comments.count ?? 0) Comments"
            orderButton.setTitle("Order for $\(food?.price ?? 15)", for: .normal)
            amountLabel.text = "\(amountFood)"
            
            commentTableView.reloadData()
        }
    }
    
    func addTarget() {
        plusAmountButton.addTarget(self, action: #selector(plusAmount), for: .touchUpInside)
        minusAmountButton.addTarget(self, action: #selector(minusAmount), for: .touchUpInside)
        orderButton.addTarget(self, action: #selector(orderTarget), for: .touchUpInside)
    }
    
    @objc func minusAmount() {
        if amountFood > 1 && amountFood <= 10 {
            DispatchQueue.main.async { [self] in
                amountFood -= 1
                amountLabel.text = "\(amountFood)"
            }
        }
    }
    
    @objc func plusAmount() {
        if amountFood >= 1 && amountFood < 10 {
            DispatchQueue.main.async { [self] in
                amountFood += 1
                amountLabel.text = "\(amountFood)"
            }
        }
    }
    
    @objc func orderTarget() {
        
    }
    
    func fixEndLineDetails(details: String) -> String{
        var fixedString = ""
        fixedString = details.replacingOccurrences(of: "\\n", with: "\n")
        return fixedString
    }
}

//MARK: - API Delegate
extension DetailsViewController: ApiManagerDelegateDetails {
    func didUpdateFoodDetails(with food: AdvanceFood, apiType: ApiType) {
        print("didUpdateFoodDetails")
        self.food = food
        self.comments = food.comments
    }
    
    func foodsRequest(apiType: ApiType) {
        print("foodsRequest")
        if let foodId = foodSelectedId {
            apiManager = ApiManager(type: apiType, httpMethod: .GET)
            apiManager?.getFood(foodId: foodId)
            apiManager?.delegateDetails = self
        }
    }
    
    func sendingFoodLoadingAlert() {
        DispatchQueue.main.async {
            self.foodsRequest(apiType: .food)
        }
        
        let loader = self.loadAlert(message: "Loading Food Details", animationName: .loading)
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) {
            loader.dismiss(animated: true)
        }
    }
}

//MARK: - UITableViewDataSource
extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
        
        let comment = comments?[indexPath.row]
        
        cell.imageView?.image = UIImage(named: "User 2-Solid")
        cell.imageView?.tintColor = .systemGray2
        cell.textLabel?.text = comment?.user.nickname
        cell.detailTextLabel?.text = "\(comment?.content ?? "Details"), \(comment?.createAt ?? "now")"
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        
        return cell
    }
}
