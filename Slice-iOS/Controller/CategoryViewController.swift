//
//  CategoryViewController.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/26/21.
//

import UIKit

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var titleCategory: String?
    var foodItems: [Food]?
    var foodSelectedId: Int?
    var categorySelected: Category?
    
    var apiManager: ApiManager?
    
    var refreshControl: UIRefreshControl!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func refresh()
    {
        // Code to refresh table view
        refreshControl.endRefreshing()
        reloadTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        tableView.register(ItemTableCell.nib(), forCellReuseIdentifier: ItemTableCell.identifier)
        
        if let title = titleCategory {
            titleLabel.text = title
        }
        if categorySelected != nil {
            sendingFoodsLoadingAlert()
            perform(#selector(reloadTableView), with: self, afterDelay: 2)
            
        }
    }
}

//MARK: - API Delegate
extension CategoryViewController: ApiManagerDelegateHome {
    func didUpdateFoodItems(with foodsData: FoodsData, apiType: ApiType) {
        print("didUpdateFoodItems")
        foodItems = foodsData.foodItems
    }
    
    func foodsRequest(apiType: ApiType) {
        print("foodsRequest")
        apiManager = ApiManager(type: apiType, httpMethod: .GET)
        apiManager?.getFoodsList(limit: 100, page: 1, category: categorySelected!)
        apiManager?.delegateHome = self
    }
    
    func sendingFoodsLoadingAlert() {
        
        DispatchQueue.main.async {
            self.foodsRequest(apiType: .foodsList)
        }
        
        let loader = self.loadAlert(message: "Loading Foods", animationName: .loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            loader.dismiss(animated: true)
        }
    }
    
    @objc func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


//MARK: - Help Method
extension CategoryViewController {
    func initialize() {
        addTarget()
    }
    
    func addTarget() {
        backButton.addTarget(self, action: #selector(dismissBackButton), for: .touchUpInside)
    }
    
    @objc func dismissBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "goToDetails":
            print("goToDetails")
            let vc = segue.destination as! DetailsViewController
            vc.foodSelectedId = foodSelectedId
            
        default:
            print("ERROR SEGUE")
        }
    }
    
    func fixEndLineDetails(details: String) -> String{
        var fixedString = ""
        fixedString = details.replacingOccurrences(of: "\\n", with: ", ")
        return fixedString
    }
}

//MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foodItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableCell.identifier, for: indexPath) as! ItemTableCell
        
        let food = foodItems?[indexPath.row]
        let url = URL(string: food?.picture ?? "")
        
        ImageDownloader.getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            // always update the UI from the main thread
            DispatchQueue.main.async() {
                cell.itemImageView.image = UIImage(data: data)
            }
        }
        
        cell.itemTitleLabel.text = food?.name ?? "pizza"
        cell.itemPriceLabel.text = "$\(food?.price ?? 95)"
        
        if food?.details == "Null" {
            cell.itemDetailsLabel.text = ""
        } else {
            if let details = food?.details {
                cell.itemDetailsLabel.text =  fixEndLineDetails(details: details)
            }
        }
        
        if food?.discount == 0 {
            cell.itemDiscountLabel.isHidden = true
            cell.discountIcon.isHidden = true
        } else {
            cell.itemDiscountLabel.text = "\(food?.discount ?? 0)"
        }
        
        cell.itemScoreLabel.text = "\(food?.score ?? 1)"
        cell.itemDiscountLabel.text = "\(food?.discount ?? 0)"
        cell.foodId = food?.id
        
        cell.shadowView.layer.cornerRadius = 10
        cell.itemImageView.layer.cornerRadius = 10
        cell.visualEffect.layer.cornerRadius = 10
        cell.visualEffect.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.2, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ItemTableCell
        foodSelectedId = cell.foodId
        performSegue(withIdentifier: "goToDetails", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
