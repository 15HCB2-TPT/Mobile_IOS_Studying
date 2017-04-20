//
//  Control.swift
//  QuanLyQuanAn
//
//  Created by Phạm Tú on 4/17/17.
//  Copyright © 2017 Shin-MacDesk. All rights reserved.
//

import UIKit

extension UIViewController {
    func addDoneButton() -> UIToolbar {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(title: "Xong", style: .plain, target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        return keyboardToolbar
    }
    
    func alert(title: String, msg: String, btnTitle: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: btnTitle, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func conform(title: String, msg: String, btnOKTitle: String, btnCancelTitle: String, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: btnOKTitle, style: UIAlertActionStyle.default, handler: handler))
        alert.addAction(UIAlertAction(title: btnCancelTitle, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension AppDelegate {
    static func restart(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = storyboard.instantiateInitialViewController()
    }
}
