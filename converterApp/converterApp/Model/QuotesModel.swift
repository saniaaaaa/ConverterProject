//
//  Quotes.swift
//  converterApp
//
//  Created by iglo on 06/10/21.
//

import Foundation

struct QuotesData: Decodable{
    var quotes: [String:Double]?
    var success: Bool?
    var error: ErrorData?
}

