//
//  AlertExtension.swift
//  WordleGameWithMvvm
//
//  Created by Mustafa Çiçek on 16.08.2022.
//

import Foundation
import UIKit


extension UIViewController {
    func customAlert(title : String, message : String ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        
        alertController.addAction(action)
        self.present(alertController, animated: true)
        
    }
}
