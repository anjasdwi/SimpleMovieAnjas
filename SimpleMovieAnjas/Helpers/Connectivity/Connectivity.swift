//
//  Connectivity.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 16/03/24.
//

import Reachability

protocol ConnectivityInterface {
    var noConnectAction: (()->Void)? { get set }
    var connectAction: (()->Void)? { get set }

    func start()
    func stop()
}

final class Connectivity: ConnectivityInterface {

    let reachability = try! Reachability()

    private var queue = DispatchQueue(label: "Monitor")

    var noConnectAction: (() -> Void)?
    var connectAction: (() -> Void)?

    init() {
        setupUpdater()
    }

    func setupUpdater() {
        reachability.whenReachable = { [weak self] _ in
            guard let self = self else { return }
            self.connectAction?()
        }
        reachability.whenUnreachable = { [weak self] _ in
            guard let self = self else { return }
            self.noConnectAction?()
        }
    }

    func start() {
        do {
            try reachability.startNotifier()
        } catch {
            print("Error start notifier")
        }
    }

    func stop() {
        reachability.stopNotifier()
    }
}

