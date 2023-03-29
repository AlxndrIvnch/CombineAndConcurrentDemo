//
//  HistoryCoordinator.swift
//  Combine&ConcurrentDemo
//
//  Created by alexander.ivanchenko on 28.03.2023.
//

import UIKit

protocol HistoryCoordinatorTransitions: AnyObject {}

protocol HistoryCoordinatorType: AnyObject {
    func showTestDetails(with testInfo: TestInfo)
}

class HistoryCoordinator: TabBarCoordinatable {
    private weak var navigationController: UINavigationController!
    private weak var transitions: HistoryCoordinatorTransitions?
    
    lazy var rootVC: UIViewController = {
        let historyVC = HistoryTVC(style: .plain)
        historyVC.viewModel = HistoryVM(coordiantor: self)
        
        let navigationController = UINavigationController(rootViewController: historyVC)
        navigationController.tabBarItem = .init(tabBarSystemItem: .history, tag: 0)
        self.navigationController = navigationController
        return navigationController
    }()
    
    init(transitions: HistoryCoordinatorTransitions?) {
        self.transitions = transitions
        DebugPrinter.printInit(for: self)
    }
    
    deinit {
        DebugPrinter.printDeinit(for: self)
    }
}

// MARK: - ProfileTabCoordinatorType -
extension HistoryCoordinator: HistoryCoordinatorType {
    func showTestDetails(with testInfo: TestInfo) {
        let photosGreedVC = PhotosGreedVC()
        photosGreedVC.images = testInfo.images
        photosGreedVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(photosGreedVC, animated: true)
    }
    
}

