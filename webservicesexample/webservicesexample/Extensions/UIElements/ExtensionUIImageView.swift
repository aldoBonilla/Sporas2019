//
//  ExtensionUIImageView.swift
//  webservicesexample
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 11/7/19.
//  Copyright © 2019 aldoBonilla. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadImage(from url: String, placeholder: String? = nil) {
        
        if let placeholder = placeholder {
            self.image = UIImage(named: placeholder)
        }

        WSWrapper.shared.downloadImage(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
    }
}
