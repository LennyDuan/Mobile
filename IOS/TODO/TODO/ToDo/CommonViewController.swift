//
//  CommonViewController.swift
//  ToDo
//
//  Created by 段鸿易 on 12/22/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import UIKit

class CommonViewController: UIViewController {

    // HideKeyboard when tap around
    func hideKeyboardWhenTappedArround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(CommonViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Back to last page
    func dismiss() {
        navigationController?.popToRootViewController(animated: true)
    }
}
