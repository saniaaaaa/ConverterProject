//
//  ViewController.swift
//  converterApp
//
//  Created by iglo on 06/10/21.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - OUTLET
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var chooseButton: UIButton!
    
    //MARK: - VARIABEL
    var viewModel : CurrencyViewModel!
    
    //MARK: - ViewDid
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
        currencyTableView.register(UINib(nibName: "CurrencyTableViewCell", bundle: nil), forCellReuseIdentifier: "CurrencyTableViewCell")
        
        viewModel = CurrencyViewModel(currencyService: CurrencyService())
        viewModel.updateLoadingStatus = {
            DispatchQueue.main.async {
                let _ = self.viewModel.isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.showAlertClosure = {
            DispatchQueue.main.async {
                if let error = self.viewModel.error {
                    self.showAlert(title: "Failed", message: error)
                }
            }
        }
        viewModel.didFinishFetch = {
            DispatchQueue.main.async {
                self.currencyTableView.reloadData()
            }
        }
        
    }
    
    //MARK: - Action
    @IBAction func chooseCurrencyDidTap(_ sender: Any) {
        performSegue(withIdentifier: "toSelectCurrency", sender: self)
    }
    
    //MARK: - Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSelectCurrency"{
            let vc = segue.destination as! CurrencyViewController
            vc.delegate = self
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCurrencyList()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell", for: indexPath) as! CurrencyTableViewCell
        let abbreviation = viewModel.sortedCurrencyListAt(index: indexPath.row).abbreviation ?? ""
        let amount = viewModel.sortedCurrencyListAt(index: indexPath.row).amount ?? ""
        
        cell.currencyLabel.text = viewModel.sortedCurrencyListAt(index: indexPath.row).currency
        cell.abbreviationLabel.text = abbreviation
        cell.amountLabel.text = abbreviation + " " + amount
        
        return cell
    }
}

extension ViewController: GetCurrencySelectedProtocol{
    func getCurrency(currency: String) {
        chooseButton.setTitle(currency, for: .normal)
        self.viewModel.convert(amount: amountTextField.text ?? "", from: currency)
        viewModel.updateLoadingStatus = {
            DispatchQueue.main.async {
                let _ = self.viewModel.isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.showAlertClosure = {
            DispatchQueue.main.async {
                if let error = self.viewModel.error {
                    self.showAlert(title: "Failed", message: error)
                }
            }
        }
        
        self.viewModel.didFinishFetch = {
            DispatchQueue.main.async {
                self.currencyTableView.reloadData()
            }
        }
    }
    
    
}
