//
//  BaseViewController.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 14/03/24.
//

import UIKit

// The default superclass for each view controller you want to inherit from
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

}

// MARK: - Helper Views
extension BaseViewController {

    func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
