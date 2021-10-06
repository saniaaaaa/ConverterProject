//
//  DictionaryExtension.swift
//  converterApp
//
//  Created by iglo on 06/10/21.
//

import Foundation

extension Dictionary {
    subscript(i: Int) -> (key: Key, value: Value) {
        return self[index(startIndex, offsetBy: i)]
    }
    
    
}
