//
//  ViewController.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 13/03/24.
//

import UIKit

final class HomeViewController: UIViewController {

    let mainView = HomeView()

    override func loadView() {
        self.view = self.mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional     setup after loading the view.
    }

}
