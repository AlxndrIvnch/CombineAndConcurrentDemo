//
//  MainCoordinator.swift
//  Combine&ConcurrentDemo
//
//  Created by alexander.ivanchenko on 28.03.2023.
//

import UIKit

protocol MainCoordinatorTransitions: AnyObject {}

protocol MainCoordinatorType: AnyObject {}

class MainCoordinator: TabBarCoordinatable {
    private weak var navigationController: UINavigationController!
    private weak var transitions: MainCoordinatorTransitions?
    
    lazy var rootVC: UIViewController = {
        let mainVC: MainVC = UIStoryboard.main.instantiate()
        mainVC.viewModel = MainVM()
        
        let navigationController = UINavigationController(rootViewController: mainVC)
        navigationController.tabBarItem = .init(tabBarSystemItem: .downloads, tag: 0)
        self.navigationController = navigationController
        return navigationController
    }()
    
    init(transitions: MainCoordinatorTransitions?) {
        self.transitions = transitions
        DebugPrinter.printInit(for: self)
    }
    
    deinit {
        DebugPrinter.printDeinit(for: self)
    }
}

// MARK: - ProfileTabCoordinatorType -
extension MainCoordinator: MainCoordinatorType {}
