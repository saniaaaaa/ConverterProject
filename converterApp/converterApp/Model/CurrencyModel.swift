//
//  Currency.swift
//  converterApp
//
//  Created by iglo on 06/10/21.
//

import Foundation

struct CurrencyData: Decodable{
    var currencies: [String:String]?
}

struct Currency{
    var abbreviation:String?
    var currency:String?
    var amount:String?
}

