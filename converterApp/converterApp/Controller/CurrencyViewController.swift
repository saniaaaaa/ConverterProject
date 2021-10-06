//
//  CurrencyViewController.swift
//  converterApp
//
//  Created by iglo on 06/10/21.
//

import UIKit

protocol GetCurrencySelectedProtocol {
    func getCurrency(currency: String)
}

class CurrencyViewController: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - VARIABEL
    var viewModel : CurrencyViewModel!
    var delegate: GetCurrencySelectedProtocol?
    
    //MARK: - ViewDid
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "CurrencyTableViewCell", bundle: nil), forCellReuseIdentifier: "CurrencyTableViewCell")
        
        viewModel = CurrencyViewModel(currencyService: CurrencyService())
        viewModel.updateLoadingStatus = {
            DispatchQueue.main.async {
                let _ = self.viewModel.isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.showAlertClosure = {
            if let error = self.viewModel.error {
                self.showAlert(title: "Failed", message: error)
            }
        }
        
        viewModel.didFinishFetch = {
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
    }
    
}

extension CurrencyViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCurrencyList()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell", for: indexPath) as! CurrencyTableViewCell
        cell.currencyLabel.text = viewModel.sortedCurrencyListAt(index: indexPath.row).currency
        cell.abbreviationLabel.text = viewModel.sortedCurrencyListAt(index: indexPath.row).abbreviation
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            self.delegate?.getCurrency(currency: self.viewModel.sortedCurrencyListAt(index: indexPath.row).abbreviation ?? "")
        }
    }
    
}
