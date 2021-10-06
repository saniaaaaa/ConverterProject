//
//  UIViewControllerExtension.swift
//  converterApp
//
//  Created by iglo on 06/10/21.
//

import UIKit

extension UIViewController {
    
    func showAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
