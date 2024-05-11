//
//  ViewController.swift
//  tanmayChandraNathNearbyMockApp
//
//  Created by Tanmay Chandra Nath on 11/05/24.
//

import UIKit

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var radiusText: UILabel!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    
    var viewModel = HomeScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchDataAfterFetchingLocation()
        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.dataSource = self
        viewModel.delegate = self
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        viewModel.updateRange(newRange: Double(radiusSlider.value))
        updateText()
    }
    
    func updateText() {
        DispatchQueue.main.async {
            self.radiusText.text = "Restaurants within \(self.radiusSlider.value) Kms of of current Location"
        }
    }
    
    
    func showLoader() {
        loaderView.isHidden = false
        loaderView.startAnimating()
    }
    
    func hideLoader() {
        loaderView.stopAnimating()
        loaderView.isHidden = true
    }

}

extension HomeScreenViewController: HomeScreenViewControllerProtocol {
    func startedFetchingData() {
        DispatchQueue.main.async {
            self.showLoader()
        }
    }
    
    func gotData() {
        DispatchQueue.main.async {
            self.hideLoader()
            self.tableView.reloadData()
        }
    }
    
    func gotError(error: Error) {
        DispatchQueue.main.async {
            self.hideLoader()
            self.tableView.reloadData()
        }
    }
}

extension HomeScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath)  as? LocationTableViewCell else {return UITableViewCell()}
        cell.configure(header: viewModel.fetchedData?.venues?[indexPath.row].name, bottom: viewModel.fetchedData?.venues?[indexPath.row].address)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.fetchedData?.venues?.count ?? 0
    }
    
    
}


extension HomeScreenViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.updateQuery(newQuery: searchText)
    }
}
