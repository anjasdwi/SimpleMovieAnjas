//
//  AppDelegate.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 13/03/24.
//

import UIKit
import SnapKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let initialViewController = getInitialViewController()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: initialViewController)
        self.window?.makeKeyAndVisible()

        setupNavBarAppearance()

        return true
    }

    private func setupNavBarAppearance() {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = UIColor.white
            navBarAppearance.shadowColor = .clear
            navBarAppearance.shadowImage = UIImage()
            navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            UINavigationBar.appearance().standardAppearance = navBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        }
    }

    private func getInitialViewController() -> UIViewController {
        let viewModel = HomeViewModel()
        return HomeViewController.create(withViewModel: viewModel)
    }

}

