//
//  SearchViewController.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/26/21.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchText: String?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var foodItems: [Food]?
    var foodSelectedId: Int?
    
    var apiManager: ApiManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        tableView.register(ItemTableCell.nib(), forCellReuseIdentifier: ItemTableCell.identifier)
    }

}

//MARK: - CoreData Method
extension SearchViewController {
//    func fetch() {
//        do {
//            self.foodItems = try context.fetch(FoodCoreData.fetchRequest())
//        } catch let error as NSError {
//            print("fetch error data: \(error), \(error.userInfo)")
//        }
//    }
}

//MARK: - API Delegate
extension SearchViewController: ApiManagerDelegateHome {
    func didUpdateFoodItems(with foodsData: FoodsData, apiType: ApiType) {
        print("didUpdateFoodItems")
        foodItems = foodsData.foodItems
    }
    
    func foodsRequest(apiType: ApiType, searchText: String) {
        print("foodsRequest")
        apiManager = ApiManager(type: apiType, httpMethod: .GET)
        apiManager?.getFoodsList(limit: 100, page: 1, search: searchText)
        apiManager?.delegateHome = self
    }
    
    func sendingFoodsLoadingAlert(with searchText: String) {

        DispatchQueue.main.async {
            self.foodsRequest(apiType: .foodsList, searchText: searchText)
        }

        let loader = self.loadAlert(message: "Loading Foods", animationName: .loading)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
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
extension SearchViewController {
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
extension SearchViewController: UITableViewDataSource {
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
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ItemTableCell
        foodSelectedId = cell.foodId
        performSegue(withIdentifier: "goToDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: - UITableViewDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        if let text = searchText {
            if text != "" {
                sendingFoodsLoadingAlert(with: text)
                perform(#selector(reloadTableView), with: self, afterDelay: 2)
            }
        }
        
    }
}
