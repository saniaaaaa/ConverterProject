//
//  CurrencyViewModel.swift
//  converterApp
//
//  Created by iglo on 06/10/21.
//

import Foundation

class CurrencyViewModel{
    
    // MARK: - Properties
    private var currencyList: [String:String]?
    private var quoteslist: [String:Double]?
    private var currency: [Currency]?
    private var currencyService: CurrencyService?
    
    var error: String? {
        didSet { self.showAlertClosure?() }
    }
    
    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }
    
    // MARK: - Closures for callback
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    init(currencyService: CurrencyService) {
        self.currencyService = currencyService
        self.getCurrency()
    }
    
    // MARK: - Network call
    private func getCurrency(){
        CurrencyService.shared.getAllCurrency() { (currencyData, error) in
            if let error = error?.localizedDescription {
                self.isLoading = false
                self.error = error
                return
            }
            
            guard let currencyData = currencyData else { return }
            self.currencyList = currencyData.currencies
            
            self.sortedCurrencies()
            self.isLoading = false
            self.didFinishFetch?()
        }
    }
    
    func convert(amount: String, from: String){
        CurrencyService.shared.convertCurrency(amount: amount, from: from) { (quoteData, error) in
            if let error = error?.localizedDescription {
                self.isLoading = false
                self.error = error
                return
            }else if quoteData?.success == false{
                self.isLoading = false
                self.error = quoteData?.error?.info
                return
            }
            
            guard let quoteData = quoteData else { return }
            self.quoteslist = quoteData.quotes
            self.isLoading = false
            self.sortedCurrencies()
            self.didFinishFetch?()
        }
    }
    
    // MARK: - Method
    
    func sortedCurrencies(){
        var allCurr: [Currency] = []
        
        if numberOfCurrencyList() > 0{
            for i in 0...numberOfCurrencyList() - 1{
                let item = currencyAt(index: i)
                allCurr.append(item)
            }
        }
        
        self.currency = allCurr.sorted{ $0.currency ?? "" < $1.currency ?? "" }
    }
    
    func currencyListAt(index: Int) -> (key: String, value: String)?{
        return currencyList?[index]
    }
    
    func quotesListAt(key: String) -> String{
        if let value = quoteslist?["USD\(key)"] {
            return String(value)
        }
        return ""
    }
    
    func currencyAt(index: Int) -> Currency{
        let currency = currencyListAt(index: index)?.value
        let abbreviation = currencyListAt(index: index)?.key
        let amount = quotesListAt(key: abbreviation ?? "")
        return Currency(abbreviation: abbreviation, currency: currency, amount: amount)
    }
    
    //MARK: - TableView Methods
    
    func numberOfCurrencyList() -> Int {
        return currencyList?.count ?? 0
    }
    
    func sortedCurrencyListAt(index: Int) -> Currency{
        return currency?[index] ?? Currency()
    }
    
}
