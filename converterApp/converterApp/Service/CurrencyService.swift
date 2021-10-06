//
//  CurrencyService.swift
//  converterApp
//
//  Created by iglo on 06/10/21.
//

import Foundation

class CurrencyService{
    // MARK: - Properties
    static let shared = CurrencyService()
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    // MARK: - Methods
    
    func getAllCurrency(completion: @escaping (CurrencyData?, Error?) -> ()) {
        dataTask?.cancel()
        
        if let urlComponents = URLComponents(string: baseURL + "list?access_key=" + accessKey) {
            guard let url = urlComponents.url else {
                return
            }
            
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(nil,error)
                }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    do {
                        let currencyData = try JSONDecoder().decode(CurrencyData.self, from: data)
                        
                        completion(currencyData,nil)
                    } catch {
                        completion(nil,error)
                    }
                }
            }
            
            dataTask?.resume()
        }
    }
    
    func convertCurrency(amount: String, from: String, completion: @escaping (QuotesData?, Error?) -> ()) {
        dataTask?.cancel()
        
        if let urlComponents = URLComponents(string: baseURL + "live?access_key=" + accessKey + "&from=\(from)&amount=\(amount)") {
            
            guard let url = urlComponents.url else {
                return
            }
            
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(nil,error)
                }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    do {
                        let quotesData = try JSONDecoder().decode(QuotesData.self, from: data)
                        completion(quotesData,nil)
                    } catch {
                        completion(nil,error)
                    }
                }
            }
            
            dataTask?.resume()
        }
    }
    
}
